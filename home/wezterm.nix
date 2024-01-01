{ config, lib, pkgs, ... }:

{
  programs.wezterm = {
    enable = true;
    package =
      if pkgs.stdenv.hostPlatform.system == "aarch64-darwin"
      # Installed in `environment.systemPackages` for Darwin.
      then pkgs.emptyDirectory
      else pkgs.wezterm;

    extraConfig = ''
      -- TODO: figure out how to maximize all windows (+ remove animation?)
      wezterm.on('gui-attached', function(cmd)
        local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
        window:gui_window():maximize()
      end)

      function get_appearance()
        if wezterm.gui then
          return wezterm.gui.get_appearance()
        end
        return 'Light'
      end

      function scheme_for_appearance(appearance)
        if appearance:find 'Dark' then
          return 'Modus-Vivendi'
        else
          return 'Modus-Operandi'
        end
      end

      return {
        font = wezterm.font_with_fallback({
          'Iosevka',
          { family = 'Symbols Nerd Font Mono', scale = 0.75 },
        }),
        font_size = 20.0,
        color_scheme = scheme_for_appearance(get_appearance()),
        hide_tab_bar_if_only_one_tab = true,
        check_for_updates = false,
      }
    '';
  };
}
