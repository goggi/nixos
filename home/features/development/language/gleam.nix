{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.gleam
      pkgs.erlang
      pkgs.rebar3
    ];
  };
}
