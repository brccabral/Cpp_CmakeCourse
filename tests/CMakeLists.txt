if(ENABLE_TESTING)

set(TEST_MAIN "unit_tests")
set(TEST_SOURCES "main.cc")
set(TEST_INCLUDES
    "./"
    "${CMAKE_SOURCE_DIR}/src/my_lib"
)

add_executable(${TEST_MAIN} ${TEST_SOURCES})
target_include_directories(${TEST_MAIN} PUBLIC ${TEST_INCLUDES})
target_link_libraries(${TEST_MAIN} PUBLIC ${LIBRARY_NAME} Catch2::Catch2WithMain nlohmann_json::nlohmann_json)
install(TARGETS ${TEST_MAIN})

endif()