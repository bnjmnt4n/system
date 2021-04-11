{ pkgs, ... }:

{
  home.packages = [
    pkgs.wofi
  ];

  xdg.configFile."wofi/config".text = ''
    allow_images=true
    allow_markup=true
    insensitive=true
    hide_scroll=true
    lines=10
    no_actions=true
    term=alacritty
  '';

  xdg.configFile."wofi/style.css".text = ''
    window {
      opacity: 0.9;
      font: Source Sans Pro 18px;
      border: 2px solid #2e3440;
      border-radius: 20px;
      background-color: #3b4252;
      color: #eceff4;
    }

    #entry {
      border-radius: 10px;
      padding: 10px;
      overflow: auto;
    }

    #entry:selected {
      background-color: #4c566a;
      color: #2e3440;
    }

    #input {
      height: 30px;
      border: none;
    }

    #img {
      margin-right: 1em;
    }

    #text {
      text-overflow: ellipsis;
    }
  '';
}
