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
option(COMPILE_EXECUTABLE "Whether to compile the executable" ON)
message("COMPILE_EXECUTABLE ${COMPILE_EXECUTABLE}")

set(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake/")
include(AddGitSubmodule) # * name of .cmake file, inside ${PROJECT_SOURCE_DIR}/cmake
include(Docs)
include(ConfigSafeGuards)

option(ENABLE_WARNINGS "Enable warnings" ON)
option(ENABLE_WARNINGS_AS_ERRORS "Enable warnings as errors" ON)

if(ENABLE_WARNINGS)
    include(Warnings)
endif()

option(ENABLE_SANITIZE_ADDR "Enable ..." ON)
option(ENABLE_SANITIZE_UNDEF "Enable ..." ON)

if(ENABLE_SANITIZE_ADDR OR ENABLE_SANITIZE_UNDEF)
    include(Sanitizers)
    add_sanitizer_flags()
endif()

# Link Time Optimization - Optimizations during linkage
# it may remove functions that our code doesn't use
# Do not use together with SANITIZE options
option(ENABLE_LTO "Enable ..." ON)

if(ENABLE_LTO)
    include(LTO)
endif()

option(USE_CPM "Whether to use CPM" OFF)
option(USE_CONAN "Whether to use Conan" OFF)
option(USE_VCPKG "Whether to use VCPKG" ON)

if(USE_CPM)
    message(STATUS "Using CPM")
    include(CPM)

    # gh = github
    cpmaddpackage("gh:nlohmann/json#v3.11.2")
    cpmaddpackage("gh:fmtlib/fmt#10.1.1")
    cpmaddpackage("gh:gabime/spdlog#v1.12.0")
    cpmaddpackage("gh:jarro2783/cxxopts#v3.1.1")
    cpmaddpackage("gh:catchorg/Catch2#v3.4.0")
elseif(${USE_CONAN})
    message(STATUS "Using Conan")
    include(${CMAKE_BINARY_DIR}/conan_toolchain.cmake)

    find_package(nlohmann_json REQUIRED)
    find_package(fmt REQUIRED)
    find_package(spdlog REQUIRED)
    find_package(cxxopts REQUIRED)
    find_package(Catch2 REQUIRED)
elseif(USE_VCPKG)
    message(STATUS "Using VCPKG")
    include(${VCPKG_DIR}/scripts/buildsystems/vcpkg.cmake)
    find_package(nlohmann_json CONFIG REQUIRED)
    find_package(fmt CONFIG REQUIRED)
    find_package(spdlog REQUIRED)
    find_package(cxxopts CONFIG REQUIRED)
    find_package(Catch2 CONFIG REQUIRED)
else()
    # * add_git_submodule is a function added by AddGitSubmodule above
    # * it executes "git" custom commands that we wrote
    # add_git_submodule(external/json)
    message(STATUS "Using FetchContent")

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
endif()

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
option(ENABLE_TESTING "Enable a Unit Testing Build" ON)
add_subdirectory(tests)
