{ ... }:

{
  services.vault = {
    enable = true;
    storageBackend = "consul";
  };
}
