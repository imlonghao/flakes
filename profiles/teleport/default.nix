{ ... }:

{
  services.myteleport = {
    enable = true;
    teleport = {
      auth_servers = [ "116.202.180.190:3025" ];
      ca_pin = "sha256:a8631860ce1f0ab80ad2730df1204c22df25d58a8ab31ae0e01b66e751667d70";
    };
  };
}
