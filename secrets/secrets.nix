let
  me = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKv5fgCyrSdHw1z4Yvdi28fLs413vLFYk5sYyfC1YHJz imlonghao@imlonghao";
  deployer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGPiPq3zWmsO7dEJS/xR8+YW2eEFpPoR7ybtXwh0kC3S imlonghao@hetzner-fi-helsinki-1";

  hertzdefalkenstein1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGxXK+vxVnjNTxZU+MzK7jiJJJ0lcq4uOz8Oe88KBiOy";
  virmachusbuffalo1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIa8dYtwsbAmVoohOb5VzpWoOGh/pwipKa8beVDvy6FA";
  hosthatchsgsingapore1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBID8nCh4rMu4rhADLBjHR4zUvNWKF7898FHzkrBKY3C";
  uovzcnhongkong1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFLUpy8RTdbWL3SeKpladeChdgCZz2rIVrRgr2POqc+j";
  combahtondefrankfurt1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIulBmMYYwT+lcjH3oesB8RIrTgUVMTDtuFcpSMpsBFT";
  buyvmuslasvegas1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICnnJaYAhSql7Ecf0SvKJLrMiE6NFFc4OvJ457Xt3NnO";
  buyvmusmiami1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBSOTtTAYSdlCTVNwjmE5DU6NVSPiyoPcN6Y+i6/4qFS";
  hetznerdefalkenstein1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINwgOiBA82/Bds81vdkJs8jw3eeaY4hSUc5oRbU6A98k";
  nexusbytesuslosangeles1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKTz5EVR6k/BP+JyVoVFYrd3Bnxmo+ATsrSKElPhblXx";
  starrydnscnhongkong1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOZmM7DOMHN4EAsviYmj0OYqqXEfciJZi5M6rnu2THVs";

  users = [ me deployer ];
  hosts = [
    hertzdefalkenstein1
    virmachusbuffalo1
    hosthatchsgsingapore1
    uovzcnhongkong1
    combahtondefrankfurt1
    buyvmuslasvegas1
    buyvmusmiami1
    hetznerdefalkenstein1
    nexusbytesuslosangeles1
    starrydnscnhongkong1
  ];

  allKeys = users ++ hosts;
in
{
  "rait/rait.sh".publicKeys = allKeys;
  "rait/hertzdefalkenstein1.conf".publicKeys = [ me hertzdefalkenstein1 ];
  "rait/virmachusbuffalo1.conf".publicKeys = [ me virmachusbuffalo1 ];
  "rait/hosthatchsgsingapore1.conf".publicKeys = [ me hosthatchsgsingapore1 ];
  "rait/uovzcnhongkong1.conf".publicKeys = [ me uovzcnhongkong1 ];
  "rait/combahtondefrankfurt1.conf".publicKeys = [ me combahtondefrankfurt1 ];
  "rait/buyvmuslasvegas1.conf".publicKeys = [ me buyvmuslasvegas1 ];
  "rait/buyvmusmiami1.conf".publicKeys = [ me buyvmusmiami1 ];
  "rait/hetznerdefalkenstein1.conf".publicKeys = [ me hetznerdefalkenstein1 ];
  "rait/nexusbytesuslosangeles1.conf".publicKeys = [ me nexusbytesuslosangeles1 ];
  "rait/starrydnscnhongkong1.conf".publicKeys = [ me starrydnscnhongkong1 ];

  "k3s.token".publicKeys = [
    me
    hosthatchsgsingapore1
    combahtondefrankfurt1
    virmachusbuffalo1
    uovzcnhongkong1
    nexusbytesuslosangeles1
    hetznerdefalkenstein1
    starrydnscnhongkong1
  ];
  "redis-password".publicKeys = [ me hosthatchsgsingapore1 ];
}
