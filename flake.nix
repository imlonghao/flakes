{
  description = "imlonghao's Nix flakes config";

  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    extra-substituters = "https://imlonghao.cachix.org https://nrdxp.cachix.org https://nix-community.cachix.org";
    extra-trusted-public-keys = "imlonghao.cachix.org-1:KGQ7+R1BXo2NsoeAxKLPfGAiHz5ofCmZO4hih7u/2Q8= nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-latest.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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
                          self.overlays.latest
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
        overlays.latest =
          final: prev:
          let
            pkgs-latest = (
              import inputs.nixpkgs-latest {
                config.allowUnfree = true;
                localSystem = prev.stdenv.hostPlatform.system;
              }
            );
          in
          prev.lib.attrsets.genAttrs [
            # keep-sorted start
            "claude-code"
            "codex"
            "komari-agent"
            "meli"
            # keep-sorted end
          ] (name: pkgs-latest.${name});
        overlays.pyinfra =
          final: prev:
          let
            pytestOverlay = pythonFinal: pythonPrev: {
              paramiko = pythonPrev.paramiko.overridePythonAttrs (oldAttrs: {
                version = "3.5.1";
                src = prev.fetchPypi {
                  pname = "paramiko";
                  version = "3.5.1";
                  hash = "sha256-ssZlvEWyshW9fX8DmQGxSwZ9oA86EeZkCZX9WPJmSCI=";
                };
                patches = [
                  # Fix usage of dsa keys
                  # https://github.com/paramiko/paramiko/pull/1606/
                  (prev.fetchpatch {
                    url = "https://github.com/paramiko/paramiko/commit/18e38b99f515056071fb27b9c1a4f472005c324a.patch";
                    hash = "sha256-bPDghPeLo3NiOg+JwD5CJRRLv2VEqmSx1rOF2Tf8ZDA=";
                  })
                  # Fix AttributeError(public_blob)
                  (prev.fetchpatch {
                    url = "https://patch-diff.githubusercontent.com/raw/paramiko/paramiko/pull/2475.patch";
                    hash = "sha256-7PfeDR4EPaAkIbQWevPIv+HyJVXvy+T5kIz6G5w+svk=";
                  })
                ];
              });
              pyinfra = pythonPrev.pyinfra.overridePythonAttrs (oldAttrs: {
                version = "3.5.1";
                src = prev.fetchFromGitHub {
                  owner = "Fizzadar";
                  repo = "pyinfra";
                  tag = "v3.5.1";
                  hash = "sha256-xOwofPQFUqtmvmmXh70FnVrP8aAbNvsEVGGfk9kp/Uc=";
                };
                dependencies = oldAttrs.dependencies ++ [
                  pythonPrev.pyyaml
                  pythonPrev.hatchling
                  pythonPrev.uv-dynamic-versioning
                ];
                doCheck = false;
              });
            };
            python3 = prev.python3.override {
              packageOverrides = pytestOverlay;
            };
          in
          {
            inherit python3;
            python3Packages = python3.pkgs;
          };
      };
      colmena-flake.deployment = {
        # keep-sorted start block=yes
        breezehostusdallas1 = {
          targetHost = "breezehost-us-dallas-1.ni.sb";
          targetPort = 10222;
          tags = [ "dn42" ];
        };
        buyvmchbern1 = {
          targetHost = "buyvm-ch-bern-1.ni.sb";
        };
        buyvmuslasvegas1 = {
          targetHost = "buyvm-us-lasvegas-1.ni.sb";
          tags = [ "dn42" ];
        };
        buyvmusmiami1 = {
          targetHost = "buyvm-us-miami-1.ni.sb";
          tags = [ "dn42" ];
        };
        dmitcnhongkong1 = {
          targetHost = "dmit-cn-hongkong-1.ni.sb";
          tags = [ "dn42" ];
        };
        dmituslosangeles1 = {
          targetHost = "dmit-us-losangeles-1.ni.sb";
        };
        f4uskansas1 = {
          targetHost = "f4-us-kansas-1.ni.sb";
        };
        hosthatchsestockholm2 = {
          targetHost = "hosthatch-se-stockholm-2.ni.sb";
          tags = [ "k3s-agent" ];
        };
        hosthatchsgsingapore1 = {
          targetHost = "hosthatch-sg-singapore-1.ni.sb";
          tags = [
            "dn42"
            "k3s-agent"
          ];
        };
        misakadeberlin1 = {
          targetHost = "misaka-de-berlin-1.ni.sb";
          tags = [ "k3s-server" ];
        };
        misakauklondon1 = {
          targetHost = "misaka-uk-london-1.ni.sb";
          tags = [ "k3s-server" ];
        };
        oracledefrankfurt1 = {
          targetHost = "oracle-de-frankfurt-1.ni.sb";
          buildOnTarget = true;
          tags = [
            "dn42"
            "k3s-agent"
          ];
        };
        ovhcabeauharnois1 = {
          targetHost = "ovh-ca-beauharnois-1.ni.sb";
          tags = [ "k3s-agent" ];
        };
        ovhcabeauharnois2 = {
          targetHost = "ovh-ca-beauharnois-2.ni.sb";
          tags = [ "k3s-agent" ];
        };
        ovhfrgravelines1 = {
          targetHost = "ovh-fr-gravelines-1.ni.sb";
          tags = [ "k3s-agent" ];
        };
        serverfactorynleygelshoven1 = {
          targetHost = "serverfactory-nl-eygelshoven-1.ni.sb";
          tags = [ "k3s-server" ];
        };
        starrydnscnhongkong1 = {
          targetHost = "starrydns-cn-hongkong-1.ni.sb";
        };
        terrahostnosandefjord1 = {
          targetHost = "terrahost-no-sandefjord-1.ni.sb";
          tags = [ "dn42" ];
        };
        twdscntaibei1 = {
          targetHost = "twds-cn-taibei-1.ni.sb";
          tags = [ "dn42" ];
        };
        virmachustampa1 = {
          targetHost = "virmach-us-tampa-1.ni.sb";
        };
        vpsausydney1 = {
          targetHost = "vps-au-sydney-1.ni.sb";
          tags = [
            "dn42"
            "k3s-agent"
          ];
        };
        vpsdefrankfurt1 = {
          targetHost = "vps-de-frankfurt-1.ni.sb";
        };
        vpsjptokyo1 = {
          targetHost = "vps-jp-tokyo-1.ni.sb";
          tags = [ "dn42" ];
        };
        vpsussanjose1 = {
          targetHost = "vps-us-sanjose-1.ni.sb";
        };
        wirecatussantaclara1 = {
          targetHost = "wirecat-us-santaclara-1.ni.sb";
          tags = [ "k3s-agent" ];
        };
        xentainusdallas1 = {
          targetHost = "xentain-us-dallas-1.ni.sb";
        };
        # keep-sorted end
      };
    };
}
