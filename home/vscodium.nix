# Based on https://github.com/berbiche/dotfiles/blob/380c847d06acbb992978e3eaa22f28b0890dc3a0/profiles/dev/vscodium.nix.
{ config, lib, pkgs, ... }:

let
  buildVs = ref@{ license ? null, ... }:
    pkgs.vscode-utils.buildVscodeMarketplaceExtension {
      mktplcRef = builtins.removeAttrs ref [ "license" ];
      meta = lib.optionalAttrs (license != null) { inherit license; };
    };

  # Replaces VSCodium's open-vsx with Microsoft's extension gallery
  # This is temporary
  extensionsGallery = builtins.toJSON {
    serviceUrl = "https://marketplace.visualstudio.com/_apis/public/gallery";
    itemUrl = "https://marketplace.visualstudio.com/items";
  };
  vscodium = pkgs.vscodium.overrideAttrs(old: {
    nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [ pkgs.jq ];
    installPhase = old.installPhase or "" + ''
      #FILE=$out/lib/vscode/resources/app/product.json
      FILE=$(find $out -name 'product.json' -print -quit)
      mv $FILE .
      echo "Patching product.json"
      jq <product.json >$FILE '
        with_entries(
          if .key == "extensionsGallery"
          then .value = ${extensionsGallery}
          else .
          end
        )
      '
      if [ $? -eq 0 ]; then
        echo "Patching product.json successfully"
      else
        echo "Patching product.json failed"
      fi
    '';
  });

  custom-packages = {
    editorconfig = buildVs {
      name = "editorconfig";
      publisher = "editorconfig";
      version = "0.16.4";
      sha256 = "sha256-j+P2oprpH0rzqI0VKt0JbZG19EDE7e7+kAb3MGGCRDk=";
    };
  };

  extensions = with pkgs.vscode-extensions; [
    bbenoist.Nix
    redhat.vscode-yaml
    ms-vscode-remote.remote-ssh
    coenraads.bracket-pair-colorizer-2
    # PDF preview using PDF.js
    tomoki1207.pdf
    ms-vsliveshare.vsliveshare
  ]
  ++ lib.attrValues custom-packages;

  package = vscodium;

  finalPackage =
    (pkgs.vscode-with-extensions.override {
      vscode = package;
      vscodeExtensions = extensions;
    }).overrideAttrs (old: {
      inherit (package) pname version;
    });
in
{
  programs.vscode = {
    enable = true;

    package = finalPackage;

    extensions = [];

    userSettings = {
      "editor.cursorSmoothCaretAnimation" = true;
      "editor.fontFamily" = "Iosevka";
      "editor.fontSize" = 16;
      "editor.rulers" = [ 80 ];
      "editor.smoothScrolling" = true;
      "editor.stablePeek" = true;
      "explorer.autoReveal" = false;
      "extensions.autoCheckUpdates" = false;
      "git.suggestSmartCommit" = false;
      "search.collapseResults" = "alwaysCollapse";
      "update.mode" = "none";
      "window.menuBarVisibility" = "toggle";
      "window.restoreWindows" = "none";
      "window.title" = "\${activeEditorShort}\${separator}\${rootName}\${separator}\${appName}";
      "workbench.activityBar.visible" = false;
      "workbench.colorTheme" = "Default Light+";
      "workbench.editor.highlightModifiedTabs" = true;
      "workbench.editor.showTabs" = true;
      "workbench.editor.tabCloseButton" = "off";
      "workbench.editor.untitled.labelFormat" = "name";
      "workbench.list.smoothScrolling" = true;

      # Language settings
      "[nix]"."editor.tabSize" = 2;
    };

    keybindings = [];
  };
}
