@echo off
chcp 65001 >nul

REM Gun Mayhem - Emscripten Build Script for Windows

setlocal EnableDelayedExpansion

REM 设置路径 - 请根据你的实际安装路径修改
set EMSCRIPTEN_ROOT=D:/emsdk
set COCOS2DX_ROOT=D:/C++/Gun-Mayhem-Web/cocos2d-x-3.17.2
set PROJECT_ROOT=D:/C++/Gun-Mayhem-Web/Game
set BUILD_DIR=D:/C++/Gun-Mayhem-Web/build/emscripten

echo ==========================================
echo Gun Mayhem Web Build Script
echo ==========================================

REM 检查Emscripten是否安装
if not exist "%EMSCRIPTEN_ROOT%/emsdk.bat" (
    echo [错误] Emscripten 未找到!
    echo 请先安装Emscripten: https://emscripten.org/docs/getting_started/downloads.html
    pause
    exit /b 1
)

REM 检查Cocos2d-x 3.17.2是否存在
if not exist "%COCOS2DX_ROOT%/cocos/cocos2d.cpp" (
    echo [错误] Cocos2d-x 3.17.2 未找到!
    echo 请下载并解压Cocos2d-x 3.17.2到: %COCOS2DX_ROOT%
    echo 下载地址: https://github.com/cocos2d/cocos2d-x/releases/tag/cocos2d-x-3.17.2
    pause
    exit /b 1
)

echo [1/5] 激活Emscripten环境...
call "%EMSCRIPTEN_ROOT%/emsdk_env.bat"
if errorlevel 1 (
    echo [错误] Emscripten环境激活失败!
    pause
    exit /b 1
)

echo [2/5] 创建构建目录...
if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"

echo [3/5] 配置CMake...
cd /d "%BUILD_DIR%"

cmake -G "MinGW Makefiles" ^
    -DCMAKE_TOOLCHAIN_FILE=%EMSCRIPTEN_ROOT%/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake ^
    -DCMAKE_BUILD_TYPE=Release ^
    %PROJECT_ROOT%

if errorlevel 1 (
    echo [错误] CMake配置失败!
    pause
    exit /b 1
)

echo [4/5] 编译项目...
emmake make -j4

if errorlevel 1 (
    echo [错误] 编译失败!
    pause
    exit /b 1
)

echo [5/5] 复制HTML文件...
if exist "%PROJECT_ROOT%/../build/emscripten/index.html" (
    copy /Y "%PROJECT_ROOT%/../build/emscripten/index.html" "%BUILD_DIR%/"
) else (
    echo [警告] index.html 未找到，请手动复制
)

echo ==========================================
echo 编译成功!
echo 输出文件: %BUILD_DIR%
echo - GunMayhem.js
echo - GunMayhem.wasm
echo - index.html
echo ==========================================
echo.
echo 启动本地服务器预览:
echo   cd %BUILD_DIR%
echo   python -m http.server 8000
echo   然后访问: http://localhost:8000
echo.
pause
