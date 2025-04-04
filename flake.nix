{
  description = "A highly structured configuration database.";

  nixConfig.extra-experimental-features = "nix-command flakes";
  nixConfig.extra-substituters =
    "https://imlonghao.cachix.org https://nrdxp.cachix.org https://nix-community.cachix.org";
  nixConfig.extra-trusted-public-keys =
    "imlonghao.cachix.org-1:KGQ7+R1BXo2NsoeAxKLPfGAiHz5ofCmZO4hih7u/2Q8= nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";

  inputs = {
    nixos.url = "github:nixos/nixpkgs/release-24.11";
    latest.url = "github:nixos/nixpkgs/nixos-unstable";

    digga.url = "github:divnix/digga";
    digga.inputs.nixpkgs.follows = "nixos";
    digga.inputs.nixlib.follows = "nixos";
    digga.inputs.home-manager.follows = "home";
    digga.inputs.deploy.follows = "deploy";
    digga.inputs.flake-utils-plus.follows = "flake-utils-plus";

    home.url = "github:nix-community/home-manager/release-24.11";
    home.inputs.nixpkgs.follows = "nixos";

    deploy.url = "github:serokell/deploy-rs";
    deploy.inputs.nixpkgs.follows = "nixos";

    impermanence.url = "github:nix-community/impermanence";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixos";

    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";

    ranet.url = "github:NickCao/ranet";
    ranet.inputs.nixpkgs.follows = "nixos";
  };

  outputs = { self, digga, nixos, home, nur, deploy, impermanence, sops-nix
    , ranet, ... }@inputs:
    digga.lib.mkFlake {
      inherit self inputs;

      channelsConfig = { allowUnfree = true; };

      channels = {
        nixos = {
          imports = [ (digga.lib.importOverlays ./overlays) ];
          overlays = [ nur.overlay ./pkgs/default.nix ranet.overlays.default ];
        };
        latest = { };
      };

      lib = import ./lib { lib = digga.lib // nixos.lib; };

      sharedOverlays = [
        (final: prev: {
          __dontExport = true;
          lib = prev.lib.extend (lfinal: lprev: { our = self.lib; });
        })
      ];

      nixos = {
        hostDefaults = {
          system = "x86_64-linux";
          channelName = "nixos";
          imports = [ (digga.lib.importExportableModules ./modules) ];
          modules = [
            { lib.our = self.lib; }
            digga.nixosModules.bootstrapIso
            digga.nixosModules.nixConfig
            home.nixosModules.home-manager
            impermanence.nixosModules.impermanence
            sops-nix.nixosModules.sops
          ];
        };

        imports = [ (digga.lib.importHosts ./hosts) ];
        hosts = {
          # set host specific properties here
          oracledefrankfurt1 = { system = "aarch64-linux"; };
        };
        importables = rec {
          profiles = digga.lib.rakeLeaves ./profiles // {
            users = digga.lib.rakeLeaves ./users;
          };
          suites = with profiles; rec {
            base = [ core users.nixos users.root ];
          };
        };
      };

      home = {
        imports = [ (digga.lib.importExportableModules ./users/modules) ];
        modules = [ ];
        importables = rec {
          profiles = digga.lib.rakeLeaves ./users/profiles;
          suites = with profiles; rec { base = [ direnv git ]; };
        };
        users = {
          nixos = { suites, ... }: { imports = suites.base; };
        }; # digga.lib.importers.rakeLeaves ./users/hm;
      };

      devshell = ./shell;

      homeConfigurations =
        digga.lib.mkHomeConfigurations self.nixosConfigurations;

      deploy.nodes = digga.lib.mkDeployNodes self.nixosConfigurations {
        virmachustampa1 = {
          hostname = "virmach-us-tampa-1.ni.sb";
          sshUser = "root";
        };
        hosthatchsgsingapore1 = {
          hostname = "hosthatch-sg-singapore-1.ni.sb";
        };
        buyvmuslasvegas1 = { hostname = "buyvm-us-lasvegas-1.ni.sb"; };
        buyvmusmiami1 = { hostname = "buyvm-us-miami-1.ni.sb"; };
        starrydnscnhongkong1 = { hostname = "starrydns-cn-hongkong-1.ni.sb"; };
        misakadeberlin1 = { hostname = "misaka-de-berlin-1.ni.sb"; };
        misakauklondon1 = { hostname = "misaka-uk-london-1.ni.sb"; };
        hosthatchsestockholm1 = {
          hostname = "hosthatch-se-stockholm-1.ni.sb";
        };
        oracledefrankfurt1 = { hostname = "oracle-de-frankfurt-1.ni.sb"; };
        terrahostnosandefjord1 = {
          hostname = "terrahost-no-sandefjord-1.ni.sb";
        };
        vpsausydney1 = { hostname = "vps-au-sydney-1.ni.sb"; };
        vpsussanjose1 = { hostname = "vps-us-sanjose-1.ni.sb"; };
        ovhfrgravelines1 = { hostname = "ovh-fr-gravelines-1.ni.sb"; };
        buyvmluroost1 = { hostname = "buyvm-lu-roost-1.ni.sb"; };
        vpsdefrankfurt1 = { hostname = "vps-de-frankfurt-1.ni.sb"; };
        wirecatussantaclara1 = { hostname = "wirecat-us-santaclara-1.ni.sb"; };
        twdscntaibei1 = { hostname = "twds-cn-taibei-1.ni.sb"; };
        virtuafrlille1 = { hostname = "virtua-fr-lille-1.ni.sb"; };
        f4uskansas1 = { hostname = "f4-us-kansas-1.ni.sb"; };
        dmituslosangeles1 = { hostname = "dmit-us-losangeles-1.ni.sb"; };
        serverfactorynleygelshoven1 = {
          hostname = "serverfactory-nl-eygelshoven-1.ni.sb";
        };
        xentainusdallas1 = { hostname = "xentain-us-dallas-1.ni.sb"; };
        breezehostusdallas1 = {
          hostname = "breezehost-us-dallas-1.ni.sb";
          sshOpts = [ "-p" "10222" ];
        };
        vpsjptokyo1 = { hostname = "vps-jp-tokyo-1.ni.sb"; };
        coalcloudcnhongkong1 = { hostname = "coalcloud-cn-hongkong-1.ni.sb"; };
        clawcloudcnhongkong1 = { hostname = "clawcloud-cn-hongkong-1.ni.sb"; };
        ovhcabeauharnois1 = { hostname = "ovh-ca-beauharnois-1.ni.sb"; };
        ovhcabeauharnois2 = { hostname = "ovh-ca-beauharnois-2.ni.sb"; };
      };
    };
}
