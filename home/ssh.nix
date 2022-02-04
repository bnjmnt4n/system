{ ... }:

{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "sunfire" = {
        hostname = "sunfire.comp.nus.edu.sg";
        user = "tanb";
      };
      "xcn??" = {
        hostname = "%h";
        user = "tanb";
        proxyJump = "sunfire";
      };
    };
  };
}
