//-----------------------------------------------------------------------------
// Ch03_05_misc.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include "Ch03_05.h"

void DisplayResults(int id, int64_t n, int64_t sum1, bool rc1,
    int64_t sum2, bool rc2)
{
    constexpr char nl = '\n';
    const char* err_msg = "error: 'n' is out of range";

    std::cout << nl << "----- Test case #" << id << " -----\n";
    std::cout << "n = " << n << nl;

    std::cout << "sum1 = ";

    if (rc1)
        std::cout << sum1 << nl;
    else
        std::cout << err_msg << nl;

    std::cout << "sum2 = ";

    if (rc2)
        std::cout << sum2 << nl;
    else
        std::cout << err_msg << nl;

    if (sum1 != sum2)
        std::cout << "Compare test failed!\n";
}
