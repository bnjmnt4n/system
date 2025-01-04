{ ... }:

{
  programs.chromium = {
    enable = true;
    extensions = [
      "nngceckbapebfimnlniiiahkandclblb" # bitwarden
      "ldpochfccmkkmhdbclfhpagapcfdljkj" # decentraleyes
      "gcbommkclmclpchllfjekcdonpmejbdp" # https everywhere
      "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" # privacy badger
      "fmkadmapgofadopljbjfkapdkoienihi" # react devtools
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
    ];
  };
}
