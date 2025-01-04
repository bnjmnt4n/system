{...}: {
  # LightDM.
  # TODO: look into a more lightweight solution like greetd in the future.
  services.xserver = {
    enable = true;
    layout = "us";
    libinput.enable = true;
    # Configure DPI for my laptop.
    # Reference: https://gist.github.com/domenkozar/b3c945035af53fa816e0ac460f1df853#x-server-resolution
    # TODO: should this be in a separate specialized module?
    monitorSection = ''
      DisplaySize 338 190
    '';
    displayManager.defaultSession = "sway";
    displayManager.lightdm = {
      enable = true;
      # TODO: use a separate repository for background images?
      background = ./background-image.jpg;
      greeters.gtk.indicators = ["~clock" "~session" "~power"];
    };
  };

  security.pam.services.lightdm.enableGnomeKeyring = true;
}
