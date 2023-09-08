//-----------------------------------------------------------------------------
// Ch09_03.h
//-----------------------------------------------------------------------------

#pragma once
#include "XmmVal.h"

// The order of values in the following enum must match the jump
// tables defined in the assembly langage files.

enum CvtOp : unsigned int
{
    I32_F32, F32_I32, I32_F64, F64_I32, F32_F64, F64_F32,
};

// Ch09_03_fasm.asm, Ch09_03_fasm.s
extern "C" bool PackedConvertFP_avx(const XmmVal& a, XmmVal& b, CvtOp cvt_op);
