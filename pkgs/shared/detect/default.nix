{
  src,
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  name = "detect";
  src = src;

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';
  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  meta = {
    description = "";
    homepage = "https://github.com/inanna-malick/detect";
    license = lib.licenses.mit;
    maintainers = [];
  };
})
