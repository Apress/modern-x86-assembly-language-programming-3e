//-----------------------------------------------------------------------------
// Ch04_04.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>
#include <cstdint>

// Ch04_04_fasm.asm, Ch04_04_fasm.s
extern "C" size_t CountChars_a(const char* s, char c);

// Ch04_04_fcpp.cpp
extern size_t CountChars_cpp(const char* s, char c);

// Ch04_04_misc.cpp
extern void DisplayResults(char sea_char, size_t n1, size_t n2);
