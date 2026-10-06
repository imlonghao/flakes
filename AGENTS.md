# flakes

imlonghao's Nix flakes config

## 目录结构

- `./hosts`: 各台主机独立的配置
- `./modules`: 系统自定义模块配置，systemd service
- `./pkgs`: 软件包配置
- `./profiles`: 供主机使用的通用配置
- `./scripts`: 常用脚本
- `./secrets`: 主机密文，加密后的配置属性等，通过 `sops` 管理
- `./users`: 系统用户定义

## 常用流程

### DN42 Peer 管理

- 我方网络的 ASN 是 4242421888
- 配置放在主机目录中的 dn42.nix 文件中
- 新增配置时，需要按照 ASN 从小到大进行排序，放于合适的位置上
- 配置的详细定义在 `./modules/dn42.nix` 中
- 大多数情况下，需要设置 `name` / `listen` / `endpoint` / `publickey` / `asn` / `e6`
    - `name`: 默认为 `wg????` 其中 `????` 为目标的后四位 ASN 号
    - `listen`: 默认为目标的后五位 ASN 号
    - `endpoint`: 隧道的端点，一般为域名加我方 ASN 的后五位
    - `publickey`: Wireguard Public Key
    - `asn`: 目标的 ASN 号
    - `e6`: 目标的 IPv6 地址，一般以 `fe80::` 开头
- 新增 Peer 时，必须执行下方「更新本地角色」流程，查询该 ASN 的最新排名并确定 `local_role`，不得跳过查询直接使用默认角色
- 如果目标不支持 Multiprotocol BGP，则需要设置 `mpbgp=false`
- 如果目标不支持 Extended Next Hop，则需要设置 `e4` 和 `l4`，`l4` 一般为 `172.22.68.0`

### 节点下线

1. 删除 `./hosts/$arch/$hostname` 目录
2. 清理 `./flake.nix` 中该主机相关的部署信息
3. 根据 `./.sops.yaml` 配置文件，去除 `./secrets` 目录密文中相对应的主机密钥，使用命令 `sops -r -i --rm-age $age $filename` 执行
4. 清理 `./.sops.yaml` 中该主机相关的密钥信息

### 更新本地角色

1. 请求 https://api.iedon.com/dn42/ranking 获取最新排名
2. Peer ASN 属于 Rank 1-20 的，显式设置 `local_role = "customer";`
3. Peer ASN 属于 Rank 21-300 的，显式设置 `local_role = "peer";`
4. 排名超过 300 或未上榜的，省略 `local_role`，使用默认值 `provider`，或保留已有的特殊角色
