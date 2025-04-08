
## FRP内网穿透配置指南

FRP（Fast Reverse Proxy）是一个优秀的内网穿透工具，可以帮助您实现内网服务的外网访问。本指南将帮助您快速部署和使用FRP。

### 部署架构
- FRP服务端（frps）：部署在具有公网IP的服务器上
- FRP客户端（frpc）：部署在需要进行内网穿透的内网机器上

### 前置要求
- 一台具有公网IP的服务器
- Docker和Docker Compose环境
- 确保服务器防火墙开放相关端口（7000, 7500, 20000-20010）

### 快速开始

#### 1. 服务端配置（公网服务器）

1. 修改服务端配置文件 `component/frp/server/frps.ini`：
   ```ini
   [common]
   bind_port = 7000
   bind_addr = 0.0.0.0
   dashboard_port = 7500
   dashboard_user = admin
   dashboard_pwd = admin123
   authentication_method = token
   token = your_secure_token_here
   allow_ports = 20000-20010
   ```

2. 启动FRP服务端：
   ```bash
   cd component
   docker-compose -f frp-server.yml up -d
   ```

#### 2. 客户端配置（内网机器）

1. 修改客户端配置文件 `component/frp/client/frpc.ini`：
   ```ini
   [common]
   server_addr = your_server_ip  # 替换为您的服务器IP
   server_port = 7000
   token = your_secure_token_here  # 与服务端token保持一致

   # 根据需要配置要穿透的服务
   [ssh]
   type = tcp
   local_ip = 127.0.0.1
   local_port = 22
   remote_port = 20000
   ```

2. 启动FRP客户端：
   ```bash
   cd component
   docker-compose -f frp-client.yml up -d
   ```

### 配置说明

#### 服务端配置参数
- `bind_port`：FRP服务端口
- `dashboard_port`：控制面板端口
- `dashboard_user/pwd`：控制面板账号密码
- `token`：安全认证令牌
- `allow_ports`：允许使用的端口范围

#### 客户端配置参数
- `server_addr`：FRP服务器地址
- `server_port`：FRP服务端口
- `token`：安全认证令牌
- 各服务配置段：
  - `type`：协议类型（tcp/udp/http/https）
  - `local_ip`：本地服务IP
  - `local_port`：本地服务端口
  - `remote_port`：远程映射端口

### 常见使用场景

1. **SSH远程访问**
   ```ini
   [ssh]
   type = tcp
   local_ip = 127.0.0.1
   local_port = 22
   remote_port = 20000
   ```
   访问方式：`ssh -p 20000 user@server_ip`

2. **Web服务访问**
   ```ini
   [web]
   type = tcp
   local_ip = 127.0.0.1
   local_port = 80
   remote_port = 20001
   ```
   访问方式：`http://server_ip:20001`

3. **数据库访问**
   ```ini
   [mysql]
   type = tcp
   local_ip = 127.0.0.1
   local_port = 3306
   remote_port = 20002
   ```
   访问方式：使用数据库客户端连接 `server_ip:20002`

### 安全建议

1. 修改默认的控制面板密码
2. 使用足够复杂的token
3. 及时更新FRP版本
4. 只开放必要的端口
5. 建议使用防火墙限制访问IP

### 故障排查

1. 检查服务状态：
   ```bash
   docker-compose -f frp-server.yml ps  # 服务端
   docker-compose -f frp-client.yml ps  # 客户端
   ```

2. 查看日志：
   ```bash
   docker-compose -f frp-server.yml logs  # 服务端日志
   docker-compose -f frp-client.yml logs  # 客户端日志
   ```
