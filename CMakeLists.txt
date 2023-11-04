cmake_minimum_required(VERSION 3.21)
project(CmakeCourse VERSION 1.0.0 LANGUAGES C CXX)

add_executable(Executable main.cc)

install(TARGETS Executable)
