//-----------------------------------------------------------------------------
// Ch16_02.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include <cstring>
#include "Ch16_02.h"

const char* s_FlagNames[CpuidFlags::NUM_FLAGS]
{
    "POPCNT",
    "AVX",
    "AVX2",
    "FMA",
    "AVX512F",
    "AVX512VL",
    "AVX512DQ",
    "AVX512BW",
    "AVX512_VBMI",
    "AVX512_VBMI2",
    "AVX512_FP16",
    "AVX512_BF16"
};

int main(void)
{
    char vendor[13];
    char brand[49];
    constexpr size_t vendor_len = sizeof(vendor);
    constexpr size_t brand_len = sizeof(brand);

    std::cout << "----- Results for Ch16_02 -----\n\n";

    int max_leaf = GetProcessorVendorInfo_a(vendor, vendor_len, brand, brand_len);

    if (max_leaf >= 0)
    {
        constexpr char nl = '\n';
        constexpr size_t num_flags = CpuidFlags::NUM_FLAGS;
        uint8_t flags[num_flags];

        std::cout << "Processor vendor: " << vendor << nl;
        std::cout << "Processor brand:  " << brand << nl;

        bool rc = GetCpuidFlags_a(flags, num_flags);

        if (rc)
        {
            std::cout << "\nCPUID Feature Flags\n";
            std::cout << std::string(23, '-') << nl;

            for (size_t i = 0; i < num_flags; i++)
            {
                std::string s1 = std::string(s_FlagNames[i]);
                std::string s2 = s1 + std::string(":    ");

                std::cout << std::setw(20) << std::left << s2;
                std::cout << std::setw(2) << (unsigned)flags[i] << nl;
            }
        }
        else
            std::cout << "GetCpuidFlags_a() failed!\n";
    }
    else
        std::cout << "GetProcessorVendorInfo_a() failed!\n";

    return 0;
}
