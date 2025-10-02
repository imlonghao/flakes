{ pkgs, ... }:
{
  virtualisation.oci-containers.containers = {
    patroni = {
      image = "ghcr.io/parmincloud/containers/patroni:4.0.6-pg17";
      ports = [
        "5432:5432"
        "5433:5433"
        "8008:8008"
      ];
      volumes = [
        "/persist/docker/patroni/data:/var/lib/postgresql/data"
        "/persist/docker/patroni/patroni.yml:/etc/patroni.yml:ro"
      ];
    };
  };
}
