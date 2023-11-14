# On Windows, compiling with MSVC, the Sanitizer output is not print in CMD,
# need to execute with Visual Studio to see the full error message
function(add_sanitizer_flags)
    if(NOT ${ENABLE_SANITIZE_ADDR} OR NOT ${ENABLE_SANITIZE_UNDEF})
        message(STATUS "Sanitizers deactivated.")
        return()
    endif()

    if(CMAKE_CXX_COMPILER_ID MATCHES "CLANG" OR CMAKE_CXX_COMPILER_ID MATCHES "GNU")
        add_compile_options("-fno-omit-frame-pointer")
        add_link_options("-fno-omit-frame-pointer")

        if(${ENABLE_SANITIZE_ADDR})
            add_compile_options("-fsanitize=address")
            add_link_options("-fsanitize=address")
        endif()

        if(${ENABLE_SANITIZE_UNDEF})
            add_compile_options("-fsanitize=undefined")
            add_link_options("-fsanitize=undefined")
        endif()
    elseif(CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
        if(${ENABLE_SANITIZE_ADDR})
            add_compile_options("/fsanitize=address")
        endif()

        if(${ENABLE_SANITIZE_UNDEF})
            message(WARNING "Undefined sanitizer not implemented for MSVC.")
        endif()
    else()
        message(SEND_ERROR "Compiler not supported for sanitizers.")
    endif()
endfunction()