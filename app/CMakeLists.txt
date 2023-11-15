set(EXE_SOURCES
    "main.cc")

add_executable(${EXECUTABLE_NAME} ${EXE_SOURCES})
target_link_libraries(${EXECUTABLE_NAME} PUBLIC
    ${LIBRARY_NAME}
    nlohmann_json
)
install(TARGETS ${EXECUTABLE_NAME})

if(${ENABLE_WARNINGS})
    target_set_warnings(${EXECUTABLE_NAME} ${ENABLE_WARNINGS} ${ENABLE_WARNINGS_AS_ERRORS})
endif()

if(${ENABLE_LTO})
    target_enable_lto(${EXECUTABLE_NAME} ${ENABLE_LTO})
endif()
