//-----------------------------------------------------------------------------
// Ch06_03.cpp
//-----------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include "Ch06_03.h"

int main()
{
    constexpr int n = 7;
    constexpr double r[n] = { 1.0, 1.0, 2.0, 2.0, 3.0, 3.0, 4.25 };
    constexpr double h[n] = { 1.0, 2.0, 3.0, 4.0, 5.0, 10.0, 12.5 };
    double sa_cone1[n], sa_cone2[n], vol_cone1[n], vol_cone2[n];

    CalcConeAreaVol_cpp(r, h, n, sa_cone1, vol_cone1);
    CalcConeAreaVol_avx(r, h, n, sa_cone2, vol_cone2);

    std::cout << "----- Results for Ch06_03 -----\n";
    std::cout << std::fixed;

    constexpr int w = 14;
    constexpr char nl = '\n';
    constexpr char sp = ' ';

    for (int i = 0; i < n; i++)
    {
        std::cout << std::setprecision(2);
        std::cout << "r/h: " << std::setw(w) << r[i] << sp;
        std::cout << std::setw(w) << h[i] << nl;

        std::cout << std::setprecision(6);
        std::cout << "sa:  " << std::setw(w) << sa_cone1[i] << sp;
        std::cout << std::setw(w) << sa_cone2[i] << nl;

        std::cout << "vol: " << std::setw(w) << vol_cone1[i] << sp;
        std::cout << std::setw(w) << vol_cone2[i] << nl;
        std::cout << nl;
    }

    return 0;
}
