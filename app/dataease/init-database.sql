-- DataEase 数据库初始化脚本
-- 请在 MySQL 服务器上执行此脚本

-- 1. 创建数据库
CREATE DATABASE IF NOT EXISTS `dataease` 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_0900_ai_ci;

-- 2. 创建专用用户（可选，如果不想使用 root）
-- CREATE USER 'dataease'@'%' IDENTIFIED BY 'your_secure_password';
-- GRANT ALL PRIVILEGES ON dataease.* TO 'dataease'@'%';
-- FLUSH PRIVILEGES;

-- 3. 验证数据库
USE dataease;
SHOW VARIABLES LIKE 'character_set_database';
SHOW VARIABLES LIKE 'collation_database';

-- 注意：
-- - 首次启动 DataEase 时，应用会自动创建所需的表结构
-- - 确保 MySQL 版本为 8.0 或更高
-- - 确保用户有 CREATE、ALTER、DROP、SELECT、INSERT、UPDATE、DELETE 权限
