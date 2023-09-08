//-----------------------------------------------------------------------------
// BmThreadTimer.h
//-----------------------------------------------------------------------------

#pragma once
#include <iomanip>
#include <fstream>
#include <chrono>
#include <stdexcept>
#include <string>
#include <algorithm>
#include <cstdlib>
#include <cmath>
#include <vector>
#include "MF.h"
#include "OS.h"

class BmThreadTimer
{
    static constexpr bool c_UseDT = true;   // Append datetime to output filenames

    size_t m_NumIter;
    size_t m_NumAlg;
    std::vector<std::chrono::high_resolution_clock::time_point> m_StartTime;
    std::vector<std::chrono::high_resolution_clock::time_point> m_StopTime;

    void CalcStats(std::vector<double>& x, double* mean, double* sd, double* min, double* max, double* sem)
    {
        // Calculate min and max
        *min = *std::min_element(x.begin(), x.end());
        *max = *std::max_element(x.begin(), x.end());

        // Calculate mean
        double sum = 0.0;
        size_t n = x.size();

        for (size_t i = 0; i < n; i++)
            sum += x[i];
        *mean = sum / n;

        // Calculate SD
        double sum_sqs = 0.0;

        for (size_t i = 0; i < n; i++)
        {
            double temp = x[i] - *mean;
            sum_sqs += temp * temp;
        }

        *sd = sqrt(sum_sqs / (n - 1));

        // Calculate SEM
        *sem = *sd / sqrt(n);
    }

    void SaveStats(const std::string& fn, int p, std::vector<double>& et_counts, double tm_exclude)
    {
        if (tm_exclude < 0.0 || tm_exclude >= 1.0)
            throw std::runtime_error("BmThreadTimer::SaveStats() - invalid tm_exclude");

        std::vector<double> et_mean_vals(m_NumAlg, 0.0);
        std::vector<double> et_sd_vals(m_NumAlg, 0.0);
        std::vector<double> et_min_vals(m_NumAlg, 0.0);
        std::vector<double> et_max_vals(m_NumAlg, 0.0);
        std::vector<double> et_sem_vals(m_NumAlg, 0.0);

        size_t num_et_vals2 = 0;

        for (size_t i = 0; i < m_NumAlg; i++)
        {
            // Copy values for alg i
            std::vector<double> et_vals(m_NumIter);

            for (size_t j = 0; j < m_NumIter; j++)
                et_vals[j] = et_counts[j * m_NumAlg + i];   // Note transposed subscripts

            // Trim low and high outliers
            std::sort(et_vals.begin(), et_vals.end());
            size_t tm_start = (size_t)(m_NumIter * tm_exclude / 2.0);
            size_t tm_end = m_NumIter - tm_start;

            num_et_vals2 = tm_end - tm_start;

            std::vector<double> et_vals2(num_et_vals2);

            for (size_t j = 0; j < num_et_vals2; j++)
                et_vals2[j] = et_vals[j + tm_start];

            // Calc stats
            CalcStats(et_vals2, &et_mean_vals[i], &et_sd_vals[i], &et_min_vals[i], &et_max_vals[i], &et_sem_vals[i]);
        }

        // Save results to specified output file
        std::string fn_stats(fn);
        fn_stats += ".stats.txt";

        std::ofstream ofs(fn_stats);

        constexpr char nl = '\n';
        static const char* c = ", ";

        if (ofs.is_open())
        {
            ofs << std::fixed << std::setprecision(p);

            ofs << "original n: " << m_NumIter << nl;
            ofs << "tm_exclude: " << tm_exclude << nl;
            ofs << "trimmean n: " << num_et_vals2 << nl;
            ofs << "AlgId,TrimMean,TrimSD,TrimMin,TrimMax,TrimSEM" << nl;

            for (size_t i = 0; i < m_NumAlg; i++)
            {
                ofs << i << c;
                ofs << et_mean_vals[i] << c;
                ofs << et_sd_vals[i] << c;
                ofs << et_min_vals[i] << c;
                ofs << et_max_vals[i] << c;
                ofs << et_sem_vals[i] << nl;
            }

            ofs.close();
        }
        else
            throw std::runtime_error("BmThreadTimer::SaveStats() - File open error");
    }

public:
    static constexpr size_t NumIterDef = 1000;

