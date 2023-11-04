#include <iostream>

#include "my_lib.h"
#include "config.hpp"

#include <nlohmann/json.hpp>

int main()
{
    std::cout << project_name << '\n';
    std::cout << project_version << '\n';

    std::cout << "JSON Lib Version:"
              << NLOHMANN_JSON_VERSION_MAJOR << "."
              << NLOHMANN_JSON_VERSION_MINOR << "."
              << NLOHMANN_JSON_VERSION_PATCH << "\n";

    print_hello_world();

    return 0;
}
