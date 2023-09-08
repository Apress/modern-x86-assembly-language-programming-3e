//------------------------------------------------
//               ZmmVal.h
//------------------------------------------------

#pragma once
#include <string>
#include <cstdint>
#include <sstream>
#include <iomanip>

struct  alignas(64) ZmmVal
{
public:
    union
    {
        int8_t m_I8[64];
        int16_t m_I16[32];
        int32_t m_I32[16];
        int64_t m_I64[8];
        uint8_t m_U8[64];
        uint16_t m_U16[32];
        uint32_t m_U32[16];
        uint64_t m_U64[8];
        float m_F32[16];
        double m_F64[8];
    };

// ...

private:
    template <typename T> std::string ToStringInt(const T* x, size_t n, size_t w, size_t select)
    {
        std::ostringstream oss;

        size_t n4 = n / 4;
        size_t offset = (select % 4) ? select * n / 4 : 0;

        for (size_t i = 0; i < n4; i++)
        {
            oss << std::setw((int)w) << (int64_t)x[i + offset];

            if (i + 1 == n4 / 2)
                oss << "   |";
        }

        return oss.str();
    }

    template <typename T> std::string ToStringUint(const T* x, size_t n, size_t w, size_t select)
    {
        std::ostringstream oss;

        size_t n4 = n / 4;
        size_t offset = (select % 4) ? select * n / 4 : 0;

        for (size_t i = 0; i < n4; i++)
        {
            oss << std::setw((int)w) << (uint64_t)x[i + offset];

            if (i + 1 == n4 / 2)
                oss << "   |";
        }

        return oss.str();
    }

    template <typename T> std::string ToStringHex(const T* x, size_t n, size_t w, size_t select)
    {
        std::ostringstream oss;

        size_t n4 = n / 4;
        size_t offset = (select % 4) ? select * n / 4 : 0;

        for (size_t i = 0; i < n4; i++)
        {
            const int w_temp = 16;
            std::ostringstream oss_temp;

            oss_temp << std::uppercase << std::hex << std::setfill('0');
            oss_temp << std::setw(w_temp) << (uint64_t)x[i + offset];
            std::string s1 = oss_temp.str();
            std::string s2 = s1.substr(w_temp - sizeof(T) * 2);

            oss << std::setw((int)w) << s2;

            if (i + 1 == n4 / 2)
                oss << "   |";
        }

        return oss.str();
    }

    template <typename T> std::string ToStringFP(const T* x, size_t n, size_t w, int p, size_t select)
    {
        std::ostringstream oss;

        size_t n4 = n / 4;
        size_t offset = (select % 4) ? select * n / 4  : 0;

        oss << std::fixed << std::setprecision(p);

        for (size_t i = 0; i < n4; i++)
        {
            oss << std::setw((int)w) << x[i + offset];

            if (i + 1 == n4 / 2)
                oss << "   |";
        }

        return oss.str();
    }

public:

    //
    // Signed integer
    //
      
    std::string ToStringI8(size_t select)
    {
        return ToStringInt(m_I8, sizeof(m_I8) / sizeof(int8_t), 4, select);
    }

    std::string ToStringI16(size_t select)
    {
        return ToStringInt(m_I16, sizeof(m_I16) / sizeof(int16_t), 8, select);
    }

    std::string ToStringI32(size_t select)
    {
        return ToStringInt(m_I32, sizeof(m_I32) / sizeof(int32_t), 16, select);
    }

    std::string ToStringI64(size_t select)
    {
        return ToStringInt(m_I64, sizeof(m_I64) / sizeof(int64_t), 32, select);
    }

    //
    // Unsigned integer
    //

    std::string ToStringU8(size_t select)
    {
        return ToStringUint(m_U8, sizeof(m_U8) / sizeof(uint8_t), 4, select);
    }

    std::string ToStringU16(size_t select)
    {
        return ToStringUint(m_U16, sizeof(m_U16) / sizeof(uint16_t), 8, select);
    }

    std::string ToStringU32(size_t select)
    {
        return ToStringUint(m_U32, sizeof(m_U32) / sizeof(uint32_t), 16, select);
    }

    std::string ToStringU64(size_t select)
    {
        return ToStringUint(m_U64, sizeof(m_U64) / sizeof(uint64_t), 32, select);
    }

    //
    // Hexadecimal
    //

    std::string ToStringX8(size_t select)
    {
        return ToStringHex(m_U8, sizeof(m_U8) / sizeof(uint8_t), 4, select);
    }

    std::string ToStringX16(size_t select)
    {
        return ToStringHex(m_U16, sizeof(m_U16) / sizeof(uint16_t), 8, select);
    }

    std::string ToStringX32(size_t select)
    {
        return ToStringHex(m_U32, sizeof(m_U32) / sizeof(uint32_t), 16, select);
    }

    std::string ToStringX64(size_t select)
    {
        return ToStringHex(m_U64, sizeof(m_U64) / sizeof(uint64_t), 32, select);
    }

    //
    // Floating point
    //

    std::string ToStringF32(size_t select)
    {
        return ToStringFP(m_F32, sizeof(m_F32) / sizeof(float), 16, 6, select);
    }

    std::string ToStringF32(size_t select, size_t w, int p)
    {
        return ToStringFP(m_F32, sizeof(m_F32) / sizeof(float), w, p, select);
    }

    std::string ToStringF64(size_t select)
    {
        return ToStringFP(m_F64, sizeof(m_F64) / sizeof(double), 32, 12, select);
    }

    std::string ToStringF64(size_t select, size_t w, int p)
    {
        return ToStringFP(m_F64, sizeof(m_F64) / sizeof(double), w, p, select);
    }
};
