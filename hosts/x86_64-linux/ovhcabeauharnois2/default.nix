{ self, pkgs, ... }:
{
  imports = [
    ./bird.nix
    ./hardware.nix
    "${self}/profiles/mycore"
    "${self}/users/root"
    "${self}/profiles/exporter/node.nix"
    "${self}/profiles/rsshc"
    "${self}/profiles/k3s/agent.nix"
  ];

  nix.gc.dates = "monthly";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    dhcpcd.allowInterfaces = [ "eno1" ];
    defaultGateway6 = {
      interface = "eno1";
      address = "2607:5300:0060:46ff:00ff:00ff:00ff:00ff";
    };
    interfaces = {
      eno1 = {
        ipv6.addresses = [
          {
            address = "2607:5300:60:4617::1";
            prefixLength = 128;
          }
        ];
      };
    };
  };

  environment.persistence."/persist" = {
    directories = [
      # keep-sorted start
      "/etc/rancher"
      "/root/.config"
      "/root/.local"
      "/root/.pi"
      "/root/.ssh"
      "/var/lib"
      # keep-sorted end
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  environment.systemPackages = with pkgs; [
    # keep-sorted start
    (python3.withPackages (ps: with ps; [ requests ]))
    atuin
    black
    git
    gnupg
    go
    iptables
    jq
    jujutsu
    keep-sorted
    llm-agents.omp
    llm-agents.pi
    ncdu
    nix-update
    nixfmt
    nodejs
    oha
    openssl
    pkgs.sops
    ranet
    rclone
    ripgrep
    rtk
    rustic
    socat
    tmux
    tree
    uv
    vim
    whois
    # keep-sorted end
  ];

  # ranet
  services.ranet = {
    enable = true;
    interface = "eno1";
    id = 31;
  };

}
