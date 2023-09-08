//-----------------------------------------------------------------------------
// StringGenerator.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>
#include <vector>

// Note: The code in class StringGenerator is suitable for example
// Ch16_05. Modifications will be necessary for other use cases.

class StringGenerator
{
    static constexpr unsigned int c_RngSeedDef = 119;

    std::vector<char> m_StringBuffG1;
    std::vector<char> m_StringBuffG2;
    std::vector<char*> m_StringPtrsG1;
    std::vector<char*> m_StringPtrsG2;

public:
    StringGenerator()  {}
    ~StringGenerator() {}

    void GenerateStrings(size_t num_str, char char_min, char char_max,
        size_t str_min_len, size_t str_max_len, unsigned int rng_seed1 = c_RngSeedDef);

    char* GetStringG1(size_t index) { return m_StringPtrsG1[index]; }
    char* GetStringG2(size_t index) { return m_StringPtrsG2[index]; }
};
