{
  imports = [
    ../../modules/default.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "odysseus";
  networking.wireless.enable = true;
}
