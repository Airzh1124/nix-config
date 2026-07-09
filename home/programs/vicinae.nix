{ ... }:

{
  programs.vicinae = {
    enable = true;

    settings = {
      close_on_focus_loss = true;
      consider_preedit = true;
      pop_to_root_on_close = true;
      favicon_service = "twenty";
      search_files_in_root = true;

      telemetry.system_info = true;

      providers = {
        calculator.enabled = false;
        clipboard.enabled = true;
        core.entrypoints.sponsor.enabled = true;
        power.enabled = false;
      };
    };
  };
}
