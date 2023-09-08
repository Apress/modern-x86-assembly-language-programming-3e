//-----------------------------------------------------------------------------
// Ch16_04_misc.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include <cstring>
#include <random>
#include "Ch16_04.h"
#include "AlignedMem.h"

void AllocateTestVectors(VecSOA* c1, VecSOA* c2, VecSOA* c3,
    VecSOA* a, VecSOA* b, size_t num_vec)
{
    // Allocate test vectors
    constexpr size_t align = c_Alignment;
    size_t size = num_vec * sizeof(double);

    c1->NumVec = num_vec;
    c1->X = (double*)AlignedMem::Allocate(size, align);
    c1->Y = (double*)AlignedMem::Allocate(size, align);
    c1->Z = (double*)AlignedMem::Allocate(size, align);

    c2->NumVec = num_vec;
    c2->X = (double*)AlignedMem::Allocate(size, align);
    c2->Y = (double*)AlignedMem::Allocate(size, align);
    c2->Z = (double*)AlignedMem::Allocate(size, align);

    c3->NumVec = num_vec;
    c3->X = (double*)AlignedMem::Allocate(size, align);
    c3->Y = (double*)AlignedMem::Allocate(size, align);
    c3->Z = (double*)AlignedMem::Allocate(size, align);

    a->NumVec = num_vec;
    a->X = (double*)AlignedMem::Allocate(size, align);
    a->Y = (double*)AlignedMem::Allocate(size, align);
    a->Z = (double*)AlignedMem::Allocate(size, align);

    b->NumVec = num_vec;
    b->X = (double*)AlignedMem::Allocate(size, align);
    b->Y = (double*)AlignedMem::Allocate(size, align);
    b->Z = (double*)AlignedMem::Allocate(size, align);

    // Initialize vector components with random values
    std::mt19937 rng {103};
    std::uniform_int_distribution<int> dist {1, 100};

    for (size_t i = 0; i < num_vec; i++)
    {
        a->X[i] = (double)dist(rng);
        a->Y[i] = (double)dist(rng);
        a->Z[i] = (double)dist(rng);

        b->X[i] = (double)dist(rng);
        b->Y[i] = (double)dist(rng);
        b->Z[i] = (double)dist(rng);
    }

    memset(c1->X, 0, size);
    memset(c1->Y, 0, size);
    memset(c1->Z, 0, size);

    memset(c2->X, 0, size);
    memset(c2->Y, 0, size);
    memset(c2->Z, 0, size);

    memset(c3->X, 0, size);
    memset(c3->Y, 0, size);
    memset(c3->Z, 0, size);
}

bool CheckArgs(const VecSOA* c, const VecSOA* a, const VecSOA* b)
{
    size_t nv_c = c->NumVec;
    size_t nv_a = a->NumVec;
    size_t nv_b = b->NumVec;
    constexpr size_t align = c_Alignment;

    // Validate vector sizes
    if (nv_c == 0 || nv_a == 0 || nv_b == 0)
        return false;
 
    if ((nv_c % 4) != 0 || (nv_a % 4) != 0 || (nv_b % 4) != 0)
        return false;

    if (nv_c != nv_a || nv_c != nv_b)
        return false;

    // Validate array alignments
    if (!AlignedMem::IsAligned(c->X, align))
        return false;
    if (!AlignedMem::IsAligned(c->Y, align))
        return false;
    if (!AlignedMem::IsAligned(c->Z, align))
        return false;

    if (!AlignedMem::IsAligned(a->X, align))
        return false;
    if (!AlignedMem::IsAligned(a->Y, align))
        return false;
    if (!AlignedMem::IsAligned(a->Z, align))
        return false;

    if (!AlignedMem::IsAligned(b->X, align))
        return false;
    if (!AlignedMem::IsAligned(b->Y, align))
        return false;
    if (!AlignedMem::IsAligned(b->Z, align))
        return false;

    return true;
}

void DisplayResults(VecSOA* c1, VecSOA* c2, VecSOA* c3, VecSOA* a,
    VecSOA* b)
{
    size_t num_vec = c1->NumVec;

    for (size_t i = 0; i < num_vec; i++)
    {
        constexpr int w = 9;
        std::cout << "Vector cross product #" << i << '\n';

        std::cout << "  a:   ";
        std::cout << std::setw(w) << a->X[i] << ' ';
        std::cout << std::setw(w) << a->Y[i] << ' ';
        std::cout << std::setw(w) << a->Z[i] << '\n';

        std::cout << "  b:   ";
        std::cout << std::setw(w) << b->X[i] << ' ';
        std::cout << std::setw(w) << b->Y[i] << ' ';
        std::cout << std::setw(w) << b->Z[i] << '\n';

        std::cout << "  c1:  ";
        std::cout << std::setw(w) << c1->X[i] << ' ';
        std::cout << std::setw(w) << c1->Y[i] << ' ';
        std::cout << std::setw(w) << c1->Z[i] << '\n';

        std::cout << "  c2:  ";
        std::cout << std::setw(w) << c2->X[i] << ' ';
        std::cout << std::setw(w) << c2->Y[i] << ' ';
        std::cout << std::setw(w) << c2->Z[i] << '\n';

        std::cout << "  c3:  ";
        std::cout << std::setw(w) << c3->X[i] << ' ';
        std::cout << std::setw(w) << c3->Y[i] << ' ';
        std::cout << std::setw(w) << c3->Z[i] << '\n';

        bool is_valid_x = c1->X[i] == c2->X[i] && c2->X[i] == c3->X[i];
        bool is_valid_y = c1->Y[i] == c2->Y[i] && c2->Y[i] == c3->Y[i];
        bool is_valid_z = c1->Z[i] == c2->Z[i] && c2->Z[i] == c3->Z[i];

        if (!is_valid_x || !is_valid_y || !is_valid_z)
        {
            std::cout << "Vector compare error at index " << i << '\n';
            std::cout << "is_valid_x: " << std::boolalpha << is_valid_x << '\n';
            std::cout << "is_valid_y: " << std::boolalpha << is_valid_y << '\n';
            std::cout << "is_valid_z: " << std::boolalpha << is_valid_z << '\n';
            return;
        }
    }
}

void ReleaseTestVectors(VecSOA* c1, VecSOA* c2, VecSOA* c3,
    VecSOA* a, VecSOA* b)
{
    AlignedMem::Release(c1->X);
    AlignedMem::Release(c1->Y);
    AlignedMem::Release(c1->Z);

    AlignedMem::Release(c2->X);
    AlignedMem::Release(c2->Y);
    AlignedMem::Release(c2->Z);

    AlignedMem::Release(c3->X);
    AlignedMem::Release(c3->Y);
    AlignedMem::Release(c3->Z);

    AlignedMem::Release(a->X);
    AlignedMem::Release(a->Y);
    AlignedMem::Release(a->Z);

    AlignedMem::Release(b->X);
    AlignedMem::Release(b->Y);
    AlignedMem::Release(b->Z);
}
