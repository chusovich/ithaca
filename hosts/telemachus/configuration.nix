{
  imports = [
    ../../modules/default.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "telemachus";
}
