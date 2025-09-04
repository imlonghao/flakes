{ config, self, ... }:
{
  sops.secrets."act-runner" = {
    format = "binary";
    sopsFile = "${self}/secrets/act-runner.txt";
  };
  virtualisation.oci-containers.containers = {
    act-runner = {
      image = "vegardit/gitea-act-runner:dind-rootless-0.2.13";
      privileged = true;
      environment = {
        GITEA_INSTANCE_URL = "https://git.esd.cc";
        GITEA_RUNNER_NAME = config.networking.hostName;
        ACT_CACHE_SERVER_HOST = "100.64.1.${toString config.services.ranet.id}";
        ACT_CACHE_SERVER_PORT = "22380";
      };
      environmentFiles = [ config.sops.secrets.act-runner.path ];
      ports = [ "100.64.1.${toString config.services.ranet.id}:22380:22380" ];
      volumes = [ "/persist/docker/act_runner/data:/data" ];
    };
  };
}
