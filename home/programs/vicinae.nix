{ ... }:

{
  programs.vicinae = {
    enable = true;

    settings = {
      close_on_focus_loss = false;
      consider_preedit = true;
      pop_to_root_on_close = true;
      favicon_service = "twenty";
      search_files_in_root = true;

      font.normal = {
        size = 14;
        family = "Maple Nerd Font";
      };

      telemetry.system_info = true;

      providers = {
        calculator.enabled = false;
        clipboard.enabled = true;
        core.entrypoints.sponsor.enabled = true;
        power.enabled = false;
      };

      theme = {
        light = {
          name = "vicinae-light";
          icon_theme = "default";
        };
        dark = {
          name = "vicinae-dark";
          icon_theme = "default";
        };
      };

      launcher_window.opacity = 0.98;
    };
  };
}
