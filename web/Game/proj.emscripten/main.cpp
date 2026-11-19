/****************************************************************************
 Copyright (c) 2017-2018 Xiamen Yaji Software Co., Ltd.
 
 http://www.cocos2d-x.org
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

#include "AppDelegate.h"
#include "cocos2d.h"
#include "platform/desktop/CCGLViewImpl-desktop.h"

#include <emscripten.h>

USING_NS_CC;

// Emscripten主循环
void mainLoop() {
    Director::getInstance()->mainLoop();
}

int main(int argc, char **argv) {
    // 创建应用委托
    AppDelegate app;
    
    // 初始化Director
    auto director = Director::getInstance();
    auto glview = director->getOpenGLView();
    
    if (!glview) {
        // Emscripten环境下创建GLView
        glview = GLViewImpl::create("Gun Mayhem");
        director->setOpenGLView(glview);
    }
    
    // 设置设计分辨率
    glview->setDesignResolutionSize(1920, 1080, ResolutionPolicy::FIXED_HEIGHT);
    
    // 设置帧率
    director->setAnimationInterval(1.0f / 60);
    
    // 运行场景
    if (app.applicationDidFinishLaunching()) {
        // 启动Emscripten主循环
        emscripten_set_main_loop(mainLoop, 0, 1);
    }
    
    return 0;
}

// 导出给JavaScript调用的函数
extern "C" {
    void onKeyDown(int keyCode) {
        EventKeyboard event((EventKeyboard::KeyCode)keyCode, false);
        Director::getInstance()->getEventDispatcher()->dispatchEvent(&event);
    }
    
    void onKeyUp(int keyCode) {
        EventKeyboard event((EventKeyboard::KeyCode)keyCode, true);
        Director::getInstance()->getEventDispatcher()->dispatchEvent(&event);
    }
}
