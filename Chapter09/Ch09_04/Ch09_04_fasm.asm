;------------------------------------------------------------------------------
; Ch09_04_fasm.asm
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; bool CalcMeanF64_avx(double* mean, const double* x, size_t n);
;------------------------------------------------------------------------------

NSE     equ 4                               ;number of SIMD elements per iteration

        .code
CalcMeanF64_avx proc

; Validate arguments
        cmp r8,2                            ;is n >= 2?
        jb BadArg                           ;jump if no
        test rdx,01fh                       ;is x 32b aligned?
        jnz BadArg                          ;jump if no

; Initialize
        mov r9,r8                           ;save copy of n
        vxorpd ymm5,ymm5,ymm5               ;packed (4 DPFP) sums = 0.0

        lea r10,[rdx-8]                     ;r10 = &x[i - 1] for Loop2
        cmp r8,NSE                          ;is n >= NSE?
        jb Loop2                            ;jump if no (n >= 2 from first cmp)
        lea r10,[rdx-NSE*8]                 ;r10 = &x[i - NSE] for Loop1

; Calculate packed sums using SIMD addition
Loop1:  add r10,NSE*8                       ;r10 = &x[i]
        vaddpd ymm5,ymm5,[r10]              ;update packed sums
        sub r8,NSE                          ;n -= NSE
        cmp r8,NSE                          ;is n >= NSE?
        jae Loop1                           ;jump if yes

; Reduce packed sums to scalar value
        vextractf128 xmm1,ymm5,1            ;extract upper 2 packed sums
        vaddpd xmm2,xmm1,xmm5               ;xmm2 = 2 packed sums
        vhaddpd xmm5,xmm2,xmm2              ;xmm5[63:0] = scalar sum

        test r8,r8                          ;is n == 0?
        jz CalcMN                           ;jump if yes
        add r10,NSE*8-8                     ;r10 = &x[i - 1]

; Add remaining elements in x[] to sum
Loop2:  add r10,8                           ;r10 = &x[i]
        vaddsd xmm5,xmm5,real8 ptr [r10]    ;sum += x[i]
        sub r8,1                            ;n -= 1
        jnz Loop2                           ;repeat until n == 0 is true

; Calculate mean
CalcMN: vcvtsi2sd xmm0,xmm0,r9              ;convert n to SPFP
        vdivsd xmm1,xmm5,xmm0               ;mean = sum / n
        vmovsd real8 ptr [rcx],xmm1         ;save mean

        mov eax,1                           ;set success code
        vzeroupper                          ;clear upper YMM/ZMM bits
        ret

BadArg: xor eax,eax                         ;set error return code
        ret

CalcMeanF64_avx endp

;------------------------------------------------------------------------------
; bool CalcStDevF64_avx(double* st_dev, const double* x, size_t n, double mean);
;------------------------------------------------------------------------------

CalcStDevF64_avx proc

; Validate arguments
        cmp r8,2                            ;is n >= 2?
        jb BadArg                           ;jump if no
        test rdx,01fh                       ;is x 32b aligned?
        jnz BadArg                          ;jump if no

; Initialize
        mov r9,r8                           ;save copy of n
        vxorpd ymm5,ymm5,ymm5               ;packed (4 doubles) sums_sqs = 0.0

        vmovsd real8 ptr [rsp+8],xmm3       ;save mean for broadcast
        vbroadcastsd ymm4,real8 ptr [rsp+8] ;ymm4 = packed mean

        lea r10,[rdx-8]                     ;r10 = &x[i - 1] for Loop2
        cmp r8,NSE                          ;is n >= NSE?
        jb Loop4                            ;jump if no (n >= 2 from first cmp)
        lea r10,[rdx-NSE*8]                 ;r10 = &x[i - NSE] for Loop1

; Calculate packed sums-of-squares using SIMD arithmetic
Loop3:  add r10,NSE*8                       ;r10 = &x[i]
        vmovapd ymm0,ymmword ptr [r10]      ;load elements x[i:i+7]
        vsubpd ymm1,ymm0,ymm4               ;ymm1 = packed x[i] - mean
        vmulpd ymm1,ymm1,ymm1               ;ymm1 = packed (x[i] - mean) ** 2
        vaddpd ymm5,ymm5,ymm1               ;update packed sum_sqs

        sub r8,NSE                          ;n -= NSE
        cmp r8,NSE                          ;n >= NSE?
        jae Loop3                           ;jump if yes

; Reduce packed sum_sqs to single value
        vextractf128 xmm1,ymm5,1            ;extract upper 2 packed sum_sqs
        vaddpd xmm2,xmm1,xmm5               ;xmm2 = 2 packed sum_sqs
        vhaddpd xmm5,xmm2,xmm2              ;xmm3[63:0] = sum_sqs

        test r8,r8                          ;is n >= 0?
        jz CalcSD                           ;jump if yes
        add r10,NSE*8-8                     ;r10 = &x[i - 1]

; Add remaining elements in x[] to sum_sqs
Loop4:  add r10,8                           ;r10 = &x[i]
        vmovsd xmm0,real8 ptr [r10]         ;load x[i]
        vsubsd xmm1,xmm0,xmm4               ;xmm1 = x[i] - mean
        vmulsd xmm2,xmm1,xmm1               ;xmm2 = (x[i] - mean) ** 2
        vaddsd xmm5,xmm5,xmm2               ;update sum_sqs

        sub r8,1                            ;n -= 1
        jnz Loop4                           ;repeat until n == 0 is true

; Calculate standard deviation
CalcSD: sub r9,1                            ;r9 = n - 1
        vcvtsi2sd xmm0,xmm0,r9              ;convert n - 1 to SPFP
        vdivsd xmm1,xmm5,xmm0               ;var = sum_sqs / (n - 1)
        vsqrtsd xmm2,xmm2,xmm1              ;sd = sqrt(var)
        vmovsd real8 ptr [rcx],xmm2         ;save sd

        mov eax,1                           ;set success code
        vzeroupper                          ;clear upper YMM/ZMM bits
        ret

BadArg: xor eax,eax                         ;set error return code
        ret

CalcStDevF64_avx endp
        end
