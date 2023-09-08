//-----------------------------------------------------------------------------
// Ch06_02.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstdint>

// Ch06_02_fasm.asm
extern "C" void CalcSumProd_avx(const int64_t* a, const int64_t* b, int32_t n,
    int64_t* sum_a, int64_t* sum_b, int64_t* prod_a, int64_t* prod_b);
