//-----------------------------------------------------------------------------
// Ch04_04_fcpp.cpp
//-----------------------------------------------------------------------------

#include "Ch04_04.h"

size_t CountChars_cpp(const char* s, char c)
{
    size_t num_chars = 0;

    for (size_t i = 0; s[i] != '\0'; i++)
    {
        if (s[i] == c)
            num_chars++;
    }

    return num_chars;
}
