;------------------------------------------------------------------------------
; Ch10_04_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

            section .rdata
F32_0p5     dd  0.5
F32_255p0   dd  255.0
I32_0xff    dd  0ffh

;------------------------------------------------------------------------------
; void ConvertRgbToGs_avx2(uint8_t* pb_gs, const RGB32* pb_rgb,
;   size_t num_pixels, const float coef[4]);
;------------------------------------------------------------------------------

NSE     equ 8                           ;num_simd_elements

        section .text

        global ConvertRgbToGs_avx2
ConvertRgbToGs_avx2:

; Validate argument values
        test rdx,rdx
        jz Done                             ;jump if num_pixels == 0
        test rdx,07h
        jnz Done                            ;jump if num_pixels not multiple of 8

        test rsi,1fh
        jnz Done                            ;jump if pb_gs not 32b aligned
        test rdi,1fh
        jnz Done                            ;jump if pb_rgb not 32b aligned

        vxorps xmm0,xmm0,xmm0               ;xmm0 = 0.0

        vmovss xmm13,[rcx]                  ;xmm13 = coef[0]
        vcomiss xmm13,xmm0
        jb Done                             ;jump if coef[0] < 0.0
        
        vmovss xmm14,[rcx+4]                ;xmm14 = coef[1]
        vcomiss xmm14,xmm0
        jb Done                             ;jump if coef[1] < 0.0

        vmovss xmm15,[rcx+8]                ;xmm15 = coef[2]
        vcomiss xmm15,xmm0
        jb  Done                            ;jump if coef[2] < 0.0

; Perform required initializations
        vbroadcastss ymm4,[F32_0p5]         ;packed 0.5
        vbroadcastss ymm5,[F32_255p0]       ;packed 255.0

        vpbroadcastd ymm12,[I32_0xff]        ;packed 0x000000ff

        vbroadcastss ymm13,xmm13            ;packed coef[0]
        vbroadcastss ymm14,xmm14            ;packed coef[1]
        vbroadcastss ymm15,xmm15            ;packed coef[2]

        mov rax,-NSE                        ;rax = common pixel buffer offset

; Convert pixels from RGB to gray scale
Loop1:  add rax,NSE                         ;update pixel buffer offset
        vmovdqa ymm0,[rsi+rax*4]            ;load next block of 8 RGB32 pixels

        vpand ymm1,ymm0,ymm12               ;ymm1 = r values (dwords)
        vpsrld ymm0,ymm0,8
        vpand ymm2,ymm0,ymm12               ;ymm2 = g values (dwords)
        vpsrld ymm0,ymm0,8
        vpand ymm3,ymm0,ymm12               ;ymm3 = b values (dwords)

        vcvtdq2ps ymm1,ymm1                 ;ymm1 = r values (F32)
        vcvtdq2ps ymm2,ymm2                 ;ymm2 = g values (F32)
        vcvtdq2ps ymm3,ymm3                 ;ymm3 = b values (F32)

        vmulps ymm1,ymm1,ymm13              ;ymm1 = r values * coef[0]
        vmulps ymm2,ymm2,ymm14              ;ymm2 = g values * coef[1]
        vmulps ymm3,ymm3,ymm15              ;ymm3 = b values * coef[2]

        vaddps ymm0,ymm1,ymm2               ;ymm0 = sum of r and g values
        vaddps ymm1,ymm3,ymm4               ;ymm1 = sum of b values and 0.5
        vaddps ymm0,ymm0,ymm1               ;ymm0 = sum of r, g, b, and 0.5

        vminps ymm1,ymm0,ymm5               ;clip grayscale values to 255.0

        vcvtps2dq ymm0,ymm1                 ;convert F32 values to dword
        vpackusdw ymm1,ymm0,ymm0            ;convert dwords to words
        vpermq ymm2,ymm1,10001000b          ;ymm2[127:0] = 8 grayscale words
        vpackuswb ymm3,ymm2,ymm2            ;ymm3[63:0] = 8 grayscale bytes

        vmovq [rdi+rax],xmm3                ;save pb_gs[i:i+7]

        sub rdx,NSE                         ;num_pixels -= NSE
        jnz Loop1                           ;jump if num_pixels != 0

Done:   vzeroupper
        ret
