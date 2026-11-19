@echo off
chcp 65001 >nul

REM Gun Mayhem Web - 一键构建和运行脚本

echo ==========================================
echo Gun Mayhem Web - 一键构建和运行
echo ==========================================
echo.

REM 检查 Emscripten
if not exist "D:\emsdk\emsdk.bat" (
    echo [信息] Emscripten SDK 未安装
    echo 请先运行 setup-emscripten.bat 安装 Emscripten
    pause
    exit /b 1
)

echo [1/3] 构建项目...
call build-emscripten.bat
if errorlevel 1 (
    echo [错误] 构建失败
    pause
    exit /b 1
)

echo.
echo [2/3] 构建成功!
echo.

REM 复制 index.html 到构建目录
if exist "build\emscripten\index.html" (
    echo [3/3] 启动服务器...
    call run-web.bat
) else (
    echo [错误] 构建输出不完整
    pause
    exit /b 1
)
