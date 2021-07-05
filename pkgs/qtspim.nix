# Copied from https://github.com/eadwu/nixpkgs/blob/13bb5bdaf7c125dd92d3b1cc303fa89c54b700a8/pkgs/applications/virtualization/spim/default.nix.
{ lib
, mkDerivation
, fetchsvn
, flex
, bison
, qmake
, wrapQtAppsHook
, qtbase
, qttools
}:

mkDerivation rec {
  pname = "QtSpim";
  version = "734";

  src = fetchsvn {
    url = "https://svn.code.sf.net/p/spimsimulator/code";
    rev = version;
    sha256 = "1c2d30xi9jvxh34pd7m5mzgp14qz0s1726gryc7ny2z6sqdjqsaa";
  };

  sourceRoot = "code-r${version}/QtSpim";

  nativeBuildInputs = [ flex bison qmake wrapQtAppsHook ];

  buildInputs = [ qtbase qttools ];

  # Remove build artifacts from the repo
  preConfigure = ''
    sed -i \
      -e 's@$(COPY) ''${QMAKE_FILE_PATH}/''${QMAKE_FILE_BASE}.qhc ''${QMAKE_FILE_OUT};@@g' \
      -e 's@qcollectiongenerator@qhelpgenerator@g' \
      QtSpim.pro

    sed -i \
      -e 's/zero_imm/is_zero_imm/g' \
      -e 's/^int data_dir/bool data_dir/g' \
      -e 's/^int text_dir/bool text_dir/g' \
      -e 's/^int parse_error_occurred/bool parse_error_occurred/g' \
      parser_yacc.cpp

    rm help/qtspim.qhc
  '';

  # Fix documentation path
  postPatch = ''
    substituteInPlace menu.cpp --replace "/usr/lib/qtspim/help/qtspim.qhc" "$out/share/qtspim/help/qtspim.qhc"
    substituteInPlace menu.cpp --replace "/usr/lib/qtspim/bin/assistant" "${qttools.dev}/bin/assistant"

    substituteInPlace ../Setup/qtspim_debian_deployment/qtspim.desktop \
      --replace "/usr/lib/qtspim/qtspim.png" "$out/share/qtspim/qtspim.png" \
      --replace "/usr/bin/qtspim" "$out/bin/qtspim"
  '';

  buildPhase = ''
    export QT_PLUGIN_PATH="${qtbase.bin}/${qtbase.qtPluginPrefix}"
    export QT_QPA_PLATFORM_PLUGIN_PATH="${qtbase.bin}/${qtbase.qtPluginPrefix}/platforms"
    make
  '';

  installPhase = ''
    install -Dm0755 QtSpim $out/bin/qtspim

    install -D ../Documentation/qtspim.man $out/share/man/man1/qtspim.1
    gzip -f --best $out/share/man/man1/qtspim.1

    install -Dm0644 help/qtspim.qch $out/share/qtspim/help/qtspim.qch
    install -Dm0644 help/qtspim.qhc $out/share/qtspim/help/qtspim.qhc

    install -Dm0644 ../Setup/qtspim_debian_deployment/qtspim.desktop $out/share/applications/qtspim.desktop
    install -Dm0644 ../Setup/qtspim_debian_deployment/copyright $out/share/licenses/qtspim/copyright
    install -Dm0644 ../Setup/NewIcon48x48.png $out/share/qtspim/qtspim.png

    install -Dm0644 ../helloworld.s $out/share/qtspim/helloworld.s
  '';

  meta = with lib; {
    description = "SPIM MIPS simulator";
    longDescription = ''
      SPIM is a self-contained simulator that runs MIPS32 assembly language programs.
      SPIM also provides a simple debugger and minimal set of operating system services.
    '';

    homepage = "https://sourceforge.net/projects/spimsimulator";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ aske ];
  };
}
