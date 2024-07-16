{ config, lib, pkgs, inputs, ... }:

{
  programs.helix = {
    enable = true;
    settings = {
      theme = "modus_operandi";
      editor = {
        line-number = "relative";
        lsp.display-messages = true;
      };
      keys.normal = {
        space.space = "file_picker";
        esc = [ "collapse_selection" "keep_primary_selection" ];
      };
    };
    languages = {
      language = [
        {
          name = "html";
          language-servers = [ "vscode-html-language-server" "tailwindcss-ls" ];
        }
        {
          name = "css";
          language-servers = [ "vscode-css-language-server" "tailwindcss-ls" ];
        }
        {
          name = "jsx";
          language-servers = [ "typescript-language-server" "tailwindcss-ls" ];
        }
        {
          name = "tsx";
          language-servers = [ "typescript-language-server" "tailwindcss-ls" ];
        }
      ];
    };
  };
}
