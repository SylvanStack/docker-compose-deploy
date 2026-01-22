#!/bin/bash
# DataEase 部署脚本 (Linux)
# 使用外部 MySQL 数据库

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
NC='\033[0m'

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}  DataEase 部署脚本 (外部 MySQL)${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

# 检查 Docker
echo -e "${YELLOW}1. 检查 Docker 环境...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${RED}   ✗ Docker 未安装${NC}"
    exit 1
fi

if ! docker ps &> /dev/null; then
    echo -e "${RED}   ✗ Docker 服务未运行${NC}"
    exit 1
fi
echo -e "${GREEN}   ✓ Docker 运行正常${NC}"

# 加载环境变量
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if [ ! -f "$SCRIPT_DIR/.env" ]; then
    echo -e "${RED}   ✗ 未找到 .env 文件${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}2. 加载配置...${NC}"

# 转换 Windows 路径为 Docker 兼容路径（Git Bash）
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    echo -e "${GRAY}   检测到 Windows/Git Bash 环境，转换路径...${NC}"
    
    # 备份原始 .env
    cp "$SCRIPT_DIR/.env" "$SCRIPT_DIR/.env.bak"
    
    # 读取并转换路径
    while IFS= read -r line || [ -n "$line" ]; do
        if [[ "$line" =~ ^DE_BASE= ]]; then
            # 提取路径值
            path_value=$(echo "$line" | cut -d'=' -f2-)
            # 转换 D:\path 为 /d/path
            if [[ "$path_value" =~ ^[A-Za-z]:[/\\] ]]; then
                drive_letter=$(echo "$path_value" | cut -c1 | tr '[:upper:]' '[:lower:]')
                path_rest=$(echo "$path_value" | cut -c3- | sed 's/\\/\//g' | sed 's/^[/\\]*//')
                converted_path="/$drive_letter/$path_rest"
                echo "DE_BASE=$converted_path"
            else
                echo "$line"
            fi
        else
            echo "$line"
        fi
    done < "$SCRIPT_DIR/.env.bak" > "$SCRIPT_DIR/.env"
fi

set -a
source "$SCRIPT_DIR/.env"
set +a

echo -e "${GRAY}   数据目录: ${DE_BASE}${NC}"
echo -e "${GRAY}   访问端口: ${DE_PORT}${NC}"
echo -e "${GRAY}   MySQL: ${DE_MYSQL_HOST}${NC}"
echo -e "${GREEN}   ✓ 配置加载完成${NC}"

# 创建目录
echo ""
echo -e "${YELLOW}3. 创建数据目录...${NC}"
mkdir -p ${DE_BASE}/dataease2.0/{conf,logs,cache,data}
echo -e "${GREEN}   ✓ 目录创建完成${NC}"

# 复制配置文件
echo ""
echo -e "${YELLOW}4. 复制配置文件...${NC}"
if [ -d "templates" ]; then
    cp -r templates/* ${DE_BASE}/dataease2.0/conf/
    echo -e "${GREEN}   ✓ 配置文件已复制${NC}"
else
    echo -e "${RED}   ✗ templates 目录不存在${NC}"
    exit 1
fi

# 启动服务
echo ""
echo -e "${YELLOW}5. 启动服务...${NC}"
docker-compose up -d

# 恢复原始 .env 文件
if [ -f "$SCRIPT_DIR/.env.bak" ]; then
    mv "$SCRIPT_DIR/.env.bak" "$SCRIPT_DIR/.env"
fi

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  ✓ DataEase 部署成功！${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo -e "${CYAN}访问地址: http://localhost:${DE_PORT}${NC}"
    echo -e "${YELLOW}默认账号: admin / DataEase@123456${NC}"
    echo ""
    echo -e "${GRAY}查看日志: docker logs -f dataease${NC}"
    echo -e "${GRAY}停止服务: docker-compose down${NC}"
    echo ""
else
    echo ""
    echo -e "${RED}✗ 部署失败，请检查日志${NC}"
    exit 1
fi
