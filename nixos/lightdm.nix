{ ... }:

{
  # LightDM.
  # TODO: look into a more lightweight solution like greetd in the future.
  services.xserver = {
    enable = true;
    layout = "us";
    libinput.enable = true;
    displayManager.lightdm = {
      enable = true;
#      background = ./background-image.jpg;
      greeters.gtk.indicators = [ "~clock" "~session" "~power" ];
    };
  };
}
