{ ... }:

{
  users.users.calebh = {
    isNormalUser = true;
    description = "Caleb Husovich";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
