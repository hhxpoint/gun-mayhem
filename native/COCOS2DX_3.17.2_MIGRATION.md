# Cocos2d-x 4.0 → 3.17.2 降级报告

## 修改的文件列表

### 1. Classes/Scene/StartScene.h
- 修改：`#include "editor-support/cocostudio/SimpleAudioEngine.h"` → `#include "audio/include/SimpleAudioEngine.h"`
- 修改：`#include "AudioEngine.h"` → `#include "audio/include/AudioEngine.h"`

### 2. Classes/Scene/Standing.h
- 修改：`#include "editor-support/cocostudio/SimpleAudioEngine.h"` → `#include "audio/include/SimpleAudioEngine.h"`

### 3. Classes/Scene/Setting.h
- 修改：`#include "editor-support/cocostudio/SimpleAudioEngine.h"` → `#include "audio/include/SimpleAudioEngine.h"`

### 4. Classes/Scene/Credits.h
- 修改：`#include "editor-support/cocostudio/SimpleAudioEngine.h"` → `#include "audio/include/SimpleAudioEngine.h"`

## 兼容性评估

| 检查项 | 状态 | 说明 |
|--------|------|------|
| SimpleAudioEngine 头文件路径 | ✅ 已修复 | 4.0路径不同，已改为3.17.2路径 |
| AudioEngine 头文件路径 | ✅ 已修复 | 同上 |
| ui/CocosGUI.h | ✅ 兼容 | 路径在3.17.2中一致 |
| std::vector/std::map | ✅ 兼容 | 代码使用标准容器，无兼容性问题 |
| cocos2d::Vector | ✅ 兼容 | Jetpack.cpp中使用，3.17.2支持 |
| AppDelegate.cpp | ✅ 无需修改 | USE_AUDIO_ENGINE被注释，代码不生效 |
| CC_TARGET_PLATFORM 宏 | ✅ 兼容 | 3.17.2完全支持 |

## 后续步骤

1. **安装 Cocos2d-x 3.17.2**：下载并解压到本地
2. **创建新项目**：使用 `cocos new` 创建3.17.2项目
3. **迁移代码**：将本项目的 Classes 和 Resources 复制到新项目
4. **编译测试**：
   - Windows: 使用 Visual Studio 打开 proj.win32/*.sln
   - Android: 使用 Android Studio 打开 proj.android
   - Web: 使用 `cocos compile -p web`

## 已知风险

- 音频系统在3.17.2中行为可能略有差异，建议测试背景音乐和音效
- 部分渲染效果可能有细微差别

## 降级完成时间
2026-04-24
