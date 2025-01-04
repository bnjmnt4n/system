{...}: {
  programs.atuin = {
    enable = true;
    flags = ["--disable-up-arrow"];
    settings = {
      update_check = false;
      prefers_reduced_motion = true;
      enter_accept = true;
      sync.records = true;
    };
  };
}
