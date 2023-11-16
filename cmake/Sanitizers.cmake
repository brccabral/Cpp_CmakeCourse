# On Windows, compiling with MSVC, the Sanitizer output is not print in CMD,
# need to execute with Visual Studio to see the full error message
function(add_sanitizer_flags)
    if(NOT ${ENABLE_SANITIZE_ADDR} OR NOT ${ENABLE_SANITIZE_UNDEF})
        message(STATUS "Sanitizers deactivated.")
        return()
    endif()

    if(CMAKE_CXX_COMPILER_ID MATCHES "CLANG" OR CMAKE_CXX_COMPILER_ID MATCHES "Clang" OR CMAKE_CXX_COMPILER_ID MATCHES "GNU")
        if(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
            add_compile_options("-fno-omit-frame-pointer")
            add_link_options("-fno-omit-frame-pointer")
        endif()

        if(${ENABLE_SANITIZE_ADDR})
            add_compile_options("-fsanitize=address")
            add_link_options("-fsanitize=address")
        endif()

        if(${ENABLE_SANITIZE_UNDEF})
            add_compile_options("-fsanitize=undefined")
            add_link_options("-fsanitize=undefined")
        endif()

        if(${ENABLE_SANITIZE_LEAK})
            add_compile_options("-fsanitize=leak")
            add_link_options("-fsanitize=leak")
        endif()

        if(${ENABLE_SANITIZE_THREAD})
            if(ENABLE_SANITIZE_ADDR OR ${ENABLE_SANITIZE_LEAK})
                message(WARNING "thread does not work with: address and leak")
            endif()

            add_compile_options("-fsanitize=thread")
            add_link_options("-fsanitize=thread")
        endif()
    elseif(CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
        if(${ENABLE_SANITIZE_ADDR})
            add_compile_options("/fsanitize=address")
        endif()

        if(${ENABLE_SANITIZE_UNDEF})
            message(WARNING "Undefined sanitizer not implemented for MSVC.")
        endif()

        if(${ENABLE_SANITIZE_LEAK})
            message(STATUS "sanitize=leak not avail. for MSVC")
        endif()

        if(${ENABLE_SANITIZE_THREAD})
            message(STATUS "sanitize=thread not avail. for MSVC")
        endif()
    else()
        message(SEND_ERROR "Compiler ${CMAKE_CXX_COMPILER_ID} not supported for sanitizers.")
    endif()
endfunction()