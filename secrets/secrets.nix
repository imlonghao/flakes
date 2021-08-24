let
  me = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKv5fgCyrSdHw1z4Yvdi28fLs413vLFYk5sYyfC1YHJz imlonghao@imlonghao";
  deployer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGPiPq3zWmsO7dEJS/xR8+YW2eEFpPoR7ybtXwh0kC3S imlonghao@hetzner-fi-helsinki-1";

  hertzdefalkenstein1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGxXK+vxVnjNTxZU+MzK7jiJJJ0lcq4uOz8Oe88KBiOy";
  virmachusbuffalo1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIa8dYtwsbAmVoohOb5VzpWoOGh/pwipKa8beVDvy6FA";
  hosthatchsgsingapore1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBID8nCh4rMu4rhADLBjHR4zUvNWKF7898FHzkrBKY3C";

  users = [ me deployer ];
  hosts = [ hertzdefalkenstein1 virmachusbuffalo1 hosthatchsgsingapore1 ];

  allKeys = users ++ hosts;
in
{
  "rait/rait.sh".publicKeys = allKeys;
  "rait/hertzdefalkenstein1.conf".publicKeys = [ me hertzdefalkenstein1 ];
  "rait/virmachusbuffalo1.conf".publicKeys = [ me virmachusbuffalo1 ];
  "rait/hosthatchsgsingapore1.conf".publicKeys = [ me hosthatchsgsingapore1 ];
}
