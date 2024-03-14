{ config, lib, pkgs, inputs, ... }:

{
  programs.helix = {
    enable = true;
    settings = {
      theme = "base16";
      editor = {
        line-number = "relative";
        lsp.display-messages = true;
      };
      keys.normal = {
        space.space = "file_picker";
        esc = [ "collapse_selection" "keep_primary_selection" ];
      };
    };
  };
}
