//-----------------------------------------------------------------------------
// Ch16_01.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include "Ch16_01.h"

int main(void)
{
    char vendor[13];
    char brand[49];
    constexpr size_t vendor_len = sizeof(vendor);
    constexpr size_t brand_len = sizeof(brand);

    std::cout << "----- Results for Ch16_01 -----\n\n";

    int max_leaf = GetProcessorVendorInfo_a(vendor, vendor_len, brand, brand_len);
    
    if (max_leaf >= 0)
    {
        constexpr char nl = '\n';

        std::cout << "max_leaf:         " << max_leaf << nl;
        std::cout << "Processor vendor: " << vendor << nl;
        std::cout << "Processor brand:  " << brand << nl;
    }
    else
        std::cout << "GetProcessorVendorInfo_a() failed!\n";

    return 0;
}
