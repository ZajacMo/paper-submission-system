# 论文投稿系统 (Paper Submission System)
[English](README.md)

这是一个全栈论文投稿与管理系统，由 React 前端和 Node.js/Express 后端组成。

## 项目结构

本项目主要包含两个部分：

- `client/`: 基于 React + Vite + Mantine 构建的前端应用
- `server/`: 基于 Node.js + Express + MySQL 构建的后端应用

## 功能特性

- 用户认证 (JWT)
- 论文投稿与管理
- 评审系统
- 基于角色的访问控制 (作者、评审人、管理员)
- 文件上传支持
- Docker 支持

## 技术栈

### 前端 (Client)
- React
- Vite
- Mantine UI
- React Query
- React Router
- Axios
- i18next (国际化支持)

### 后端 (Server)
- Node.js
- Express
- MySQL
- JWT Authentication
- Multer (文件上传)

## 快速开始

### 前置要求
- Node.js (v16+)
- MySQL
- Docker & Docker Compose (可选)

### 使用 Docker Compose 运行 (推荐)

1. 确保已安装 Docker 和 Docker Compose
2. 在根目录下运行以下命令：

```bash
docker-compose up --build
```

服务访问地址：
- 前端: http://localhost:21743
- 后端 API: http://localhost:5000

### 手动安装

#### 后端 (Server)

1. 进入 server 目录：
```bash
cd server
```

2. 安装依赖：
```bash
npm install
```

3. 配置环境变量：
参考 `compose.yaml` 中的配置或根据本地环境创建 `.env` 文件。

4. 初始化数据库：
执行 `server/SQL/` 目录下的 SQL 脚本以设置 MySQL 数据库。

5. 启动服务器：
```bash
npm start
```

#### 前端 (Client)

1. 进入 client 目录：
```bash
cd client
```

2. 安装依赖：
```bash
npm install
```

3. 启动开发服务器：
```bash
npm run dev
```

## 许可证

ISC
