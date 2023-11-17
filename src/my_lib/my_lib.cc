#include "my_lib.h"

/// \file
/**
 * @brief Prints out Hello World! and tests the JSON Lib.
 */
int print_hello_world()
{
    std::cout << "Hello World!\n";

    std::cout << "JSON Lib Version from MyLib:" << NLOHMANN_JSON_VERSION_MAJOR
              << "." << NLOHMANN_JSON_VERSION_MINOR << "."
              << NLOHMANN_JSON_VERSION_PATCH << "\n";

    // Adress Sanitizer should see this :)
    // if address sanitizer is disabled, Clang-Tidy should alert this too
    int *x = new int[42];

    return 42;
}

std::uint32_t factorial(std::uint32_t number)
{
    // return number <= 1 ? number : factorial(number - 1) * number; // * fail
    return number <= 1 ? 1 : factorial(number - 1) * number; // * pass
}
