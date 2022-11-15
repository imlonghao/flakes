{ pkgs, ... }:

{
  users.users.vpsjptokyo1 = {
    group = "nogroup";
    home = "/persist/borg/vpsjptokyo1";
    createHome = true;
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      ''command="${pkgs.borgbackup}/bin/borg serve --restrict-to-repository /persist/borg/vpsjptokyo1/repo --append-only",restrict ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMCayvEz2OVsmPx3UUHOTO4OvOJ9oqr19mUtaWSsQ7EH root@vpsjptokyo1''
    ];
  };
}
