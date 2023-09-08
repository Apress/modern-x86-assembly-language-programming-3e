//-----------------------------------------------------------------------------
// Ch16_05_bm.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include <sstream>
#include "Ch16_05.h"
#include "BmThreadTimer.h"
#include "StringGenerator.h"

static std::string BuildCsvFilenameString(size_t test_id, size_t ts_min_len, size_t ts_max_len)
{
    std::ostringstream oss;
    constexpr char us = '_';

    oss << std::setfill('0');
    oss << std::setw(6) << test_id;
    oss << us;
    oss << std::setw(3) << ts_min_len;
    oss << us;
    oss << std::setw(3) << ts_max_len;

    return BmThreadTimer::BuildCsvFilenameString("@Ch16_05_ReplaceChar_bm", oss.str());
}

static void ReplaceChar_bm(size_t num_ts, size_t ts_min_len, size_t ts_max_len,
    char char_old, char char_new, std::string csv_fn)
{
    constexpr size_t num_alg = 2;
    constexpr size_t num_iter = BmThreadTimer::NumIterDef;
    BmThreadTimer bmtt(num_iter, num_alg);

    for (size_t i = 0; i < num_iter; i++)
    {
        StringGenerator sg;
        sg.GenerateStrings(num_ts, c_CharMin, c_CharMax, ts_min_len, ts_max_len);

        bmtt.Start(i, 0);
        for (size_t j = 0; j < num_ts; j++)
            ReplaceChar_cpp(sg.GetStringG1(j), char_old, char_new);
        bmtt.Stop(i, 0);

        bmtt.Start(i, 1);
        for (size_t j = 0; j < num_ts; j++)
            ReplaceChar_avx2(sg.GetStringG2(j), char_old, char_new);
        bmtt.Stop(i, 1);
    }

    bmtt.SaveElapsedTimes(csv_fn, BmThreadTimer::EtUnit::MicroSec, 2);
    std::cout << "Benchmark times saved to file " << csv_fn << "\n\n";
}

void ReplaceChar_bm(void)
{
    constexpr size_t len_step = 4;
    constexpr size_t num_tests = 20;

    size_t ts_min_len[num_tests];
    size_t ts_max_len[num_tests];

    for (size_t i = 0; i < num_tests; i++)
    {
        ts_min_len[i] = i * len_step;
        ts_max_len[i] = (i + 1) * len_step - 1;
//      printf("%4zu, %4zu\n", ts_min_len[i], ts_max_len[i]);
    }

    std::cout << "\nRunning benchmark function ReplaceChar_bm() - please wait\n";

    for (size_t i = 0; i < num_tests; i++)
    {
        std::string csv_fn = BuildCsvFilenameString(c_NumTestStringsBM, ts_min_len[i], ts_max_len[i]);

        ReplaceChar_bm(c_NumTestStringsBM, ts_min_len[i], ts_max_len[i], c_CharOld, c_CharNew, csv_fn);
    }

    std::cout << "Benchmark function ReplaceChar_bm() is complete\n";
}
