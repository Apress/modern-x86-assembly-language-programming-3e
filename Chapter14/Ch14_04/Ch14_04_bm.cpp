//-----------------------------------------------------------------------------
// Ch14_04_bm.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include "Ch14_04.h"
#include "BmThreadTimer.h"

void CalcCovMatF64_bm(void)
{
    std::cout << "\nRunning benchmark function CalcCovMatF64_bm() - please wait\n";

    constexpr size_t n_vars = 10;
    constexpr size_t n_obvs = 250000;

    CMD cmd0(n_vars, n_obvs);
    CMD cmd1(n_vars, n_obvs);
    InitCMD(cmd0, cmd1);

    constexpr size_t num_alg = 2;
    constexpr size_t num_iter = BmThreadTimer::NumIterDef;
    BmThreadTimer bmtt(num_iter, num_alg);

    for (size_t i = 0; i < num_iter; i++)
    {
        bmtt.Start(i, 0);
        CalcCovMatF64_cmd0(cmd0);
        bmtt.Stop(i, 0);

        bmtt.Start(i, 1);
        CalcCovMatF64_cmd1(cmd1);
        bmtt.Stop(i, 1);

        if (i % 25 == 0)
            std::cout << '.' << std::flush;
    }

    std::cout << '\n';
    std::string fn = bmtt.BuildCsvFilenameString("@Ch14_04_CalcCovMatF64_bm");
    bmtt.SaveElapsedTimes(fn, BmThreadTimer::EtUnit::MicroSec, 2);
    std::cout << "Benchmark times save to file " << fn << '\n';
}
