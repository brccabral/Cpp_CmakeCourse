# will take config.hpp.in, replace the variables, and copy it to the passed location
configure_file(
    "config.hpp.in" "${CMAKE_BINARY_DIR}/configured_files/include/config.hpp"
    ESCAPE_QUOTES)
