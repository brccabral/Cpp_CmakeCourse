cmake_minimum_required(VERSION 3.21)
project(CmakeCourse VERSION 1.0.0 LANGUAGES C CXX)

# src must come before app because app depends on src library
add_subdirectory(src)
add_subdirectory(app)

install(TARGETS Executable)
