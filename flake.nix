{
  description = "NixOS flake for my workstations";

  inputs = {
    # Use one unstable package set throughout the configuration.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Unstable Home Manager, kept on the same nixpkgs input.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Zen Browser uses the same nixpkgs as the system.
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };
    # HelixNotes desktop notes application
    helixnotes = {
      url = "gitlab:ArkHost/HelixNotes";
 #     inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    helixnotesOverlay = _final: _prev: {
      # Current upstream has stale Cargo and pnpm hashes.
      helixnotes = inputs.helixnotes.packages.${system}.default.overrideAttrs (old: {
        cargoHash = "sha256-HibZ67q9ayNx1k/utdyCbifTRWFggM3DH8caiFfiZyg=";
        cargoDeps = old.cargoDeps.overrideAttrs (deps: {
          vendorStaging = deps.vendorStaging.overrideAttrs (_: {
            outputHash = "sha256-HibZ67q9ayNx1k/utdyCbifTRWFggM3DH8caiFfiZyg=";
          });
        });
        pnpmDeps = old.pnpmDeps.overrideAttrs (_: {
          outputHash = "sha256-nYNQNGP83dDW7+Agt/EtbxvfgSGtUEDDrhIniUHoDDk=";
        });
      });
    };

    mkSystem = configuration: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        configuration
        home-manager.nixosModules.home-manager
#        { nixpkgs.overlays = [ helixnotesOverlay ]; }
      ];
    };
  in {
    nixosConfigurations = {
      odysseus = mkSystem ./hosts/odysseus/configuration.nix;
      telemachus = mkSystem ./hosts/telemachus/configuration.nix;
    };
  };
}
