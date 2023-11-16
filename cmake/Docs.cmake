find_package(Doxygen)

if(DOXYGEN_FOUND)
    message("DOXYGEN_EXECUTABLE ${DOXYGEN_EXECUTABLE}")
    add_custom_target(
        docs
        ${DOXYGEN_EXECUTABLE}
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/docs)
endif()
