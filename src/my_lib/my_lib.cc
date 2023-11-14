#include "my_lib.h"

/// \file
/**
 * @brief Prints out Hello World! and tests the JSON Lib.
 */
void print_hello_world()
{
    std::cout << "Hello World!\n";

    std::cout << "JSON Lib Version from MyLib:"
              << NLOHMANN_JSON_VERSION_MAJOR << "."
              << NLOHMANN_JSON_VERSION_MINOR << "."
              << NLOHMANN_JSON_VERSION_PATCH << "\n";
}
