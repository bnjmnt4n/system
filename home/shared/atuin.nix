{...}: {
  programs.atuin = {
    enable = true;
    flags = ["--disable-up-arrow"];
    settings = {
      update_check = false;
      sync_frequency = "24h";
      prefers_reduced_motion = true;
      enter_accept = true;
      sync.records = true;
    };
  };

  programs.fzf.historyWidget.command = "";
}
