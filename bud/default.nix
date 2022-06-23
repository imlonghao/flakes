{ pkgs, lib, budUtils, ... }: {
  bud.cmds = with pkgs; {
    get = {
      writer = budUtils.writeBashWithPaths [ nixVersions.nix_2_9 git coreutils ];
      synopsis = "get [DEST]";
      help = "Copy the desired template to DEST";
      script = ./get.bash;
    };
  };
}
