{ ... }:

{
  imports =
    [
      ./ssd.nix
      ./ssh.nix
      ./sleep.nix
      ./postgresql.nix
      ./immich.nix
      ./tunnel.nix
      ./web.nix
    ];
}
