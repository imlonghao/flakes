# flakes

imlonghao's Nix flakes config

## 目录结构

- `./hosts`: 各台主机独立的配置
- `./modules`: 系统自定义模块配置，systemd service
- `./pkgs`: 软件包配置
- `./profiles`: 供主机使用的通用配置
- `./scripts`: 常用脚本
- `./secrets`: 主机秘文，加密后的配置属性等，通过 `sops` 管理
- `./users`: 系统用户定义

## 常用流程

### DN42 Peer 管理

- 我方网络的 ASN 是 4242421888
- 配置放在主机目录中的 dn42.nix 文件中
- 新增配置时，需要按照 ASN 从小到大进行排序，放于合适的位置上
- 配置的详细定义在 `./modules/dn42.nix` 中
- 大多数情况下，只需要设置 `name` / `listen` / `endpoint` / `publickey` / `asn` / `e6` 即可
    - `name`: 默认为 `wg????` 其中 `????` 为目标的后四位 ASN 号
    - `listen`: 默认为目标的后五位 ASN 号
    - `endpoint`: 隧道的端点，一般为域名加我方 ASN 的后五位
    - `publickey`: Wireguard Public Key
    - `asn`: 目标的 ASN 号
    - `e6`: 目标的 IPv6 地址，一般以 `fe80::` 开头
- 如果目标不支持 Multiprotocol BGP，则需要设置 `mpbgp=false`
- 如果目标不支持 Extended Next Hop，则需要设置 `e4` 和 `l4`，`l4` 一般为 `172.22.68.0`
