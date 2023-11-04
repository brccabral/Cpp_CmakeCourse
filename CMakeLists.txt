cmake_minimum_required(VERSION 3.21)
project(CmakeCourse VERSION 1.0.0 LANGUAGES C CXX)

# set() creates a variable to be used in all CMakeLists.txt
set(CMAKE_CXX_STANDARD          17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS        OFF)

set(LIBRARY_NAME Library)
set(EXECUTABLE_NAME Executable)

# option() are input variables from command line
# gets saved in CMakeCache.txt
option(COMPILE_EXECUTABLE "Whether to compile the executable" OFF)
message("COMPILE_EXECUTABLE ${COMPILE_EXECUTABLE}")

# src must come before app because app depends on src library
add_subdirectory(src)
if (COMPILE_EXECUTABLE)
    add_subdirectory(app)
    install(TARGETS Executable)
else()
    message("Without exe compiling")
endif()