    enum class EtUnit
    {
        NanoSec,
        MicroSec,
        MilliSec,
        Sec
    };

    BmThreadTimer(void) = delete;
    
    BmThreadTimer(size_t num_iter, size_t num_alg)
    {
        m_NumIter = num_iter;
        m_NumAlg = num_alg;

        std::vector<std::chrono::high_resolution_clock::time_point> start_time(num_iter * num_alg);
        std::vector<std::chrono::high_resolution_clock::time_point> stop_time(num_iter * num_alg);
        m_StartTime = std::move(start_time);
        m_StopTime = std::move(stop_time);
    }

    ~BmThreadTimer()
    {
    }

    BmThreadTimer(const BmThreadTimer& bmtt) = delete;
    BmThreadTimer(BmThreadTimer&& bmtt) = delete;
    BmThreadTimer& operator = (const BmThreadTimer& bmtt) = delete;
    BmThreadTimer& operator = (BmThreadTimer&& bmtt) = delete;

    static std::string BuildCsvFilenameString(const std::string& prefix, const std::string& base_name1,
        const std::string& base_name2, bool use_dt = c_UseDT)
    {
        std::string fn = prefix + base_name1;
        std::string computer_name = OS::GetComputerName();

        if (base_name2 != "")
        {
            fn += '_';
            fn += base_name2;
        }

        if (computer_name != "")
        {
            fn += '_';
            fn += computer_name;
        }

        if (use_dt)
        {
            fn += '_';
            fn += MF::GetFnDT();
        }

        fn += ".csv";
        return fn;
    }

    static std::string BuildCsvFilenameString(const std::string& base_name1)
    {
        return BmThreadTimer::BuildCsvFilenameString("", base_name1, "");
    }

    static std::string BuildCsvFilenameString(const std::string& base_name1, const std::string& base_name2)
    {
        return BmThreadTimer::BuildCsvFilenameString("", base_name1, base_name2);
    }

    void SaveElapsedTimes(const std::string& fn, EtUnit et_unit, int p, bool save_stats = true, double tm_exclude = 0.05)
    {
        std::ofstream ofs(fn);

        if (ofs.is_open())
        {
            std::vector<double> et_counts(m_NumIter * m_NumAlg, 0.0);

            ofs << std::fixed << std::setprecision(p);

            for (size_t i = 0; i < m_NumIter; i++)
            {
                for (size_t j = 0; j < m_NumAlg; j++)
                {
                    std::chrono::high_resolution_clock::time_point t_start = m_StartTime[i * m_NumAlg + j];
                    std::chrono::high_resolution_clock::time_point t_stop = m_StopTime[i * m_NumAlg + j];
                    std::chrono::duration<double> et = std::chrono::duration_cast<std::chrono::duration<double>>(t_stop - t_start);

                    switch (et_unit)
                    {
                        case EtUnit::NanoSec:
                            et *= 1.0e9;
                            break;
    
                        case EtUnit::MicroSec:
                            et *= 1.0e6;
                            break;

                        case EtUnit::MilliSec:
                            et *= 1.0e3;
                            break;

                        case EtUnit::Sec:
                            break;

                        default:
                            throw std::runtime_error("BmThreadTimer::SaveElapsedTimes() - Invalid EtUint");
                    }

                    et_counts[i * m_NumAlg + j] = et.count();

                    ofs << et.count();

                    if (j + 1 < m_NumAlg)
                        ofs << ", ";
                    else
                        ofs << '\n';
                }
            }

            ofs.close();

            if (save_stats)
                SaveStats(fn, p, et_counts, tm_exclude);
        }
        else
            throw std::runtime_error("BmThreadTimer::SaveElapsedTimes() - File open error");
    }

    void Start(size_t iter_id, size_t alg_id)
    {
        m_StartTime[iter_id * m_NumAlg + alg_id] = std::chrono::high_resolution_clock::now();
    }

    void Stop(size_t iter_id, size_t alg_id)
    {
        m_StopTime[iter_id * m_NumAlg + alg_id] = std::chrono::high_resolution_clock::now();
    }
};
