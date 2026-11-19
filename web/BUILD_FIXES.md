# Gun Mayhem Web 构建修复记录

## 已完成的修改

### 1. Cocos2d-x 引擎修改

#### `cocos2d-x-3.17.2/cocos/platform/CMakeLists.txt`
- 添加了 Emscripten 平台支持，复用 Linux 平台的实现

#### `cocos2d-x-3.17.2/cocos/audio/CMakeLists.txt`
- 添加了 Emscripten 平台的音频支持，复用 Linux 实现

#### `cocos2d-x-3.17.2/cocos/network/CMakeLists.txt`
- 添加了 Emscripten 平台的网络支持

#### `cocos2d-x-3.17.2/cocos/ui/CMakeLists.txt`
- 添加了 Emscripten 平台的 UI 支持，复用 Linux 实现

#### `cocos2d-x-3.17.2/cmake/Modules/CocosConfigDefine.cmake`
- 添加了 Emscripten 平台检测支持，将 Emscripten 映射到 Linux 平台

#### `cocos2d-x-3.17.2/cmake/Modules/CocosConfigDepend.cmake`
- 添加了 Emscripten 平台的库依赖配置

#### `cocos2d-x-3.17.2/external/CMakeLists.txt` (新增)
- 创建了最小化的 external 库配置，使用 Emscripten 内置库

### 2. 游戏项目修改

#### `Game/CMakeLists.txt`
- 添加了 Emscripten main.cpp 到源码列表
- 修复了 Emscripten 配置
- 移除了不存在的 index.html.in 引用

#### `Game/proj.emscripten/main.cpp`
- 修复了 `applicationDidFinishLaunching()` 调用，改为通过 app 对象调用
- 添加了 GLViewImpl 头文件包含

### 3. 构建脚本

#### `build-emscripten.bat`
- 将 CMake 生成器从 "Unix Makefiles" 改为 "MinGW Makefiles"
- 改进了 index.html 复制逻辑

## 构建步骤

### 前置要求

1. **安装 Emscripten SDK**
   ```bash
   git clone https://github.com/emscripten-core/emsdk.git
   cd emsdk
   emsdk install latest
   emsdk activate latest
   ```

2. **确保 Cocos2d-x 3.17.2 已下载并解压到项目目录**
   ```
   Gun-Mayhem-Web/
   ├── cocos2d-x-3.17.2/  <-- 解压到这里
   ├── Game/
   └── ...
   ```

3. **安装 MinGW** (Windows 上需要 make 工具)
   - 可以通过 MSYS2 安装: `pacman -S mingw-w64-x86_64-make`
   - 或者使用 Chocolatey: `choco install mingw`

### 编译

1. **修改构建脚本中的路径** (如果需要)
   ```batch
   set EMSCRIPTEN_ROOT=D:/emsdk
   set COCOS2DX_ROOT=D:/C++/Gun-Mayhem-Web/cocos2d-x-3.17.2
   ```

2. **运行构建脚本**
   ```batch
   cd Gun-Mayhem-Web
   build-emscripten.bat
   ```

### 运行

```batch
cd build/emscripten
python -m http.server 8000
```

浏览器访问: http://localhost:8000

## 已知限制

1. 首次编译会下载大量资源，需要耐心等待
2. 编译后的文件大小约为 5-10MB
3. 音频播放可能需要用户交互后才能开始（浏览器安全策略）
4. 部分高级功能可能需要额外配置

## 故障排除

### 错误: "Cannot recognize the target platform"
- 确保使用了 Emscripten 工具链文件
- 确保 emsdk_env.bat 已正确执行

### 错误: "external library not found"
- 已创建最小化的 external/CMakeLists.txt
- 使用 Emscripten 内置库替代

### 错误: "make 命令未找到"
- 安装 MinGW 并添加到 PATH
- 或使用 Ninja 生成器替代
