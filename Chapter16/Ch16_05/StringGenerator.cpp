//-----------------------------------------------------------------------------
// StringGenerator.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <random>
#include <stdexcept>
#include "StringGenerator.h"

void StringGenerator::GenerateStrings(size_t num_str, char char_min, char char_max,
    size_t str_min_len, size_t str_max_len, unsigned int rng_seed)
{
    // Initialize string buffers
    size_t str_buff_size = num_str * str_max_len + num_str;

    m_StringBuffG1.resize(str_buff_size);
    m_StringBuffG2.resize(str_buff_size);
    m_StringPtrsG1.resize(num_str);
    m_StringPtrsG2.resize(num_str);

    // RNGs for test strings
    std::mt19937 rng1 { rng_seed };
    std::uniform_int_distribution<size_t> dist1 { str_min_len, str_max_len };

    std::mt19937 rng2 { rng_seed * 3 / 7 };
    std::uniform_int_distribution<size_t> dist2 { (unsigned)char_min, (unsigned)char_max };

    // Generate random strings
    char* sb1 = m_StringBuffG1.data();
    char* sb2 = m_StringBuffG2.data();

    for (size_t i = 0; i < num_str; i++)
    {
        m_StringPtrsG1[i] = sb1;
        m_StringPtrsG2[i] = sb2;

        size_t str_len = dist1(rng1);

        for (size_t j = 0; j < str_len; j++)
        {
            char c = (char)dist2(rng2);

            *sb1++ = c;
            *sb2++ = c;
        }

        *sb1++ = '\0';
        *sb2++ = '\0';
    }
}
