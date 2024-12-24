{ pkgs, ... }:

{
  users.users = {
    vpsjptokyo1 = {
      group = "nogroup";
      home = "/persist/borg/vpsjptokyo1";
      createHome = true;
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        ''
          command="${pkgs.borgbackup}/bin/borg serve --restrict-to-repository /persist/borg/vpsjptokyo1/repo --append-only",restrict ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMCayvEz2OVsmPx3UUHOTO4OvOJ9oqr19mUtaWSsQ7EH root@vpsjptokyo1''
      ];
    };
    cloudiplcuslosangeles1 = {
      group = "nogroup";
      home = "/persist/borg/cloudiplcuslosangeles1";
      createHome = true;
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        ''
          command="${pkgs.borgbackup}/bin/borg serve --restrict-to-repository /persist/borg/cloudiplcuslosangeles1/repo --append-only",restrict ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOd9q7yYhjYQcxiSmybWtbHYa/cnwK/uz/fYP4mVV0AH root@cloudiplcuslosangeles1''
      ];
    };
    nas = {
      group = "nogroup";
      home = "/persist/borg/nas";
      createHome = true;
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        ''
          command="${pkgs.borgbackup}/bin/borg serve --restrict-to-repository /persist/borg/nas/repo --append-only",restrict ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA+HDK17YPUx571+Q3qzxC81SJv8Taj+HeCHLhsEUlTG root@nas''
      ];
    };
    ovhca = {
      group = "nogroup";
      home = "/persist/ovhca";
      createHome = true;
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDhndfh+m7XwpXcPBWKeDmTve2U4fbZzqRVJbvueZdxF root@ovhcabeauharnois1"
      ];
    };
  };
}
