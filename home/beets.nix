{ config, lib, pkgs, ... }:

let
  aunique = "%aunique{albumartist album,albumtype label catalognum albumdisambig releasegroupdisambig}";
in
{
  programs.beets = {
    enable = true;
    settings = {
      directory = "~/Music";
      library = "~/Music/library.db";
      import = {
        copy = true;
        write = true;
      };
      ui.color = true;

      paths = {
        default = "$albumartist - $album${aunique} ($year)/$track $title";
        singleton = "Singles/$artist - $title ($year)";
        comp = "Compilations/$album${aunique} ($year)/$track $title";
        "albumtype:soundtrack" = "Soundtracks/$album${aunique} ($year)/$track $title";
      };

      plugins = "ftintitle";

      ftintitle = {
        auto = true;
        format = "(ft. {0})";
      };
    };
  };
}
