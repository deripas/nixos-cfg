{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    distrobox
  ];

  environment.variables = {
    DISTROBOX_EXPORT_PATH = "$(which distrobox-export)";
  };
}
