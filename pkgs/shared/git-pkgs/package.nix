{
  lib,
  bundlerApp,
  ruby_3_4,
  bundlerUpdateScript,
}:
(bundlerApp.override { ruby = ruby_3_4; }) {
  pname = "git-pkgs";
  gemdir = ./.;
  exes = [ "git-pkgs" ];

  passthru.updateScript = bundlerUpdateScript "git-pkgs";

  meta = {
    homepage = "https://github.com/andrew/git-pkgs";
    description = "A git subcommand for analyzing package/dependency usage in git repositories over time";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ bnjmnt4n ];
    platforms = lib.platforms.unix;
    mainProgram = "git-pkgs";
  };
}
