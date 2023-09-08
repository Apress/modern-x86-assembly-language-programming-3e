//-----------------------------------------------------------------------------
// Ch13_03_fcpp.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <stdexcept>
#include "Ch13_03.h"

void ComparePixels_cpp(uint8_t* des, const uint8_t* src, size_t num_pixels,
    CmpOp cmp_op, uint8_t cmp_val)
{
    if (!CheckArgs(des, src, num_pixels))
        throw std::runtime_error("ComparePixels_Cpp() - CheckArgs failed");

    constexpr uint8_t cmp_false = 0x00;
    constexpr uint8_t cmp_true = 0xff;

    switch (cmp_op)
    {
        case CmpOp::EQ:
            for (size_t i = 0; i < num_pixels; i++)
                des[i] = (src[i] == cmp_val) ? cmp_true : cmp_false;
            break;

        case CmpOp::NE:
            for (size_t i = 0; i < num_pixels; i++)
                des[i] = (src[i] != cmp_val) ? cmp_true : cmp_false;
            break;

        case CmpOp::LT:
            for (size_t i = 0; i < num_pixels; i++)
                des[i] = (src[i] < cmp_val) ? cmp_true : cmp_false;
            break;

        case CmpOp::LE:
            for (size_t i = 0; i < num_pixels; i++)
                des[i] = (src[i] <= cmp_val) ? cmp_true : cmp_false;
            break;

        case CmpOp::GT:
            for (size_t i = 0; i < num_pixels; i++)
                des[i] = (src[i] > cmp_val) ? cmp_true : cmp_false;
            break;

        case CmpOp::GE:
            for (size_t i = 0; i < num_pixels; i++)
                des[i] = (src[i] >= cmp_val) ? cmp_true : cmp_false;
            break;

        default:
            throw std::runtime_error("ComparePixels_cpp() - invalid cmp_op");
    }
}
