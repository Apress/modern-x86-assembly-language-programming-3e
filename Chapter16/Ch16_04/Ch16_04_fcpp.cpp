//-----------------------------------------------------------------------------
// Ch16_04_fcpp.cpp
//-----------------------------------------------------------------------------

#include "Ch16_04.h"

bool VecCrossProducts_cpp(VecSOA* c, const VecSOA* a, const VecSOA* b)
{
    if (!CheckArgs(c, a, b))
        return false;

    for (size_t i = 0; i < c->NumVec; i++)
    {
        c->X[i] = a->Y[i] * b->Z[i] - a->Z[i] * b->Y[i];
        c->Y[i] = a->Z[i] * b->X[i] - a->X[i] * b->Z[i];
        c->Z[i] = a->X[i] * b->Y[i] - a->Y[i] * b->X[i];
    }

    return true;
}
