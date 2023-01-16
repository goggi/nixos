{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.custom.taskwarrior;
  unstable = import <nixpkgs-unstable> {};

  taskNextWeek =
    pkgs.writeShellScriptBin "taskweek" # sh
    
    ''
      ${pkgs.taskwarrior}/bin/task \
                          export \
                          status:pending and \( due.before:6days \) \
          | ${pkgs.jq}/bin/jq '[.[] | { Day: .due, ID: .id, Description: .description } ] | sort_by(.Day)' \
          | ${pkgs.miller}/bin/mlr --ijson --opprint put "\$Day = strftime(strptime(\$Day,\"%Y%m%dT%H%M%SZ\")$(date +%z)00,\"%A\")"
    '';

  tsak =
    pkgs.writeShellScriptBin "tsak" # sh
    
    ''
      ${pkgs.taskwarrior}/bin/task "$@"
    '';

  vit = unstable.vit.overrideAttrs (old: rec {
    name = "vit-${version}";
    version = "master";
    src = pkgs.fetchgit {
      url = "https://github.com/scottkosty/vit.git";
      rev = "7200949214362139e8073b6ca1a58cc756b2ebd0";
      sha256 = "1s0rvqn8xjy3qiw9034wfzz2r7mwary70x32fqprz2w2h5r73j2m";
    };
  });
in {
  options.programs.custom.taskwarrior.enable =
    mkEnableOption "Enable Taskwarrior services";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      taskwarrior
      timewarrior
      tasksh
      taskNextWeek
      tsak

      (pkgs.writers.writeBashBin "calendar" ''
        ${pkgs.taskwarrior}/bin/task calendar
        ${pkgs.taskwarrior}/bin/task calendar_report
      '')

      vit
      (pkgs.writers.writeBashBin "active" "${vit}/bin/vit active")
      (pkgs.writers.writeBashBin "todo" "${vit}/bin/vit todo")

      taskwarrior-hooks
      vdirsyncer
      khal
      (pkgs.writers.writeBashBin "kalendar" ''
        ${pkgs.vdirsyncer}/bin/vdirsyncer sync
        ${pkgs.khal}/bin/ikhal
      '')

      # bugwarrior
      (let
        mypython = let
          packageOverrides = self: super: {
            bugwarrior = super.bugwarrior.overridePythonAttrs (old: {
              propagatedBuildInputs =
                old.propagatedBuildInputs
                ++ [super.setuptools];
            });
          };
        in
          pkgs.python3.override {inherit packageOverrides;};
      in
        mypython.pkgs.bugwarrior)
    ];
  };
}
