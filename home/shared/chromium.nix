{...}: {
  programs.chromium = {
    enable = true;
    extensions = [
      "nngceckbapebfimnlniiiahkandclblb" # bitwarden
      "gcbommkclmclpchllfjekcdonpmejbdp" # https everywhere
      "fmkadmapgofadopljbjfkapdkoienihi" # react devtools
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
    ];
  };
}
