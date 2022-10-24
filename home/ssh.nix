{ ... }:

{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "sunfire" = {
        hostname = "sunfire.comp.nus.edu.sg";
        user = "tanb";
      };
      "stu" = {
        hostname = "stu.comp.nus.edu.sg";
        user = "tanb";
      };
      "xcn??" = {
        hostname = "%h";
        user = "tanb";
        proxyJump = "sunfire";
      };
      "xgp??" = {
        hostname = "%h";
        user = "tanb";
        proxyJump = "sunfire";
      };
      "soctf*" = {
        hostname = "%h";
        user = "tanb";
        proxyJump = "stu";
      };
    };
  };
}
