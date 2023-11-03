{ ... }:

{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "*" = {
        extraOptions = {
          "IgnoreUnknown" = "AddKeysToAgent,UseKeychain";
          "AddKeysToAgent" = "yes";
          "UseKeychain" = "yes";
        };
      };
      "stu" = {
        hostname = "stu.comp.nus.edu.sg";
        user = "tanb";
      };
      "xcn??" = {
        hostname = "%h";
        user = "tanb";
        proxyJump = "stu";
      };
      "xgp??" = {
        hostname = "%h";
        user = "tanb";
        proxyJump = "stu";
      };
      "soctf*" = {
        hostname = "%h";
        user = "tanb";
        proxyJump = "stu";
      };
    };
  };
}
