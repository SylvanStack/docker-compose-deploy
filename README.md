# Docker Compose Deploy

基于Docker Compose的一键部署工具集合，提供完整的开发环境解决方案。本项目集成了主流的中间件和服务，支持单机部署和集群部署，帮助开发团队快速搭建所需的开发环境。

## 功能特点

- 🚀 一键部署：使用Docker Compose实现环境快速搭建
- 🔧 配置灵活：支持自定义配置文件
- 🎯 版本选择：主流中间件多版本支持
- 🔒 环境隔离：容器化部署，避免环境污染
- 🛠 维护简单：统一的启动停止命令
- 📦 扩展方便：模块化设计，易于添加新服务

## 系统要求

- Docker 20.10.0+
- Docker Compose 2.0.0+
- 操作系统：Linux/MacOS/Windows
- 内存：建议8GB+
- 磁盘空间：根据部署服务数量决定，建议20GB+

## 支持的服务

### 基础设施
- Nacos 2.0.3 (配置中心)
- MySQL 5.7/8.0 (数据库)
- Redis 7.0 (缓存)
- MinIO (对象存储)

### 消息队列
- RocketMQ 4.9.4
- RabbitMQ 3.9-management (集群支持)

### 任务调度
- XXL-Job 2.3.1 (分布式任务调度)
- Airflow (工作流调度)

### AI开发环境
- Ollama (AI模型服务)
- Open WebUI (AI管理界面)
- PGVector (向量数据库)

### 监控管理
- Portainer (容器管理)

## 快速开始

### 1. 克隆项目
```bash
git clone https://github.com/your-username/docker-compose-deploy.git
cd docker-compose-deploy
```

### 2. 单机部署
```bash
cd docker-compose/standalone
docker-compose -f quickly-start.yml up -d
```

### 3. 集群部署
```bash
cd docker-compose/cluster
./rabbitmq-cluster/rabbitmq-cluster.sh
```

## 服务访问

### 配置中心
- Nacos: http://localhost:8848/nacos
  - 用户名：nacos
  - 密码：nacos

### 消息队列
- RocketMQ Console: http://localhost:8080
  - 用户名：admin
  - 密码：admin
- RabbitMQ Management: http://localhost:15672
  - 用户名：guest
  - 密码：guest

### 任务调度
- XXL-Job Admin: http://localhost:9090/xxl-job-admin
  - 用户名：admin
  - 密码：123456

### 容器管理
- Portainer: http://localhost:9000

## 目录结构

```
./
├── component/            # 基础组件配置
├── docker-compose/       # Docker Compose配置
│   ├── cluster/         # 集群部署配置
│   └── standalone/      # 单机部署配置
├── dockerfile/          # Dockerfile定义
└── shell/              # 脚本工具
```

## 配置说明

### 网络配置
- 默认网络模式：bridge
- 自定义网络：
  - middleware_net：中间件网络
  - app_net：应用网络

### 存储配置
- 数据持久化：Docker Volume
- 配置文件：外部挂载
- 日志存储：统一管理

## 安全配置

### 访问控制
- 所有服务默认启用密码认证
- 端口访问限制
- 网络隔离策略

### 数据安全
- 数据持久化存储
- 配置文件加密
- 密码管理

## 常见问题

1. 端口冲突
  - 修改docker-compose配置文件中的端口映射

2. 内存不足
  - 调整Docker资源限制
  - 按需启动所需服务

3. 数据持久化
  - 数据默认存储在Docker Volume中
  - 可通过配置文件修改存储位置