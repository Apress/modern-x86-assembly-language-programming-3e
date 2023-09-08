;------------------------------------------------------------------------------
; Ch09_04 fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; bool CalcMeanF64_avx(float* mean, const float* x, size_t n);
;------------------------------------------------------------------------------

NSE     equ 4                               ;number of SIMD elements per iteration

        section .text

        global CalcMeanF64_avx
CalcMeanF64_avx:

; Validate arguments
        cmp rdx,2                           ;is n >= 2?
        jb BadAr1                           ;jump if no
        test rsi,01fh                       ;is x 32b aligned?
        jnz BadAr1                          ;jump if no

; Initialize
        mov r9,rdx                          ;save copy of n
        vxorpd ymm5,ymm5,ymm5               ;packed (4 DPFP) sums = 0.0

        lea r10,[rsi-8]                     ;r10 = &x[i - 1] for Loop2
        cmp rdx,NSE                         ;is n >= NSE?
        jb Loop2                            ;jump if no (n >= 2 from first cmp)
        lea r10,[rsi-NSE*8]                 ;r10 = &x[i - NSE] for Loop1

; Calculate packed sums using SIMD addition
Loop1:  add r10,NSE*8                       ;r10 = &x[i]
        vaddpd ymm5,ymm5,[r10]              ;update packed sums
        sub rdx,NSE                         ;n -= NSE
        cmp rdx,NSE                         ;is n >= NSE?
        jae Loop1                           ;jump if yes

; Reduce packed sums to scalar value
        vextractf128 xmm1,ymm5,1            ;extract upper 2 packed sums
        vaddpd xmm2,xmm1,xmm5               ;xmm2 = 2 packed sums
        vhaddpd xmm5,xmm2,xmm2              ;xmm5[63:0] = scalar sum

        test rdx,rdx                        ;is n == 0?
        jz CalcMN                           ;jump if yes
        add r10,NSE*8-8                     ;r10 = &x[i - 1]

; Add remaining elements in x[] to sum
Loop2:  add r10,8                           ;r10 = &x[i]
        vaddsd xmm5,xmm5,[r10]              ;sum += x[i]
        sub rdx,1                           ;n -= 1
        jnz Loop2                           ;repeat until n == 0 is true

; Calculate mean
CalcMN: vcvtsi2sd xmm0,xmm0,r9              ;convert n to SPFP
        vdivsd xmm1,xmm5,xmm0               ;mean = sum / n
        vmovsd [rdi],xmm1                   ;save mean

        mov eax,1                           ;set success code
        vzeroupper                          ;clear upper YMM/ZMM bits
        ret

BadAr1: xor eax,eax                         ;set error return code
        ret

;------------------------------------------------------------------------------
; bool CalcStDevF64_avx(float* st_dev, const float* x, size_t n, float mean);
;------------------------------------------------------------------------------

        global CalcStDevF64_avx
CalcStDevF64_avx:

; Validate arguments
        cmp rdx,2                           ;is n >= 2?
        jb BadAr2                           ;jump if no
        test rsi,01fh                       ;is x 32b aligned?
        jnz BadAr2                          ;jump if no

; Initialize
        mov r9,rdx                          ;save copy of n
        vxorpd ymm5,ymm5,ymm5               ;packed (4 doubles) sums_sqs = 0.0

        vmovsd [rsp-8],xmm0                 ;save mean for broadcast
        vbroadcastsd ymm4,[rsp-8]           ;ymm4 = packed mean

        lea r10,[rsi-8]                     ;r10 = &x[i - 1] for Loop2
        cmp rdx,NSE                         ;is n >= NSE?
        jb Loop4                            ;jump if no (n >= 2 from first cmp)
        lea r10,[rsi-NSE*8]                 ;r10 = &x[i - NSE] for Loop1

; Calculate packed sums-of-squares using SIMD arithmetic
Loop3:  add r10,NSE*8                       ;r10 = &x[i]
        vmovapd ymm0,[r10]                  ;load elements x[i:i+7]
        vsubpd ymm1,ymm0,ymm4               ;ymm1 = packed x[i] - mean
        vmulpd ymm1,ymm1,ymm1               ;ymm1 = packed (x[i] - mean) ** 2
        vaddpd ymm5,ymm5,ymm1               ;update packed sum_sqs

        sub rdx,NSE                         ;n -= NSE
        cmp rdx,NSE                         ;n >= NSE?
        jae Loop3                           ;jump if yes

; Reduce packed sum_sqs to single value
        vextractf128 xmm1,ymm5,1            ;extract upper 2 packed sum_sqs
        vaddpd xmm2,xmm1,xmm5               ;xmm2 = 2 packed sum_sqs
        vhaddpd xmm5,xmm2,xmm2              ;xmm3[63:0] = sum_sqs

        test rdx,rdx                        ;is n >= 0?
        jz CalcSD                           ;jump if yes
        add r10,NSE*8-8                     ;r10 = &x[i - 1]

; Add remaining elements in x[] to sum_sqs
Loop4:  add r10,8                           ;r10 = &x[i]
        vmovsd xmm0,[r10]                   ;load x[i]
        vsubsd xmm1,xmm0,xmm4               ;xmm1 = x[i] - mean
        vmulsd xmm2,xmm1,xmm1               ;xmm2 = (x[i] - mean) ** 2
        vaddsd xmm5,xmm5,xmm2               ;update sum_sqs

        sub rdx,1                           ;n -= 1
        jnz Loop4                           ;repeat until n == 0 is true

; Calculate standard deviation
CalcSD: sub r9,1                            ;r9 = n - 1
        vcvtsi2sd xmm0,xmm0,r9              ;convert n - 1 to SPFP
        vdivsd xmm1,xmm5,xmm0               ;var = sum_sqs / (n - 1)
        vsqrtsd xmm2,xmm2,xmm1              ;sd = sqrt(var)
        vmovsd [rdi],xmm2                   ;save sd

        mov eax,1                           ;set success code
        vzeroupper                          ;clear upper YMM/ZMM bits
        ret

BadAr2: xor eax,eax                         ;set error return code
        ret
