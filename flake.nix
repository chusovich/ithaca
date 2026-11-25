{
  description = "A simple NixOS flake for my laptop";

  inputs = {
    # NixOS official package source, using the nixos-26.05 stable branch
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    }; 
    # Zen browser (kept on its own nixos-unstable input for libgbm compatibility)
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs-unstable";
      };
    };
    # Unstable nixpkgs for select packages that need newer versions
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # OpenCode from upstream dev branch
    opencode = {
      url = "github:anomalyco/opencode";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    # HelixNotes desktop notes application
    helixnotes.url = "gitlab:ArkHost/HelixNotes";
    # MCP-NixOS from upstream main branch.
    # Follows the stable nixpkgs input because its overlay currently builds
    # cleanly there; tracking nixos-unstable hits a broken fastmcp_slim path.
    mcp-nixos = {
      url = "github:utensils/mcp-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    pkgs-unstable = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations = {
      odysseus = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit pkgs-unstable inputs; };
        modules = [
          ./configuration.nix

          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };

            home-manager.users.calebh = import ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      };
    };
  };
}
