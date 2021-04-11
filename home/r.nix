{ config, lib, pkgs, ... }:

{
  home.packages = [
    (pkgs.rWrapper.override {
      packages = with pkgs.rPackages; [
        Rcmdr
        RcmdrMisc
        ggpmisc
        sem
        rmarkdown
        rgl
        multcomp
        lmtest
        leaps
        aplpack
        reshape2
      ];
    })
  ];
}
