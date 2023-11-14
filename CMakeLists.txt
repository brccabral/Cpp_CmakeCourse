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

set(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake/")
include(AddGitSubmodule) # * name of .cmake file, inside ${PROJECT_SOURCE_DIR}/cmake

# * add_git_submodule is a function added by AddGitSubmodule above
# * it executes "git" custom commands that we wrote
# add_git_submodule(external/json)

# * FetchContent is an internal CMake module that clones a git repo into
# * the "build" folder and configures it for this project
include(FetchContent)
FetchContent_Declare(
    nlohmann_json
    GIT_REPOSITORY https://github.com/nlohmann/json
    GIT_TAG v3.11.2
    GIT_SHALLOW TRUE
)
FetchContent_MakeAvailable(nlohmann_json)

add_subdirectory(external)
add_subdirectory(configured)
# src must come before app because app depends on src library
add_subdirectory(src)
if (COMPILE_EXECUTABLE)
    add_subdirectory(app)
else()
    message("Without exe compiling")
endif()
