function(add_clang_tidy_to_target target)
    get_target_property(TARGET_SOURCES ${target} SOURCES)
    list(
        FILTER
        TARGET_SOURCES
        INCLUDE
        REGEX
        ".*.(cc|h|cpp|hpp)")
    message("TARGET_SOURCES ${TARGET_SOURCES}")

    find_package(Python3 COMPONENTS Interpreter)
    if(NOT ${Python_FOUND})
        message(WARNING "Python3 needed for Clang-Tidy")
        return()
    endif()

    find_program(CLANGTIDY clang-tidy)
    if(CLANGTIDY)
        if(CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
            message(STATUS "Added MSVC ClangTidy (VS GUI only) for: ${target}")
            set_target_properties(
                ${target} PROPERTIES VS_GLOBAL_EnableMicrosoftCodeAnalysis
                                     false)
            set_target_properties(
                ${target} PROPERTIES VS_GLOBAL_EnableClangTidyCodeAnalysis true)
        else()
            message(STATUS "Added Clang Tidy for Target: ${target}")
            add_custom_target(
                ${target}_clangtidy
                COMMAND
                    ${Python3_EXECUTABLE}
                    ${CMAKE_SOURCE_DIR}/tools/run-clang-tidy.py
                    ${TARGET_SOURCES}
                    -config-file=${CMAKE_SOURCE_DIR}/.clang-tidy
                    -extra-arg-before=-std=${CMAKE_CXX_STANDARD}
                    -header-filter="\(src|app\)\/*.\(h|hpp\)"
                    -p=${CMAKE_BINARY_DIR}
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                USES_TERMINAL)
        endif()
    else()
        message(WARNING "CLANGTIDY NOT FOUND")
    endif()
endfunction()

function(add_clang_format_target)
    if(NOT ${ENABLE_CLANG_FORMAT})
        return()
    endif()
    find_package(Python3 COMPONENTS Interpreter)
    if(NOT ${Python_FOUND})
        return()
    endif()
    # include only project directories
    set(CLANG_FORMAT_DIRS
        "${PROJECT_SOURCE_DIR}/app"
        "${PROJECT_SOURCE_DIR}/coverage"
        "${PROJECT_SOURCE_DIR}/tests"
        "${PROJECT_SOURCE_DIR}/src")
    foreach(clang_formar_dir ${CLANG_FORMAT_DIRS})
        list(APPEND CMAKE_DIRS_CC "${clang_formar_dir}/*.cc")
    endforeach()
    foreach(clang_formar_dir ${CLANG_FORMAT_DIRS})
        list(APPEND CMAKE_DIRS_CPP "${clang_formar_dir}/*.cpp")
    endforeach()
    foreach(clang_formar_dir ${CLANG_FORMAT_DIRS})
        list(APPEND CMAKE_DIRS_H "${clang_formar_dir}/*.h")
    endforeach()
    foreach(clang_formar_dir ${CLANG_FORMAT_DIRS})
        list(APPEND CMAKE_DIRS_HPP "${clang_formar_dir}/*.hpp")
    endforeach()

    file(GLOB_RECURSE CMAKE_FILES_CC ${CMAKE_DIRS_CC})
    file(GLOB_RECURSE CMAKE_FILES_CPP ${CMAKE_DIRS_CPP})
    file(GLOB_RECURSE CMAKE_FILES_H ${CMAKE_DIRS_H})
    file(GLOB_RECURSE CMAKE_FILES_HPP ${CMAKE_DIRS_HPP})
    set(CPP_FILES
        ${CMAKE_FILES_CC}
        ${CMAKE_FILES_CPP}
        ${CMAKE_FILES_H}
        ${CMAKE_FILES_HPP})
    message("CPP_FILES ${CPP_FILES}")
    list(
        FILTER
        CPP_FILES
        EXCLUDE
        REGEX
        "${CMAKE_SOURCE_DIR}/(out|build|external)/.*")
    find_program(CLANGFORMAT clang-format)
    if(CLANGFORMAT)
        message(STATUS "Added Clang Format")
        add_custom_target(
            run_clang_format
            COMMAND
                ${Python3_EXECUTABLE}
                ${CMAKE_SOURCE_DIR}/tools/run-clang-format.py ${CPP_FILES}
                --in-place
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            USES_TERMINAL)
    else()
        message(WARNING "CLANGFORMAT NOT FOUND")
    endif()
endfunction()

function(add_cmake_format_target)
    if(NOT ${ENABLE_CMAKE_FORMAT})
        return()
    endif()
    set(ROOT_CMAKE_FILES "${CMAKE_SOURCE_DIR}/CMakeLists.txt")
    # include only project directories
    file(
        GLOB_RECURSE
        CMAKE_FILES_TXT
        "${PROJECT_SOURCE_DIR}/app/CMakeLists.txt"
        "${PROJECT_SOURCE_DIR}/configured/CMakeLists.txt"
        "${PROJECT_SOURCE_DIR}/tests/CMakeLists.txt"
        "${PROJECT_SOURCE_DIR}/src/CMakeLists.txt")
    file(GLOB_RECURSE CMAKE_FILES_C "cmake/*.cmake")
    list(
        FILTER
        CMAKE_FILES_TXT
        EXCLUDE
        REGEX
        "${CMAKE_SOURCE_DIR}/(out|build|external)/.*")
    set(CMAKE_FILES ${ROOT_CMAKE_FILES} ${CMAKE_FILES_TXT} ${CMAKE_FILES_C})
    message("CMAKE_FILES ${CMAKE_FILES}")
    find_program(CMAKE_FORMAT ${PYTHON_VENV_BIN}/cmake-format)
    if(CMAKE_FORMAT)
        message(STATUS "Added Cmake Format")
        set(FORMATTING_COMMANDS)
        foreach(cmake_file ${CMAKE_FILES})
            list(
                APPEND
                FORMATTING_COMMANDS
                COMMAND
                ${PYTHON_VENV_BIN}/cmake-format
                -c
                ${CMAKE_SOURCE_DIR}/.cmake-format.yaml
                -i
                ${cmake_file})
        endforeach()
        add_custom_target(
            run_cmake_format
            COMMAND ${FORMATTING_COMMANDS}
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
    else()
        message(WARNING "CMAKE_FORMAT NOT FOUND")
    endif()
endfunction()
