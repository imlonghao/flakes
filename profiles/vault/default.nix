{ ... }:

{
  services.vault = {
    enable = true;
    storagePath = "vault";
    storageBackend = "consul";
  };
}
