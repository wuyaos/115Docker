# 115Docker - Web 环境中的 115 浏览器客户端

一个基于 LinuxServer WebTop 的 Docker 解决方案，在 Web 环境中运行 115 浏览器客户端，提供便捷的远程访问体验。

## 🌟 功能特性

- **Web 访问**: 通过浏览器直接访问 115 客户端，无需安装本地软件
- **桌面环境**: 基于 Debian XFCE 桌面环境，提供完整的图形界面
- **增强功能**: 集成 115Cookie 扩展，增强浏览器功能
- **优化配置**: 预配置的浏览器参数，优化性能和稳定性

## 🚀 快速开始

### Docker CLI

```bash
# 基本运行
docker run \
--name 115docker \
--security-opt seccomp:unconfined \
-e PUID=1000 \
-e PGID=1000 \
-e TZ=Asia/Shanghai \
-e TITLE=115docker \
-e DOCKER_MODS=linuxserver/mods:universal-package-install \
-e LC_ALL=zh_CN.UTF-8 \
-e NO_DECOR=1 \
-v /path/to/config:/config \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /path/to/download:/config/下载 \
-p 3000:3000 \
--shm-size 1gb \
--restart unless-stopped \
wuyaos/115docker:latest
```

### Docker Compose

```yaml
---
version: "2.1"
services:
  115docker:
    image: wuyaos/115docker:latest
    container_name: 115browser
    security_opt:
      - seccomp=unconfined
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Asia/Shanghai
      - TITLE=Webtop
      - DOCKER_MODS=linuxserver/mods:universal-package-install
      - LC_ALL=zh_CN.UTF-8
      - NO_DECOR=1
    volumes:
      - /path/to/config:/config
      - /path/to/data:/etc/115
      - /path/to/download:/config/下载
    ports:
      - 3000:3000
    restart: unless-stopped
```

### 访问服务

打开浏览器访问: `http://localhost:3000`

## 📋 详细配置

### 环境变量

| 变量名 | 默认值 | 说明 |
|--------|--------|------|
| `PUID` | 1000 | 用户 ID，用于容器内进程的权限控制 |
| `PGID` | 1000 | 用户组 ID，用于容器内进程的权限控制 |
| `TZ` | Asia/Shanghai | 时区设置 |
| `SUBFOLDER` | / | 可选：指定子文件夹访问路径 |
| `KEYBOARD` | zh-CN | 键盘布局，默认中文 |

### 端口配置

| 端口 | 协议 | 说明 |
|------|------|------|
| 3000 | HTTP | Web 界面访问端口 |

### 数据卷挂载

| 容器路径 | 说明 |
|----------|------|
| `/config` | 配置文件目录，存储 WebTop 的所有配置文件 |
| `/etc/115` | 115 浏览器用户数据目录，存储浏览记录、登录信息等 |
| `/opt/Desktop` | 桌面文件目录，可选挂载 |

## 📄 许可证

本项目采用 [GPL-3.0 许可证](LICENSE)。

## ⚖️ 免责声明

- 本项目仅供学习和研究使用
- 请遵守相关法律法规和服务条款
- 使用本项目产生的任何问题由用户自行承担
- 项目作者不对使用本项目造成的任何损失负责

---

**注意**: 本项目与 115 官方无关，仅为第三方 Docker 化解决方案。使用前请确保遵守 115 服务条款。