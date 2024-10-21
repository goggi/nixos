{fetchTarball}: let
  url = "https://github.com/msteen/nixos-vscode-server/tarball/master";
  sha256 = "09j4kvsxw1d5dvnhbsgih0icbrxqv90nzf0b589rb5z6gnzwjnqf"; # Replace with the actual SHA256 hash
in
  fetchTarball {
    url = url;
    sha256 = sha256;
  }
