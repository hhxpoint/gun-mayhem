cmake_minimum_required(VERSION 3.6)

set(APP_NAME GunMayhem)

project(${APP_NAME})

set(COCOS2DX_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../cocos2d-x-3.17.2)
set(CMAKE_MODULE_PATH ${COCOS2DX_ROOT_PATH}/cmake/Modules/)

include(CocosBuildSet)

# 添加Cocos2d-x库
add_subdirectory(${COCOS2DX_ROOT_PATH}/cocos ${CMAKE_CURRENT_BINARY_DIR}/cocos/core)

# 设置源代码目录
set(GAME_SOURCE
    Classes/AppDelegate.cpp
    Classes/AppDelegate.h
)

# 递归添加所有Classes目录下的cpp文件
file(GLOB_RECURSE GAME_CLASSES 
    Classes/*.cpp
    Classes/*.h
)

list(APPEND GAME_SOURCE ${GAME_CLASSES})

# Emscripten 平台添加 main.cpp
if(EMSCRIPTEN)
    list(APPEND GAME_SOURCE proj.emscripten/main.cpp)
endif()

# 设置资源目录
set(GAME_RES_FOLDER
    "${CMAKE_CURRENT_SOURCE_DIR}/Resources"
)

if(EMSCRIPTEN)
    # WebAssembly/Emscripten 配置
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -s USE_SDL=2 -s USE_WEBGL2=1 -s WASM=1 -s FULL_ES3=1")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -s ALLOW_MEMORY_GROWTH=1 -s INITIAL_MEMORY=64MB")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -s EXPORTED_RUNTIME_METHODS=['ccall','cwrap']")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -s DISABLE_EXCEPTION_CATCHING=0")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --preload-file ${GAME_RES_FOLDER}@Resources")
    
    # 禁用一些在Web上不支持的功能
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DCC_ENABLE_SCRIPT_BINDING=0")
    
    # 禁用需要第三方库的功能
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DCC_USE_FREETYPE=0")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DCC_USE_NAVMESH=0")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DCC_USE_PHYSICS=0")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DCC_USE_3D_PHYSICS=0")
    
    add_executable(${APP_NAME} ${GAME_SOURCE})
    
    # 设置输出文件
    set_target_properties(${APP_NAME} PROPERTIES
        SUFFIX ".html"
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    )
else()
    # Windows/Linux/macOS 桌面平台
    if(WIN32)
        list(APPEND GAME_SOURCE proj.win32/main.cpp)
    else()
        list(APPEND GAME_SOURCE proj.linux/main.cpp)
    endif()
    
    add_executable(${APP_NAME} ${GAME_SOURCE})
endif()

target_link_libraries(${APP_NAME} cocos2d)

target_include_directories(${APP_NAME}
    PRIVATE Classes
    PRIVATE ${COCOS2DX_ROOT_PATH}/cocos
    PRIVATE ${COCOS2DX_ROOT_PATH}/cocos/platform
    PRIVATE ${COCOS2DX_ROOT_PATH}/cocos/audio/include
    PRIVATE ${COCOS2DX_ROOT_PATH}/external
    PRIVATE ${COCOS2DX_ROOT_PATH}/extensions
    PRIVATE ${COCOS2DX_ROOT_PATH}/cocos/editor-support
)

# 设置C++标准
set_target_properties(${APP_NAME} PROPERTIES
    CXX_STANDARD 11
    CXX_STANDARD_REQUIRED ON
)

# 复制资源文件到构建目录
if(NOT EMSCRIPTEN)
    add_custom_command(TARGET ${APP_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_directory
        ${GAME_RES_FOLDER} $<TARGET_FILE_DIR:${APP_NAME}>/Resources
    )
endif()

# 链接设置
if(EMSCRIPTEN)
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -s USE_SDL=2 -s WASM=1")
endif()
