@echo off
chcp 65001 >nul

REM Gun Mayhem Web 运行脚本

echo ==========================================
echo Gun Mayhem Web 运行脚本
echo ==========================================
echo.

set BUILD_DIR=D:\C++\Gun-Mayhem-Web\build\emscripten

REM 检查构建目录
if not exist "%BUILD_DIR%" (
    echo [错误] 构建目录不存在: %BUILD_DIR%
    echo 请先运行 build-emscripten.bat 进行编译
    pause
    exit /b 1
)

echo [1/2] 检查构建文件...

if not exist "%BUILD_DIR%\GunMayhem.js" (
    echo [警告] GunMayhem.js 不存在，可能尚未编译完成
)

if not exist "%BUILD_DIR%\GunMayhem.wasm" (
    echo [警告] GunMayhem.wasm 不存在，可能尚未编译完成
)

if not exist "%BUILD_DIR%\index.html" (
    echo [错误] index.html 不存在
    pause
    exit /b 1
)

cd /d "%BUILD_DIR%"

echo [2/2] 启动本地服务器...
echo.
echo ==========================================
echo 服务器已启动!
echo 访问地址: http://localhost:8000
echo ==========================================
echo.
echo 按 Ctrl+C 停止服务器
echo.

REM 尝试使用 Python 3
python --version >nul 2>&1
if errorlevel 0 (
    python -m http.server 8000
    goto END
)

REM 尝试使用 Python 2
python2 --version >nul 2>&1
if errorlevel 0 (
    python2 -m SimpleHTTPServer 8000
    goto END
)

REM 尝试使用 Node.js
node --version >nul 2>&1
if errorlevel 0 (
    echo 使用 Node.js 启动服务器...
    echo const http = require('http'); const fs = require('fs'); const path = require('path'); const server = http.createServer((req, res) => { const filePath = path.join(__dirname, req.url === '/' ? 'index.html' : req.url); fs.readFile(filePath, (err, data) => { if (err) { res.writeHead(404); res.end('Not Found'); } else { res.writeHead(200); res.end(data); } }); }); server.listen(8000, () => console.log('Server running at http://localhost:8000/')); > server.js
    node server.js
    del server.js
    goto END
)

echo [错误] 未找到可用的服务器工具
echo 请安装 Python 或 Node.js
echo.
pause

:END
