{
  src,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  name = "detect";
  src = src;
  cargoLock.lockFile = "${src}/Cargo.lock";

  meta = {
    description = "";
    homepage = "https://github.com/inanna-malick/detect";
    license = lib.licenses.mit;
    maintainers = [];
  };
})
