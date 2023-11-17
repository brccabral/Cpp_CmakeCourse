#include <iostream>

#include "config.hpp"
#include "my_lib.hpp"

#include <cxxopts.hpp>
#include <fmt/format.h>
#include <nlohmann/json.hpp>
#ifndef SPDLOG_FMT_EXTERNAL
#define SPDLOG_FMT_EXTERNAL
#endif
#include <spdlog/spdlog.h>

/// \file
/**
 * @brief main function
 */
int main()
{
    std::cout << project_name << '\n';
    std::cout << project_version << '\n';

    // int never_used_var = 0;

    // int check_out_of_bounds[2];
    // check_out_of_bounds[2] = 1337;

    std::cout << "JSON: " << NLOHMANN_JSON_VERSION_MAJOR << "."
              << NLOHMANN_JSON_VERSION_MINOR << "."
              << NLOHMANN_JSON_VERSION_PATCH << "\n";

    std::cout << "FMT: " << FMT_VERSION << "\n";

    std::cout << "CXXOPTS: " << CXXOPTS__VERSION_MAJOR << "."
              << CXXOPTS__VERSION_MINOR << "." << CXXOPTS__VERSION_PATCH
              << "\n";

    std::cout << "SPDLOG: " << SPDLOG_VER_MAJOR << "." << SPDLOG_VER_MINOR
              << "." << SPDLOG_VER_PATCH << "\n";

    print_hello_world();

    return 0;
}
