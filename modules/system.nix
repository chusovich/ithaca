{ pkgs, ... }:

{
  # Set time zone
  time.timeZone = "America/New_York";

  # Enable flakes.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # For building raspberry pi flakes
  nix.settings.extra-substituters = [ "https://nixos-raspberrypi.cachix.org" ];
  nix.settings.extra-trusted-public-keys = [ "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI=" ];

  # Enable arm/raspi builds.
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nix.settings.extra-platforms = [ "aarch64-linux" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  # Keep the state version from the original system configuration.
  system.stateVersion = "25.11";
}
