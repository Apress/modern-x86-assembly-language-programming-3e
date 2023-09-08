//-----------------------------------------------------------------------------
// Ch10_06_misc.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <fstream>
#include <string>
#include "Ch10_06.h"
#include "OS.h"

void SaveHistograms(const uint32_t* histo0, const uint32_t* histo1,
    size_t histo_size, bool rc0, bool rc1)
{
    if (!rc0 || !rc1)
    {
        std::cout << "Histogram build error!\n";
        std::cout << "  rc0 = " << std::boolalpha << rc0 << '\n';
        std::cout << "  rc1 = " << std::boolalpha << rc1 << '\n';
        return;
    }

    std::string fn("@Ch10_06_Histograms_");

    fn += OS::GetComputerName();
    fn += std::string(".csv");

    std::ofstream ofs(fn);
    bool are_identical = true;

    for (size_t i = 0; i < histo_size; i++)
    {
        ofs << i << ", " << histo0[i] << ", " << histo1[i];

        if (histo0[i] == histo1[i])
            ofs << ", 1\n";
        else
        {
            are_identical = false;
            ofs << ", 0\n";
        }
    }

    ofs.close();

    if (are_identical)
        std::cout << "Histograms are identical\n";
    else
        std::cout << "Histograms are different!\n";

    std::cout << "Histograms saved to file " << fn << '\n';
}
