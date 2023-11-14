cmake_minimum_required(VERSION 3.21)
project(CmakeCourse VERSION 1.0.0 LANGUAGES C CXX)

# set() creates a variable to be used in all CMakeLists.txt
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(LIBRARY_NAME Library)
set(EXECUTABLE_NAME Executable)

# option() are input variables from command line
# gets saved in CMakeCache.txt
option(COMPILE_EXECUTABLE "Whether to compile the executable" OFF)
message("COMPILE_EXECUTABLE ${COMPILE_EXECUTABLE}")

set(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake/")
include(AddGitSubmodule) # * name of .cmake file, inside ${PROJECT_SOURCE_DIR}/cmake
include(Docs)

option(ENABLE_WARNINGS "Enable warnings" ON)
option(ENABLE_WARNINGS_AS_ERRORS "Enable warnings as errors" ON)

if(ENABLE_WARNINGS)
    include(Warnings)
endif()

# * add_git_submodule is a function added by AddGitSubmodule above
# * it executes "git" custom commands that we wrote
# add_git_submodule(external/json)

# * FetchContent is an internal CMake module that clones a git repo into
# * the "build" folder and configures it for this project
include(FetchContent)

# JSON library
FetchContent_Declare(
    nlohmann_json
    GIT_REPOSITORY https://github.com/nlohmann/json
    GIT_TAG v3.11.2
    GIT_SHALLOW TRUE
)
FetchContent_MakeAvailable(nlohmann_json)

# Format Strings
FetchContent_Declare(
    fmt
    GIT_REPOSITORY https://github.com/fmtlib/fmt
    GIT_TAG 10.1.1
    GIT_SHALLOW TRUE
)
FetchContent_MakeAvailable(fmt)

# Logging
FetchContent_Declare(
    spdlog
    GIT_REPOSITORY https://github.com/gabime/spdlog
    GIT_TAG v1.12.0
    GIT_SHALLOW TRUE
)
FetchContent_MakeAvailable(spdlog)

# Command Line arguments parser
FetchContent_Declare(
    cxxopts
    GIT_REPOSITORY https://github.com/jarro2783/cxxopts
    GIT_TAG v3.1.1
    GIT_SHALLOW TRUE
)
FetchContent_MakeAvailable(cxxopts)

# Unit test
FetchContent_Declare(
    Catch2
    GIT_REPOSITORY https://github.com/catchorg/Catch2
    GIT_TAG v3.4.0
    GIT_SHALLOW TRUE
)
FetchContent_MakeAvailable(Catch2)

add_subdirectory(external)
add_subdirectory(configured)

# src must come before app because app depends on src library
add_subdirectory(src)

if(COMPILE_EXECUTABLE)
    add_subdirectory(app)
else()
    message("Without exe compiling")
endif()

# * Use Catch2 to create Unit Tests
option(ENABLE_TESTING "Enable a Unit Testing Build" OFF)
add_subdirectory(tests)
