function(target_enable_lto)
    # TARGET and ENABLE are parameters that can receive one value
    set(oneValueArgs TARGET ENABLE)
    # after parse, all variables will be prefixed with `LTO`
    cmake_parse_arguments(
        LTO
        "${options}"
        "${oneValueArgs}"
        "${multiValueArgs}"
        ${ARGN})

    if(NOT ${LTO_ENABLE})
        return()
    endif()

    include(CheckIPOSupported)
    check_ipo_supported(
        RESULT
        result
        OUTPUT
        output)

    if(result)
        message(STATUS "IPO/LTO is supported: ${LTO_TARGET}")
        set_property(TARGET ${LTO_TARGET} PROPERTY INTERPROCEDURAL_OPTIMIZATION
                                                   ${LTO_ENABLE})
        target_compile_options(${LTO_TARGET} PUBLIC "-Gy")
        target_link_options(${LTO_TARGET} PUBLIC "-LTCG")
    else()
        message(WARNING "IPO/LOT is not supported:  ${LTO_TARGET}")
    endif()
endfunction()
