{
  description = "A highly structured configuration database.";

  nixConfig.extra-experimental-features = "nix-command flakes";
  nixConfig.extra-substituters = "https://imlonghao.cachix.org https://nrdxp.cachix.org https://nix-community.cachix.org";
  nixConfig.extra-trusted-public-keys = "imlonghao.cachix.org-1:KGQ7+R1BXo2NsoeAxKLPfGAiHz5ofCmZO4hih7u/2Q8= nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";

  inputs =
    {
      nixos.url = "github:nixos/nixpkgs/release-21.11";
      latest.url = "github:nixos/nixpkgs/nixos-unstable";

      digga.url = "github:divnix/digga";
      digga.inputs.nixpkgs.follows = "nixos";
      digga.inputs.nixlib.follows = "nixos";
      digga.inputs.home-manager.follows = "home";

      bud.url = "github:divnix/bud";
      bud.inputs.nixpkgs.follows = "nixos";
      bud.inputs.devshell.follows = "digga/devshell";

      home.url = "github:nix-community/home-manager/release-21.11";
      home.inputs.nixpkgs.follows = "nixos";

      darwin.url = "github:LnL7/nix-darwin";
      darwin.inputs.nixpkgs.follows = "latest";

      deploy.follows = "digga/deploy";

      nvfetcher.url = "github:berberman/nvfetcher";
      nvfetcher.inputs.nixpkgs.follows = "latest";
      nvfetcher.inputs.flake-compat.follows = "digga/deploy/flake-compat";
      nvfetcher.inputs.flake-utils.follows = "digga/flake-utils-plus/flake-utils";

      naersk.url = "github:nmattia/naersk";
      naersk.inputs.nixpkgs.follows = "latest";

      nixos-hardware.url = "github:nixos/nixos-hardware";

      impermanence.url = "github:nix-community/impermanence";

      sops-nix.url = github:Mic92/sops-nix;
      sops-nix.inputs.nixpkgs.follows = "nixpkgs";

      # start ANTI CORRUPTION LAYER
      # remove after https://github.com/NixOS/nix/pull/4641
      nixpkgs.follows = "nixos";
      nixlib.follows = "digga/nixlib";
      blank.follows = "digga/blank";
      flake-utils-plus.follows = "digga/flake-utils-plus";
      flake-utils.follows = "digga/flake-utils";
      # end ANTI CORRUPTION LAYER
    };

  outputs =
    { self
    , digga
    , bud
    , nixos
    , home
    , nixos-hardware
    , nur
    , nvfetcher
    , deploy
    , impermanence
    , sops-nix
    , ...
    } @ inputs:
    digga.lib.mkFlake
      {
        inherit self inputs;

        channelsConfig = { allowUnfree = true; };

        channels = {
          nixos = {
            imports = [ (digga.lib.importOverlays ./overlays) ];
            overlays = [
              nur.overlay
              nvfetcher.overlay
              ./pkgs/default.nix
            ];
          };
          latest = {
            overlays = [
              deploy.overlay
            ];
          };
        };

        lib = import ./lib { lib = digga.lib // nixos.lib; };

        sharedOverlays = [
          (final: prev: {
            __dontExport = true;
            lib = prev.lib.extend (lfinal: lprev: {
              our = self.lib;
            });
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
              bud.nixosModules.bud
              impermanence.nixosModules.impermanence
              sops-nix.nixosModules.sops
            ];
          };

          imports = [ (digga.lib.importHosts ./hosts) ];
          hosts = {
            /* set host specific properties here */
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
            suites = with profiles; rec {
              base = [ direnv git ];
            };
          };
          users = {
            nixos = { suites, ... }: { imports = suites.base; };
          }; # digga.lib.importers.rakeLeaves ./users/hm;
        };

        devshell = ./shell;

        homeConfigurations = digga.lib.mkHomeConfigurations self.nixosConfigurations;

        deploy.nodes = digga.lib.mkDeployNodes self.nixosConfigurations {
          hertzdefalkenstein1 = {
            hostname = "hertz-de-falkenstein-1.ni.sb";
            sshUser = "root";
            sshOpts = [ "-p" "22226" ];
          };
          virmachusbuffalo1 = {
            hostname = "virmach-us-buffalo-1.ni.sb";
            sshUser = "root";
          };
          hosthatchsgsingapore1 = {
            hostname = "hosthatch-sg-singapore-1.ni.sb";
            sshUser = "root";
          };
          uovzcnhongkong1 = {
            hostname = "uovz-cn-hongkong-1.ni.sb";
            sshUser = "root";
          };
          buyvmuslasvegas1 = {
            hostname = "buyvm-us-lasvegas-1.ni.sb";
            sshUser = "root";
          };
          buyvmusmiami1 = {
            hostname = "buyvm-us-miami-1.ni.sb";
            sshUser = "root";
          };
          hetznerdefalkenstein1 = {
            hostname = "hetzner-de-falkenstein-1.ni.sb";
            sshUser = "root";
          };
          nexusbytesuslosangeles1 = {
            hostname = "nexusbytes-us-losangeles-1.ni.sb";
            sshUser = "root";
          };
          starrydnscnhongkong1 = {
            hostname = "starrydns-cn-hongkong-1.ni.sb";
            sshUser = "root";
          };
          mailcow = {
            hostname = "mail.esd.cc";
            sshUser = "root";
            sshOpts = [ "-p" "2222" ];
          };
          misakauklondon1 = {
            hostname = "misaka-uk-london-1.ni.sb";
            sshUser = "root";
          };
          hetznerdefalkenstein2 = {
            hostname = "hetzner-de-falkenstein-2.ni.sb";
            sshUser = "root";
          };
        };

        defaultTemplate = self.templates.bud;
        templates.bud.path = ./.;
        templates.bud.description = "bud template";

      }
    //
    {
      budModules = { devos = import ./bud; };
    }
  ;
}
