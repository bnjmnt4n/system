{pkgs, ...}: {
  programs.gpg = {
    enable = true;
    publicKeys = [
      {
        source = pkgs.fetchurl {
          url = "https://github.com/bnjmnt4n.gpg";
          hash = "sha256-2aHsGA9Qak4/DUdbLqU3NRYsT3nkCzpZoQPZRwxzNy8=";
        };
        trust = "full";
      }
      {
        source = pkgs.fetchurl {
          url = "https://github.com/web-flow.gpg";
          hash = "sha256-bor2h/YM8/QDFRyPsbJuleb55CTKYMyPN4e9RGaj74Q=";
        };
        trust = "full";
      }
    ];
  };
}
