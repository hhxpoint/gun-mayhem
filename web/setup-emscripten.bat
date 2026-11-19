@echo off
chcp 65001 >nul

REM Emscripten SDK 安装脚本

echo ==========================================
echo Emscripten SDK 安装脚本
echo ==========================================
echo.

set EMSDK_ROOT=D:\emsdk

REM 检查是否已安装
if exist "%EMSDK_ROOT%\emsdk.bat" (
    echo [信息] Emscripten SDK 已安装在 %EMSDK_ROOT%
    goto ACTIVATE
)

echo [1/4] 正在下载 Emscripten SDK...
echo 下载地址: https://github.com/emscripten-core/emsdk

REM 尝试使用 git 克隆
git --version >nul 2>&1
if errorlevel 1 (
    echo [错误] 未找到 Git，请先安装 Git
    echo 下载地址: https://git-scm.com/download/win
    pause
    exit /b 1
)

pushd D:\
git clone https://github.com/emscripten-core/emsdk.git
if errorlevel 1 (
    echo [错误] 克隆仓库失败，尝试使用镜像...
    git clone https://ghproxy.com/https://github.com/emscripten-core/emsdk.git
    if errorlevel 1 (
        echo [错误] 下载失败，请检查网络连接
        pause
        exit /b 1
    )
)
popd

:ACTIVATE
echo [2/4] 安装最新版 Emscripten...
cd /d "%EMSDK_ROOT%"
call emsdk install latest
if errorlevel 1 (
    echo [错误] 安装失败
    pause
    exit /b 1
)

echo [3/4] 激活 Emscripten...
call emsdk activate latest
if errorlevel 1 (
    echo [错误] 激活失败
    pause
    exit /b 1
)

echo [4/4] 配置环境变量...
echo.
echo ==========================================
echo 安装完成!
echo ==========================================
echo.
echo 请将以下路径添加到系统 PATH:
echo   %EMSDK_ROOT%
echo   %EMSDK_ROOT%\upstream\emscripten
echo.
echo 或者运行以下命令来配置当前终端:
echo   %EMSDK_ROOT%\emsdk_env.bat
echo.
pause
