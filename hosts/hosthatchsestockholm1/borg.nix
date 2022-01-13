{ pkgs, ... }:

{
  # test user
  users.users.gikzoncf = {
    uid = 5001;
    home = "/persist/borg/gikzoncf";
    createHome = true;
    openssh.authorizedKeys.keys = [
      ''command="${pkgs.borgbackup}/bin/borg serve --restrict-to-repository /persist/borg/gikzoncf/repo --append-only",restrict ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKv5fgCyrSdHw1z4Yvdi28fLs413vLFYk5sYyfC1YHJz''
    ];
  };
}
