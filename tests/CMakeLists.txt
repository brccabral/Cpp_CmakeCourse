if(ENABLE_TESTING)

    set(TEST_MAIN "unit_tests")
    set(TEST_SOURCES "main.cc")
    set(TEST_INCLUDES "./" "${CMAKE_SOURCE_DIR}/src/my_lib")

    add_executable(${TEST_MAIN} ${TEST_SOURCES})
    target_include_directories(${TEST_MAIN} PUBLIC ${TEST_INCLUDES})
    target_link_libraries(
        ${TEST_MAIN} PUBLIC ${LIBRARY_NAME} Catch2::Catch2WithMain
                            nlohmann_json::nlohmann_json)
    install(
        TARGETS ${TEST_MAIN}
        EXPORT ${LIBRARY_NAME}
        ARCHIVE DESTINATION lib
        LIBRARY DESTINATION lib
        RUNTIME DESTINATION bin)

    if(${ENABLE_WARNINGS})
        target_set_warnings(
            TARGET
            ${TEST_MAIN}
            ENABLE
            ${ENABLE_WARNINGS}
            AS_ERRORS
            ${ENABLE_WARNINGS_AS_ERRORS})
    endif()

    if(ENABLE_COVERAGE)
        set(COVERAGE_MAIN "coverage")
        # only "my_lib" target
        # COVERAGE_EXCLUDES is used inside setup_target_for_coverage_lcov()
        set(COVERAGE_EXCLUDES
            "${PROJECT_SOURCE_DIR}/app/*"
            "${PROJECT_SOURCE_DIR}/cmake/*"
            "${PROJECT_SOURCE_DIR}/docs/*"
            "${PROJECT_SOURCE_DIR}/external/*"
            "${PROJECT_SOURCE_DIR}/tests/*"
            "${PROJECT_SOURCE_DIR}/build/*"
            "${PROJECT_SOURCE_DIR}/out/*"
            "/usr/include/*")
        setup_target_for_coverage_lcov(
            NAME
            ${COVERAGE_MAIN}
            EXECUTABLE
            ${TEST_MAIN}
            DEPENDENCIES
            ${TEST_MAIN})
    endif()

endif()
