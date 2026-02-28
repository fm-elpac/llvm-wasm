# 注意: ArchLinux 成功编译, ubuntu 失败 (需要使用 emcmake)
set(CMAKE_SYSTEM_NAME Emscripten)
set(CMAKE_C_COMPILER emcc)
set(CMAKE_CXX_COMPILER em++)
