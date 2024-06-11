{ fetchTarball }:

let
  url = "https://github.com/msteen/nixos-vscode-server/tarball/master";
  sha256 = "1rq8mrlmbzpcbv9ys0x88alw30ks70jlmvnfr2j8v830yy5wvw7h";  # Replace with the actual SHA256 hash

in
fetchTarball {
  url = url;
  sha256 = sha256;
}

