#include <catch2/catch_test_macros.hpp>

#include <my_lib.hpp>

TEST_CASE("Factorial of 0 is 1 (fail)", "[single-file]")
{
    REQUIRE(factorial(0) == 1);
}

TEST_CASE("Factorials are computed", "[factorial]")
{
    REQUIRE(factorial(1) == 1);
    REQUIRE(factorial(2) == 2);
    REQUIRE(factorial(3) == 6);
    REQUIRE(factorial(10) == 3628800);
}
