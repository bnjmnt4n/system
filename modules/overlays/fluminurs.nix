(self: super: {
  fluminurs = with super;
    rustPlatform.buildRustPackage rec {
      name = "fluminurs-${version}";
      version = "0b0d1d0872fd9acecec691a34bc34a7bf27712b0";

      nativeBuildInputs = [
        rustc
        cargo
        pkgconfig
      ];

      buildInputs = [
        openssl
      ];

      src = fetchFromGitHub {
        owner = "indocomsoft";
        repo = "fluminurs";
        rev = version;
        sha256 = "izPyiA+FArGjkyU0zXgQTVmZiYa6/Wz5OmOJiC9Iw1A=";
      };

      cargoSha256 = "g+6zFIYJy8dNX2EC6L0QP+I5uEV7bslt0s+Mfowm/mk=";

      meta = with stdenv.lib; {
        description = "Luminus CLI";
        homepage = https://github.com/indocomsoft/fluminurs;
        license = licenses.mit;
        platforms = platforms.all;
      };
    };
})
