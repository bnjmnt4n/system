let
  quote = str: "'${str}'";
in
{
  createDirTile = { path, fileType, arrangement, displayAs, showAs }:
    quote (
      builtins.replaceStrings [ "\n" ] [ "" ]
        ''
          <dict>
            <key>tile-data</key>
            <dict>
              <key>file-data</key>
              <dict>
                <key>_CFURLString</key>
                <string>file://${toString path}</string>
                <key>_CFURLStringType</key>
                <integer>15</integer>
              </dict>
              <key>file-type</key>
              <integer>${toString fileType}</integer>
              <key>arrangement</key>
              <integer>${toString arrangement}</integer>
              <key>displayas</key>
              <integer>${toString displayAs}</integer>
              <key>showas</key>
              <integer>${toString showAs}</integer>
            </dict>
            <key>tile-type</key>
            <string>directory-tile</string>
          </dict>
        ''
    );
}
