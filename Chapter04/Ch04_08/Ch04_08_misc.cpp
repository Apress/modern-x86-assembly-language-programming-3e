//-----------------------------------------------------------------------------
// Ch04_08_misc.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <cstddef>
#include "Ch04_08.h"

void DisplayResults(const TestStruct& ts, int64_t sum1, int64_t sum2)
{
    constexpr char nl = '\n';

    std::cout << "----- Results for Ch04_08 -----\n";

    std::cout << "\n--- TestStruct Offsets ---\n";
    std::cout << "offsetof(ts.Val8):   " << offsetof(TestStruct, Val8) << nl;
    std::cout << "offsetof(ts.Val64):  " << offsetof(TestStruct, Val64) << nl;
    std::cout << "offsetof(ts.Val16):  " << offsetof(TestStruct, Val16) << nl;
    std::cout << "offsetof(ts.Val32):  " << offsetof(TestStruct, Val32) << nl;

    std::cout << "\n--- Calculated Results ---\n";
    std::cout << "ts1.Val8:   " << (int)ts.Val8 << nl;
    std::cout << "ts1.Val16:  " << ts.Val16 << nl;
    std::cout << "ts1.Val32:  " << ts.Val32 << nl;
    std::cout << "ts1.Val64:  " << ts.Val64 << nl;
    std::cout << "sum1:       " << sum1 << nl;
    std::cout << "sum2:       " << sum2 << nl;
}
