{
  description = "imlonghao's Nix flakes config";

  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    extra-substituters = "https://imlonghao.cachix.org https://nrdxp.cachix.org https://nix-community.cachix.org";
    extra-trusted-public-keys = "imlonghao.cachix.org-1:KGQ7+R1BXo2NsoeAxKLPfGAiHz5ofCmZO4hih7u/2Q8= nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    colmena-flake.url = "github:juspay/colmena-flake";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ranet = {
      url = "github:NickCao/ranet";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.colmena-flake.flakeModules.default
        inputs.devshell.flakeModule
      ];
      systems = builtins.attrNames (builtins.readDir ./hosts);
      perSystem =
        {
          lib,
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        {
          packages = lib.packagesFromDirectoryRecursive {
            inherit (pkgs) callPackage;
            directory = ./pkgs;
          };
          devshells.default = {
            packages = [
              pkgs.colmena
            ];
          };
        };
      flake = {
        nixosConfigurations = builtins.listToAttrs (
          builtins.concatLists (
            map (
              arch:
              map (hostName: {
                name = "${hostName}";
                value = inputs.nixpkgs.lib.nixosSystem {
                  system = arch;
                  specialArgs = { inherit self inputs; };
                  modules = [
                    {
                      nixpkgs = {
                        config.allowUnfree = true;
                        overlays = [
                          self.overlays.default
                          inputs.ranet.overlays.default
                        ];
                        system = arch;
                      };
                      imports = [
                        self.nixosModules.default
                        inputs.sops-nix.nixosModules.sops
                        inputs.impermanence.nixosModules.impermanence
                      ];
                      networking.hostName = hostName;
                    }
                    ./hosts/${arch}/${hostName}
                  ];
                };
              }) (builtins.attrNames (builtins.readDir ./hosts/${arch}))
            ) (builtins.attrNames (builtins.readDir ./hosts))
          )
        );
        nixosModules.default =
          { ... }:
          {
            imports = builtins.map (f: ./modules/${f}) (builtins.attrNames (builtins.readDir ./modules));
          };
        overlays.default =
          final: prev:
          prev.lib.packagesFromDirectoryRecursive {
            inherit (prev) callPackage;
            directory = ./pkgs;
          };
      };
      colmena-flake.deployment = {
        virmachustampa1 = {
          targetHost = "virmach-us-tampa-1.ni.sb";
        };
        hosthatchsgsingapore1 = {
          targetHost = "hosthatch-sg-singapore-1.ni.sb";
          tags = [
            "dn42"
            "k3s-agent"
          ];
        };
        buyvmuslasvegas1 = {
          targetHost = "buyvm-us-lasvegas-1.ni.sb";
          tags = [ "dn42" ];
        };
        buyvmusmiami1 = {
          targetHost = "buyvm-us-miami-1.ni.sb";
          tags = [ "dn42" ];
        };
        starrydnscnhongkong1 = {
          targetHost = "starrydns-cn-hongkong-1.ni.sb";
        };
        misakadeberlin1 = {
          targetHost = "misaka-de-berlin-1.ni.sb";
          tags = [ "k3s-server" ];
        };
        misakauklondon1 = {
          targetHost = "misaka-uk-london-1.ni.sb";
          tags = [ "k3s-server" ];
        };
        hosthatchsestockholm1 = {
          targetHost = "hosthatch-se-stockholm-1.ni.sb";
          tags = [ "k3s-agent" ];
        };
        oracledefrankfurt1 = {
          targetHost = "oracle-de-frankfurt-1.ni.sb";
          buildOnTarget = true;
          tags = [
            "dn42"
            "k3s-agent"
          ];
        };
        terrahostnosandefjord1 = {
          targetHost = "terrahost-no-sandefjord-1.ni.sb";
          tags = [ "dn42" ];
        };
        vpsausydney1 = {
          targetHost = "vps-au-sydney-1.ni.sb";
          tags = [
            "dn42"
            "k3s-agent"
          ];
        };
        vpsussanjose1 = {
          targetHost = "vps-us-sanjose-1.ni.sb";
        };
        ovhfrgravelines1 = {
          targetHost = "ovh-fr-gravelines-1.ni.sb";
          tags = [ "k3s-agent" ];
        };
        buyvmchbern1 = {
          targetHost = "buyvm-ch-bern-1.ni.sb";
        };
        vpsdefrankfurt1 = {
          targetHost = "vps-de-frankfurt-1.ni.sb";
        };
        wirecatussantaclara1 = {
          targetHost = "wirecat-us-santaclara-1.ni.sb";
          tags = [ "k3s-agent" ];
        };
        twdscntaibei1 = {
          targetHost = "twds-cn-taibei-1.ni.sb";
        };
        f4uskansas1 = {
          targetHost = "f4-us-kansas-1.ni.sb";
        };
        dmituslosangeles1 = {
          targetHost = "dmit-us-losangeles-1.ni.sb";
        };
        dmitcnhongkong1 = {
          targetHost = "dmit-cn-hongkong-1.ni.sb";
          tags = [ "dn42" ];
        };
        serverfactorynleygelshoven1 = {
          targetHost = "serverfactory-nl-eygelshoven-1.ni.sb";
          tags = [ "k3s-server" ];
        };
        xentainusdallas1 = {
          targetHost = "xentain-us-dallas-1.ni.sb";
        };
        breezehostusdallas1 = {
          targetHost = "breezehost-us-dallas-1.ni.sb";
          targetPort = 10222;
          tags = [ "dn42" ];
        };
        vpsjptokyo1 = {
          targetHost = "vps-jp-tokyo-1.ni.sb";
          tags = [ "dn42" ];
        };
        ovhcabeauharnois1 = {
          targetHost = "ovh-ca-beauharnois-1.ni.sb";
          tags = [ "k3s-agent" ];
        };
        ovhcabeauharnois2 = {
          targetHost = "ovh-ca-beauharnois-2.ni.sb";
          tags = [ "k3s-agent" ];
        };
      };
    };
}
