//-----------------------------------------------------------------------------
// Ch16_05_test.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <cstring>
#include <stdexcept>
#include "Ch16_05.h"
#include "StringGenerator.h"

static void TestSG1(void)
{
    StringGenerator sg;
    sg.GenerateStrings(c_NumTestStrings, c_CharMin, c_CharMax, c_MinLen, c_MaxLen);

    for (size_t i = 0; i < c_NumTestStrings; i++)
    {
        constexpr char nl = '\n';
        char* s1 = sg.GetStringG1(i);
        char* s2 = sg.GetStringG2(i);

        if (strcmp(s1, s2) != 0)
            throw std::runtime_error("TestSG1() - error #1\n");

        std::cout << "\nTest #" << i << " (";
        std::cout << reinterpret_cast<void*>(s1) << ", ";
        std::cout << reinterpret_cast<void*>(s2) << ")\n";

        std::cout << "Before || s1: " << s1 << nl;
        std::cout << "Before || s2: " << s2 << nl;

        size_t nr1 = ReplaceChar_cpp(s1, c_CharOld, c_CharNew);
        size_t nr2 = ReplaceChar_avx2(s2, c_CharOld, c_CharNew);

        if (strcmp(s1, s2) != 0)
            throw std::runtime_error("TestSG1(void) - error #2\n");

        if (nr1 != nr2)
            throw std::runtime_error("TestSG1(void) - error #3\n");

        std::cout << "After  || s1: " << s1 << " || nr1: " << nr1 << nl;
        std::cout << "After  || s2: " << s2 << " || nr2: " << nr2 << nl;
    }
}

void TestStringGenerator(void)
{
    TestSG1();
}
