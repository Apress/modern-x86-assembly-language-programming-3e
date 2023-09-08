//-----------------------------------------------------------------------------
// Ch16_05.cpp
//-----------------------------------------------------------------------------

#define _CRT_SECURE_NO_WARNINGS
#include <iostream>
#include <iomanip>
#include <string>
#include <cstring>
#include <stdexcept>
#include "Ch16_05.h"
#include "StringGenerator.h"

static void ReplaceChar(void)
{
    StringGenerator sg;
    sg.GenerateStrings(c_NumTestStrings, c_CharMin, c_CharMax, c_MinLen, c_MaxLen);

    std::cout << "----- Results for Ch16_05 -----\n";

    for (size_t i = 0; i < c_NumTestStrings; i++)
    {
        constexpr char nl = '\n';
        constexpr size_t cout_i_max = 10;

        if (i <= cout_i_max)
            std::cout << "\n----- Test case #" << i << " -----\n";

        char* s1 = sg.GetStringG1(i);
        char* s2 = sg.GetStringG2(i);

        if (strcmp(s1, s2) != 0)
            throw std::runtime_error("ReplaceChar() - error #1\n");

        size_t num_replaced1, num_replaced2;

        if (i <= cout_i_max)
            std::cout << "s1 before:     " << s1 << nl;

        num_replaced1 = ReplaceChar_cpp(s1, c_CharOld, c_CharNew);

        if (i <= cout_i_max)
        {
            std::cout << "s1 after:      " << s1 << nl;
            std::cout << "num_replaced1: " << num_replaced1 << nl;
            std::cout << "s2 before:     " << s2 << nl;
        }

        num_replaced2 = ReplaceChar_avx2(s2, c_CharOld, c_CharNew);

        if (i <= cout_i_max)
        {
            std::cout << "s2 after:      " << s2 << nl;
            std::cout << "num_replaced2: " << num_replaced2 << nl;
        }

        if ((strcmp(s1, s2) != 0) || (num_replaced1 != num_replaced2))
        {
            std::cout << "ReplaceChar() - compare test FAILED! (i = " << i << ")\n";
            break;
        }
    }
}

int main(void)
{
    try
    {
        ReplaceChar();
        ReplaceChar_bm();
    }

    catch (std::exception& ex)
    {
        std::cout << "Ch16_05 exception: " << ex.what() << '\n';
    }

    return 0;
}
