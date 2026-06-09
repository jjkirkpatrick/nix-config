{ ... }:
{
  systemd.user.services.nemoclaw = {
    Unit = {
      Description = "NemoClaw AI sandbox (OpenShell gateway + inference)";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "%h/.nix-profile/bin/nemoclaw-startup";
      TimeoutStartSec = "600";
      StandardOutput = "journal";
      StandardError = "journal";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
