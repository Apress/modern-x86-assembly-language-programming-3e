//-----------------------------------------------------------------------------
// Ch16_05_fcpp.cpp
//-----------------------------------------------------------------------------

#include <cstring>
#include "Ch16_05.h"

size_t ReplaceChar_cpp(char* s, char char_old, char char_new)
{
    size_t num_replaced = 0;

    for (size_t i = 0; s[i] != '\0'; i++)
    {
        if (s[i] == char_old)
        {
            s[i] = char_new;
            num_replaced++;
        }
    }

    return num_replaced;
}
