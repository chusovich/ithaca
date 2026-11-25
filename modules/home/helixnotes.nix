{ config, ... }:

let
  vaultPath = "${config.home.homeDirectory}/Documents/notes";

  settings = {
    vaults = [
      {
        path = vaultPath;
        name = "notes";
      }
    ];
    active_vault = vaultPath;
    theme = "system";
    accent_color = "#0969da";
    autostart = true;
    ai_model = "";
    new_notes_in_source_mode = true;
  };
in
{
  # HelixNotes atomically replaces this file when saving; Home Manager restores these settings on
  # activation. Keep credentials out because generated text is stored in the world-readable Nix store.
  xdg.configFile."helixnotes/config.json" = {
    text = builtins.toJSON settings;
    # Adopt the existing config and restore the declarative version on activation.
    force = true;
  };
}
