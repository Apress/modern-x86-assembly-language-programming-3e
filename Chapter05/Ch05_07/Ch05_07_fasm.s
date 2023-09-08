;------------------------------------------------------------------------------
; Ch05_07_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; bool CalcMeanF64_avx(double* mean, const double* x, size_t n);
;------------------------------------------------------------------------------

        section .text

        global CalcMeanF64_avx
CalcMeanF64_avx:

; Make sure n is valid
        cmp rdx,1                           ;is n <= 1?
        jbe BadAr1                          ;jump if yes

; Initialize
        sub rsi,8                           ;rsi = &x[-1]
        vxorpd xmm0,xmm0,xmm0               ;sum = 0.0
        vcvtsi2sd xmm1,xmm1,rdx             ;convert n to DPFP

; Sum the elements of x
Loop1:  add rsi,8                           ;rsi = &x[i]
        vaddsd xmm0,xmm0,[rsi]              ;sum += x[i]
        sub rdx,1                           ;n -= 1
        jnz Loop1                           ;repeat until n == 0

; Calculate and save the mean
        vdivsd xmm1,xmm0,xmm1               ;xmm2 = mean = sum / n
        vmovsd [rdi],xmm1                   ;save mean

        mov eax,1                           ;set success return code
        ret

BadAr1: xor eax,eax                         ;set error return code
        ret

;------------------------------------------------------------------------------
; bool CalcStDevF64_avx(double* st_dev, const double* x, size_t n, double mean);
;------------------------------------------------------------------------------

        global CalcStDevF64_avx
CalcStDevF64_avx:

; Make sure n is valid
        cmp rdx,1                           ;is n <= 1?
        jbe BadAr2                          ;jump if yes

; Initialize
        sub rsi,8                           ;rsi = &x[-1]
        mov r9,rdx                          ;r9 = n
        sub r9,1                            ;r9 = n - 1 (for SD calculation)
        vcvtsi2sd xmm4,xmm4,r9              ;convert n - 1 to DPFP
        vmovsd xmm3,xmm0,xmm0               ;xmm3 = mean
        vxorpd xmm0,xmm0,xmm0               ;sum_squares = 0.0

; Sum the elements of x
Loop2:  add rsi,8                           ;rsi = &x[i]
        vmovsd xmm1,[rsi]                   ;xmm1 = x[i]
        vsubsd xmm2,xmm1,xmm3               ;xmm2 = x[i] - mean
        vmulsd xmm2,xmm2,xmm2               ;xmm2 = (x[i] - mean) ** 2
        vaddsd xmm0,xmm0,xmm2               ;sum_squares += (x[i] - mean) ** 2

        sub rdx,1                           ;n -= 1
        jnz Loop2                           ;repeat until done

; Calculate and save standard deviation
        vdivsd xmm0,xmm0,xmm4               ;xmm0 = sum_squares / (n - 1)
        vsqrtsd xmm0,xmm0,xmm0              ;xmm0 = st_dev
        vmovsd [rdi],xmm0                   ;save st_dev

        mov eax,1                           ;set success return code
        ret

BadAr2: xor eax,eax                         ;set error return code
        ret
