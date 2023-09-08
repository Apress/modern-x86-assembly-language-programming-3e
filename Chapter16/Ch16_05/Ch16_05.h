//-----------------------------------------------------------------------------
// Ch16_05.h
//-----------------------------------------------------------------------------

#pragma once
#include <cstddef>

// Ch16_05_fasm.asm, Ch16_05_fasm.s
extern "C" size_t ReplaceChar_avx2(char* s, char char_old, char char_new);

// Ch16_05_fcpp.cpp
extern size_t ReplaceChar_cpp(char* s, char char_old, char char_new);

// Ch16_05_bm.cpp
extern void ReplaceChar_bm(void);

// Ch16_05_test.cpp
extern void TestStringGenerator(void);

// Miscellaneous constants
constexpr char c_CharMin = 'A';             // min char for test strings
constexpr char c_CharMax = 'K';             // max char for test strings
constexpr char c_CharOld = 'D';             // character to replace
constexpr char c_CharNew = '-';             // replacement character

constexpr size_t c_MinLen = 0;              // min test string len - ReplaceChar()
constexpr size_t c_MaxLen = 67;             // max test string len - ReplaceChar()
constexpr size_t c_NumTestStrings = 500;    // num test strings - ReplaceChar()
constexpr size_t c_NumTestStringsBM = 50000;// num test strings - ReplaceChar_bm()
