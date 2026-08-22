{ ... }:

{
  # Use format-specific readers while keeping both applications themed by Stylix.
  programs = {
    zathura = {
      enable = true;
      # Persist the current page after every page change instead of only on close.
      options.continuous-hist-save = true;
    };
    foliate.enable = true;
  };
}
