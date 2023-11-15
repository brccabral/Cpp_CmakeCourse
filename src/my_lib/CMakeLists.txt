set(LIBRARY_SOURCES
    "my_lib.cc")
set(LIBRARY_HEADERS
    "my_lib.h")
set(LIBRARY_INCLUDES
    "./"
    "${CMAKE_BINARY_DIR}/configured_files/include"
)
if(NOT ${nlohmann_json_INCLUDE_DIRS} STREQUAL "")
set(LIBRARY_INCLUDES ${LIBRARY_INCLUDES} ${nlohmann_json_INCLUDE_DIRS})
endif()
if(NOT ${cxxopts_INCLUDE_DIRS} STREQUAL "")
set(LIBRARY_INCLUDES ${LIBRARY_INCLUDES} ${cxxopts_INCLUDE_DIRS})
endif()
if(NOT ${fmt_INCLUDE_DIRS} STREQUAL "")
set(LIBRARY_INCLUDES ${LIBRARY_INCLUDES} ${fmt_INCLUDE_DIRS})
endif()
if(NOT ${spdlog_INCLUDE_DIRS} STREQUAL "")
set(LIBRARY_INCLUDES ${LIBRARY_INCLUDES} ${spdlog_INCLUDE_DIRS})
message("spdlog_INCLUDE_DIRS ${spdlog_INCLUDE_DIRS}")
endif()

add_library(${LIBRARY_NAME} STATIC ${LIBRARY_SOURCES})
target_include_directories(${LIBRARY_NAME} PUBLIC
    ${LIBRARY_INCLUDES}
)
target_link_libraries(${LIBRARY_NAME} PUBLIC
    nlohmann_json::nlohmann_json
    fmt::fmt
    spdlog::spdlog
    cxxopts::cxxopts
)

if(${ENABLE_WARNINGS})
    target_set_warnings(${LIBRARY_NAME} ${ENABLE_WARNINGS} ${ENABLE_WARNINGS_AS_ERRORS})
endif()

if(${ENABLE_LTO})
    target_enable_lto(${LIBRARY_NAME} ${ENABLE_LTO})
endif()
