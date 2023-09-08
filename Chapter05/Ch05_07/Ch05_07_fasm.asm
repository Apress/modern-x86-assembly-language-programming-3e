;------------------------------------------------------------------------------
; Ch05_07_fasm.asm
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; bool CalcMeanF64_avx(double* mean, const double* x, size_t n);
;------------------------------------------------------------------------------

        .code
CalcMeanF64_avx proc

; Make sure n is valid
        cmp r8,1                            ;is n <= 1?
        jbe BadArg                          ;jump if yes

; Initialize
        sub rdx,8                           ;rdx = &x[-1]
        vxorpd xmm0,xmm0,xmm0               ;sum = 0.0
        vcvtsi2sd xmm1,xmm1,r8              ;convert n to DPFP

; Sum the elements of x[]
Loop1:  add rdx,8                           ;rdx = &x[i]
        vaddsd xmm0,xmm0,real8 ptr [rdx]    ;sum += x[i]
        sub r8,1                            ;n -= 1
        jnz Loop1                           ;repeat until n == 0

; Calculate and save the mean
        vdivsd xmm2,xmm0,xmm1               ;xmm2 = mean = sum / n
        vmovsd real8 ptr [rcx],xmm2         ;save mean

        mov eax,1                           ;set success return code
        ret

BadArg: xor eax,eax                         ;set error return code
        ret

CalcMeanF64_avx endp

;------------------------------------------------------------------------------
; bool CalcStDevF64_avx(double* st_dev, const double* x, size_t n, double mean);
;------------------------------------------------------------------------------

CalcStDevF64_avx proc

; Make sure n is valid
        cmp r8,1                            ;is n <= 1?
        jbe BadArg                          ;jump if yes

; Initialize
        sub rdx,8                           ;rdx = &x[-1]
        mov r9,r8                           ;r9 = n
        sub r9,1                            ;r9 = n - 1 (for SD calculation)
        vcvtsi2sd xmm4,xmm4,r9              ;convert n - 1 to DPFP
        vxorpd xmm0,xmm0,xmm0               ;sum_squares = 0.0

; Sum the elements of x
Loop2:  add rdx,8                           ;rdx = &x[i]
        vmovsd xmm1,real8 ptr [rdx]         ;xmm1 = x[i]
        vsubsd xmm2,xmm1,xmm3               ;xmm2 = x[i] - mean
        vmulsd xmm2,xmm2,xmm2               ;xmm2 = (x[i] - mean) ** 2
        vaddsd xmm0,xmm0,xmm2               ;sum_squares += (x[i] - mean) ** 2

        sub r8,1                            ;n -= 1
        jnz Loop2                           ;repeat until done

; Calculate and save standard deviation
        vdivsd xmm0,xmm0,xmm4               ;xmm0 = sum_squares / (n - 1)
        vsqrtsd xmm0,xmm0,xmm0              ;xmm0 = st_dev
        vmovsd real8 ptr [rcx],xmm0         ;save st_dev

        mov eax,1                           ;set success return code
        ret

BadArg: xor eax,eax                         ;set error return code
        ret

CalcStDevF64_avx endp
        end
