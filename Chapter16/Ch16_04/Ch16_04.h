//-----------------------------------------------------------------------------
// Ch16_04.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>

// VecSOA structure. This structure must match the structures that
// are defined in the assembly language files.
struct VecSOA
{
    size_t NumVec = 0;          // number of vectors (must be even multiple of 4)
    double* X = nullptr;        // vector X components
    double* Y = nullptr;        // vector Y components
    double* Z = nullptr;        // vector Z components
};

// Ch16_04_fasm.asm, Ch16_04_fasm.s
extern "C" bool VecCrossProducts_avx2(VecSOA* c, const VecSOA* a,
    const VecSOA* b);

// Ch16_04_fasm2.asm, Ch16_04_fasm2.s
extern "C" bool VecCrossProductsNT_avx2(VecSOA* c, const VecSOA* a,
    const VecSOA* b);

// Ch16_04_fcpp.cpp
extern bool VecCrossProducts_cpp(VecSOA* c, const VecSOA* a, const VecSOA* b);

// Ch16_04_misc.cpp
extern void AllocateTestVectors(VecSOA* c1, VecSOA* c2, VecSOA* c3,
    VecSOA* a, VecSOA* b, size_t num_vec);
extern "C" bool CheckArgs(const VecSOA * c, const VecSOA * a, const VecSOA * b);
extern void DisplayResults(VecSOA* c1, VecSOA* c2, VecSOA* c3, VecSOA* a,
    VecSOA* b);
extern void ReleaseTestVectors(VecSOA* c1, VecSOA* c2, VecSOA* c3,
    VecSOA* a, VecSOA* b);

// Ch16_04_bm.cpp
extern void VecCrossProducts_bm(void);

// Miscellaneous constants
constexpr size_t c_Alignment = 32;
constexpr size_t c_NumVec = 16;
constexpr size_t c_NumVecBM = 2000000;
