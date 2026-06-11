{buildGoModule}:
buildGoModule {
  pname = "month_table";
  version = "0-unstable-2026-06-02";

  src = ./.;
  vendorHash = null;

  meta = {
    description = "Print a table of files organized by YYYY-MM filename prefixes";
    mainProgram = "month_table";
  };
}
