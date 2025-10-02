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
      };
      environmentFiles = [ config.sops.secrets.act-runner.path ];
      volumes = [ "/persist/docker/act_runner/data:/data" ];
    };
  };
}
