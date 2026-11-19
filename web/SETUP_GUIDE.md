# Gun Mayhem Web - 设置和运行指南

## 快速开始

### 方法一：一键构建运行（推荐）

```batch
# 1. 先安装 Emscripten（只需执行一次）
setup-emscripten.bat

# 2. 构建并运行
build-and-run.bat
```

### 方法二：分步执行

```batch
# 1. 安装 Emscripten SDK
setup-emscripten.bat

# 2. 构建项目
build-emscripten.bat

# 3. 启动 Web 服务器
run-web.bat
```

## 详细步骤

### 1. 安装 Emscripten SDK

运行 `setup-emscripten.bat`，脚本会：
- 下载 Emscripten SDK
- 安装最新版本
- 激活环境

或者手动安装：
```batch
cd D:\
git clone https://github.com/emscripten-core/emsdk.git
cd emsdk
emsdk install latest
emsdk activate latest
```

### 2. 构建项目

运行 `build-emscripten.bat`，构建过程包括：
1. 激活 Emscripten 环境
2. 创建构建目录
3. 配置 CMake
4. 编译项目
5. 复制 HTML 文件

构建输出位于：`build/emscripten/`

### 3. 运行 Web 版本

运行 `run-web.bat` 启动本地服务器，然后访问 http://localhost:8000

## 文件说明

| 文件 | 说明 |
|------|------|
| `setup-emscripten.bat` | 安装 Emscripten SDK |
| `build-emscripten.bat` | 构建 WebAssembly 版本 |
| `run-web.bat` | 启动本地 Web 服务器 |
| `build-and-run.bat` | 一键构建并运行 |
| `BUILD_FIXES.md` | 详细的构建修复记录 |

## 浏览器要求

- Chrome 80+
- Firefox 75+
- Edge 80+
- Safari 14+

## 游戏控制

| 按键 | 功能 |
|------|------|
| WASD / 方向键 | 移动 |
| G / / | 射击 |
| 空格 | 跳跃 |

## 故障排除

### 问题："Emscripten 未找到"
**解决**：运行 `setup-emscripten.bat` 安装 Emscripten

### 问题："CMake 配置失败"
**解决**：
- 确保已安装 CMake（3.6+）
- 检查 Emscripten 路径是否正确

### 问题："编译失败"
**解决**：
- 检查 Cocos2d-x 3.17.2 是否完整
- 查看 `BUILD_FIXES.md` 了解已修复的问题

### 问题："无法访问 localhost:8000"
**解决**：
- 确保服务器已启动
- 检查防火墙设置
- 尝试使用 `127.0.0.1:8000`

## 项目结构

```
Gun-Mayhem-Web/
├── build/                    # 构建输出
│   └── emscripten/          # Web 构建文件
│       ├── index.html       # 游戏页面
│       ├── GunMayhem.js     # JS 运行时
│       └── GunMayhem.wasm   # WebAssembly 模块
├── cocos2d-x-3.17.2/        # Cocos2d-x 引擎
├── Game/                     # 游戏代码
│   ├── Classes/             # 游戏逻辑
│   ├── Resources/           # 游戏资源
│   └── proj.emscripten/     # Web 入口
└── *.bat                    # 构建脚本
```

## 手动构建（高级）

如果需要手动控制构建过程：

```batch
# 激活 Emscripten
call D:\emsdk\emsdk_env.bat

# 创建构建目录
mkdir build\emscripten
cd build\emscripten

# 配置 CMake
cmake -G "MinGW Makefiles" ^
  -DCMAKE_TOOLCHAIN_FILE=D:/emsdk/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake ^
  -DCMAKE_BUILD_TYPE=Release ^
  ../../Game

# 编译
emmake make -j4
```

## 技术栈

- **引擎**: Cocos2d-x 3.17.2
- **编译**: Emscripten / WebAssembly
- **图形**: WebGL 2.0
- **音频**: HTML5 Audio API

## 性能优化建议

1. **压缩资源**：使用 TinyPNG 压缩图片
2. **启用 Gzip**：在服务器启用 gzip 压缩
3. **使用 CDN**：部署到 CDN 加速访问
4. **懒加载**：按需加载游戏资源

## 参考资料

- [Emscripten 文档](https://emscripten.org/docs/)
- [Cocos2d-x 文档](https://docs.cocos2d-x.org/)
- [WebAssembly 文档](https://webassembly.org/)
