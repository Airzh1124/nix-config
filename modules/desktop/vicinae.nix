{ inputs, ... }:

{
  nix.settings = {
    # Behind noctalia (20) but ahead of cache.nixos.org (40).
    extra-substituters = [ "https://vicinae.cachix.org?priority=30" ];
    extra-trusted-public-keys = [
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
    ];
  };

  hm.imports = [ inputs.vicinae.homeManagerModules.default ];

  hm.programs.vicinae = {
    enable = true;

    settings = {
      tray.enabled = false;
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
