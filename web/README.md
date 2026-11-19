# Gun Mayhem - Web Edition

Gun Mayhem C++ 游戏的 WebAssembly 版本，使用 Cocos2d-x 3.17.2 + Emscripten 编译。

## 项目结构

```
Gun-Mayhem-Web/
├── cocos2d-x-3.17.2/          # Cocos2d-x 引擎源码 (需单独下载)
├── Game/
│   ├── Classes/               # 游戏逻辑代码 (已从原项目复制并修改)
│   ├── Resources/             # 游戏资源文件 (已从原项目复制)
│   ├── proj.emscripten/       # Emscripten 入口文件
│   │   └── main.cpp           # Web平台入口
│   └── CMakeLists.txt         # 构建配置
├── build/
│   └── emscripten/            # Web构建输出
│       ├── index.html         # 游戏页面
│       ├── GunMayhem.js       # 编译后的JS (生成)
│       └── GunMayhem.wasm     # 编译后的WASM (生成)
├── build-emscripten.bat       # Windows编译脚本
└── README.md                  # 本文件
```

## 前置要求

1. **Emscripten SDK**
   ```bash
   # 下载并安装
   git clone https://github.com/emscripten-core/emsdk.git
   cd emsdk
   emsdk install latest
   emsdk activate latest
   ```

2. **Cocos2d-x 3.17.2**
   ```bash
   # 下载地址
   https://github.com/cocos2d/cocos2d-x/releases/tag/cocos2d-x-3.17.2
   
   # 解压到项目同级目录
   Gun-Mayhem-Web/
   cocos2d-x-3.17.2/  <-- 解压到这里
   ```

3. **CMake** (3.6+)
   ```bash
   # Windows: 安装 Visual Studio 时包含
   # 或从官网下载
   https://cmake.org/download/
   ```

## 快速开始

### Windows 编译

1. **修改编译脚本中的路径**
   ```batch
   REM 编辑 build-emscripten.bat，修改以下路径:
   set EMSCRIPTEN_ROOT=D:/emsdk
   set COCOS2DX_ROOT=D:/C++/Gun-Mayhem-Web/cocos2d-x-3.17.2
   ```

2. **运行编译脚本**
   ```batch
   cd Gun-Mayhem-Web
   build-emscripten.bat
   ```

3. **启动本地服务器预览**
   ```batch
   cd build/emscripten
   python -m http.server 8000
   # 浏览器访问: http://localhost:8000
   ```

### Linux/macOS 编译

```bash
cd Gun-Mayhem-Web

# 设置环境变量
export EMSCRIPTEN_ROOT=/path/to/emsdk
export COCOS2DX_ROOT=/path/to/cocos2d-x-3.17.2

# 激活Emscripten
source $EMSCRIPTEN_ROOT/emsdk_env.sh

# 创建构建目录
mkdir -p build/emscripten
cd build/emscripten

# 配置CMake
cmake -DCMAKE_TOOLCHAIN_FILE=$EMSCRIPTEN_ROOT/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake \
      -DCMAKE_BUILD_TYPE=Release \
      ../../Game

# 编译
emmake make -j4

# 复制HTML文件
cp ../../build/emscripten/index.html ./

# 启动服务器
python3 -m http.server 8000
```

## 已完成的修改

### 1. 头文件路径修复 (4个文件)
- `Classes/Scene/StartScene.h`
- `Classes/Scene/Standing.h`
- `Classes/Scene/Setting.h`
- `Classes/Scene/Credits.h`

修改内容: `editor-support/cocostudio/SimpleAudioEngine.h` → `audio/include/SimpleAudioEngine.h`

### 2. 新增文件
- `Game/proj.emscripten/main.cpp` - Emscripten入口
- `Game/CMakeLists.txt` - 构建配置
- `build/emscripten/index.html` - Web页面

## 浏览器兼容性

| 浏览器 | 版本 | 支持 |
|--------|------|------|
| Chrome | 80+ | ✅ 完全支持 |
| Firefox | 75+ | ✅ 完全支持 |
| Edge | 80+ | ✅ 完全支持 |
| Safari | 14+ | ✅ 支持 |

## 控制说明

- **WASD** 或 **方向键** - 移动
- **G** 或 **/** - 射击
- **空格** - 跳跃

## 已知问题

1. 首次加载时需要下载约 5-10MB 资源（取决于资源文件大小）
2. 音频播放可能需要用户交互后才能开始（浏览器安全策略）
3. 全屏模式下部分浏览器的键盘事件可能有延迟

## 性能优化建议

1. **压缩资源**：使用 TinyPNG 压缩图片，使用 ffmpeg 压缩音频
2. **启用Gzip**：在服务器上启用 gzip/brotli 压缩
3. **使用CDN**：将静态资源部署到CDN加速

## 部署

编译完成后，`build/emscripten/` 目录下的文件可以直接部署到任何静态文件服务器：

```
build/emscripten/
├── index.html      # 入口页面
├── GunMayhem.js    # JS运行时
├── GunMayhem.wasm  # WebAssembly模块
└── GunMayhem.data  # 打包的资源文件
```

## 参考资料

- [Cocos2d-x 3.17.2 文档](https://docs.cocos2d-x.org/cocos2d-x/v3/)
- [Emscripten 文档](https://emscripten.org/docs/)
- [WebAssembly 官方](https://webassembly.org/)

## License

与原项目相同
