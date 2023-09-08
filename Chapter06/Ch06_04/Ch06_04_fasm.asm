;------------------------------------------------------------------------------
; Ch06_04_fasm.asm
;------------------------------------------------------------------------------

        include <MacrosX86-64-AVX.asmh>

;------------------------------------------------------------------------------
; bool CalcBSA_avx(const double* ht, const double* wt, int n,
;   double* bsa1, double* bsa2, double* bsa3, double* bsa_mean);
;------------------------------------------------------------------------------

; Constants required for BSA calculations

               .const
F64_0p007184    real8 0.007184
F64_0p725       real8 0.725
F64_0p425       real8 0.425
F64_0p0235      real8 0.0235
F64_0p42246     real8 0.42246
F64_0p51456     real8 0.51456
F64_3600p0      real8 3600.0
F64_3p0         real8 3.0

        .code
        extern pow:proc

CalcBSA_avx proc frame
        CreateFrame_M BSA_,16,64,rbx,rsi,rdi,r12,r13,r14,r15
        SaveXmmRegs_M xmm6,xmm7,xmm8,xmm9
        EndProlog_M

; Save argument registers to home area (optional). Note that the home
; area can also be used to store other transient data values.
        mov [rbp+BSA_OffsetHomeRCX],rcx
        mov [rbp+BSA_OffsetHomeRDX],rdx
        mov [rbp+BSA_OffsetHomeR8],r8
        mov [rbp+BSA_OffsetHomeR9],r9

; Perform required initializations and error checks. Note that the
; various array pointers are maintained in non-volatile registers, which
; eliminates the need to perform reloads after the calls to pow().
        test r8d,r8d                            ;is n <= 0?
        jle BadVal                              ;jump if yes

        mov [rbp],r8d                           ;save n to local var
        mov r12,rcx                             ;r12 = ptr to ht
        mov r13,rdx                             ;r13 = ptr to wt
        mov r14,r9                              ;r14 = ptr to bsa1
        mov r15,[rbp+BSA_OffsetStackArgs]       ;r15 = ptr to bsa2
        mov rbx,[rbp+BSA_OffsetStackArgs+8]     ;rbx = ptr to bsa3
        mov rdi,[rbp+BSA_OffsetStackArgs+16]    ;rdi = ptr to bsa_mean
        mov rsi,-8                              ;common array offset

; Allocate home space on stack for use by pow()
        sub rsp,32

; Calculate bsa1 = 0.007184 * pow(ht, 0.725) * pow(wt, 0.425);
@@:     add rsi,8                                   ;update array offset
        vmovsd xmm0,real8 ptr [r12+rsi]             ;xmm0 = ht
        vmovsd xmm8,xmm8,xmm0
        vmovsd xmm1,real8 ptr [F64_0p725]
        call pow                                    ;xmm0 = pow(ht, 0.725)
        vmovsd xmm6,xmm6,xmm0

        vmovsd xmm0,real8 ptr [r13+rsi]             ;xmm0 = wt
        vmovsd xmm9,xmm9,xmm0
        vmovsd xmm1,real8 ptr [F64_0p425]
        call pow                                    ;xmm0 = pow(wt, 0.425)
        vmulsd xmm6,xmm6,real8 ptr [F64_0p007184]
        vmulsd xmm6,xmm6,xmm0                       ;xmm6 = bsa1

; Calculate bsa2 = 0.0235 * pow(ht, 0.42246) * pow(wt, 0.51456);
        vmovsd xmm0,xmm0,xmm8                       ;xmm0 = ht
        vmovsd xmm1,real8 ptr [F64_0p42246]
        call pow                                    ;xmm0 = pow(ht, 0.42246)
        vmovsd xmm7,xmm7,xmm0

        vmovsd xmm0,xmm0,xmm9                       ;xmm0 = wt
        vmovsd xmm1,real8 ptr [F64_0p51456]
        call pow                                    ;xmm0 = pow(wt, 0.51456)
        vmulsd xmm7,xmm7,real8 ptr [F64_0p0235]
        vmulsd xmm7,xmm7,xmm0                       ;xmm7 = bsa2

; Calculate bsa3 = sqrt(ht * wt / 3600.0);
        vmulsd xmm8,xmm8,xmm9                   ;xmm8 = ht * wt
        vdivsd xmm8,xmm8,real8 ptr [F64_3600p0] ;xmm8 = ht * wt / 3600
        vsqrtsd xmm8,xmm8,xmm8                  ;xmm8 = bsa3

; Calculate bsa_mean = (bas1 + bas2 + bas3) / 3.0
        vaddsd xmm0,xmm6,xmm7                 ;xmm0 = bsa1 + bsa2
        vaddsd xmm1,xmm0,xmm8                 ;xmm1 = bsa1 + bsa2 + bsa3
        vdivsd xmm2,xmm1,real8 ptr [F64_3p0]  ;xmm2 = (bsa3 + bsa1 + bsa2) / 3.0

; Save BSA results
        vmovsd real8 ptr [r14+rsi],xmm6         ;save bsa1
        vmovsd real8 ptr [r15+rsi],xmm7         ;save bsa2
        vmovsd real8 ptr [rbx+rsi],xmm8         ;save bsa3
        vmovsd real8 ptr [rdi+rsi],xmm2         ;save bsa_mean

        sub dword ptr [rbp],1                   ;n -= 1
        jnz @B

        mov eax,1                               ;set success return code

Done:   RestoreXmmRegs_M xmm6,xmm7,xmm8,xmm9
        DeleteFrame_M rbx,rsi,rdi,r12,r13,r14,r15
        ret

BadVal: xor eax,eax                             ;set error return code
        jmp Done

CalcBSA_avx endp
        end
