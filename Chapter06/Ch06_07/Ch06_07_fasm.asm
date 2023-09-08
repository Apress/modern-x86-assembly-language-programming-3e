;------------------------------------------------------------------------------
; Ch06_07_fasm.asm
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; bool CalcBSA_avx(const double* ht, const double* wt, int n,
;   double* bsa1, double* bsa2, double* bsa3, double* bsa_mean);
;------------------------------------------------------------------------------

; Constants required for BSA calculations 

                .const
f64_0p007184    real8 0.007184
f64_0p725       real8 0.725
f64_0p425       real8 0.425
f64_0p0235      real8 0.0235
f64_0p42246     real8 0.42246
f64_0p51456     real8 0.51456
f64_3600p0      real8 3600.0
f64_3p0         real8 3.0

; Offsets (relative to rbp) for local variables on stack
STK_N           equ -8
STK_BSA3        equ -16
STK_TEMP1_F64   equ -24
STK_TEMP2_F64   equ -32

STK_PAD         equ 8           ;extra pad bytes for rsp 16-byte alignment
STK_LOCAL       equ 32          ;stack storage space in bytes for local variables

; Offsets for stack arguments (includes home area size)
ARG_BSA2        equ 104     
ARG_BSA3        equ 112
ARG_BSA_MEAN    equ 120

        extern pow:proc

        .code
CalcBSA_avx proc

; Function prologue (POC code, does not conform to VC++ calling convention)
        push rsi                            ;save non-volatile GPRs
        push rdi
        push rbp                            
        push rbx
        push r12
        push r13
        push r14
        push r15

        mov rbp,rsp
        sub rsp,STK_LOCAL+STK_PAD           ;allocate local storage space

; Order args to match GC++ calling convention
; RDI  RSI  EDX  RCX   R8    R9
; ht   wt   n    bsa1  bsa2  bas3

        mov rdi,rcx                         ;rdi = ht
        mov rsi,rdx                         ;rsi = wt
        mov edx,r8d                         ;edx = n
        mov rcx,r9                          ;rcx = bsa1
        mov r8,[rbp+ARG_BSA2]               ;r8 = bsa2
        mov r9,[rbp+ARG_BSA3]               ;r9 = bsa3

; Perform required error checks and initializations. Note that
; most arguments are copied to non-volatile registers to preserve
; their values across function boundaries.
        test edx,edx                        ;is n <= 0?
        jle BadVal                          ;jump if yes
        mov [rbp+STK_N],edx                 ;save n on stack

        mov r12,rdi                         ;r12 = ht ptr
        mov r13,rsi                         ;r13 = wt ptr
        mov r14,rcx                         ;r14 = bsa1 ptr
        mov r15,r8                          ;r15 = bsa2 ptr
        mov [rbp+STK_BSA3],r9               ;save bsa3 on stack
        mov rbx,-8                          ;common array offset

        sub rsp,32                          ;home area for pow()

; Calculate bsa1 = 0.007184 * pow(ht, 0.725) * pow(wt, 0.425);
Loop1:  add rbx,8                                       ;update array offset
        vmovsd xmm0,real8 ptr [r12+rbx]                 ;xmm0 = ht
        vmovsd xmm1,real8 ptr [f64_0p725]               ;xmm1 = 0.754
        call pow                                        ;xmm0 = pow(ht, 0.725)
        vmovsd real8 ptr [rbp+STK_TEMP1_F64],xmm0       ;save intermediate result on stack

        vmovsd xmm0,real8 ptr [r13+rbx]                 ;xmm0 = wt
        vmovsd xmm1,real8 ptr [f64_0p425]               ;xmm1 = 0.425
        call pow                                        ;xmm0 = pow(wt, 0.425)

        vmulsd xmm1,xmm0,real8 ptr [rbp+STK_TEMP1_F64]  ;xmm1 = pow(ht, 0.725) * pow(wt, 0.425)
        vmulsd xmm2,xmm1,real8 ptr [f64_0p007184]       ;xmm2 = bsa1
        vmovsd real8 ptr [r14+rbx],xmm2                 ;save bsa1

; Calculate bsa2 = 0.0235 * pow(ht, 0.42246) * pow(wt, 0.51456);
        vmovsd xmm0,real8 ptr [r12+rbx]                 ;xmm0 = ht
        vmovsd xmm1,real8 ptr [f64_0p42246]             ;xmm1 = 0.42246
        call pow                                        ;xmm0 = pow(ht, 0.42246)
        vmovsd real8 ptr [rbp+STK_TEMP2_F64],xmm0       ;save intermediate result on stack

        vmovsd xmm0,real8 ptr [r13+rbx]                 ;xmm0 = wt
        vmovsd xmm1,real8 ptr [f64_0p51456]             ;xmm1 = 0.51456
        call pow                                        ;xmm0 = pow(wt, 0.51456)

        vmulsd xmm1,xmm0,real8 ptr [rbp+STK_TEMP2_F64]  ;xmm1 = pow(wt, 0.51456) * pow(ht, 0.42246)
        vmulsd xmm5,xmm1,real8 ptr [f64_0p0235]         ;xmm5 = bsa2
        vmovsd real8 ptr [r15+rbx],xmm5                 ;save bsa2

; Calculate bsa3 = sqrt(ht * wt / 3600.0);
        vmovsd xmm0,real8 ptr [r12+rbx]                 ;xmm0 = ht
        vmulsd xmm1,xmm0,real8 ptr [r13+rbx]            ;xmm1 = ht * wt
        vdivsd xmm2,xmm1,real8 ptr [f64_3600p0]         ;xmm2 = ht * wt / 3600
        vsqrtsd xmm3,xmm2,xmm2                          ;xmm3 = bsa3
        mov rax,[rbp+STK_BSA3]                          ;rax = bsa3 array pointer
        vmovsd real8 ptr [rax+rbx],xmm3                 ;save bsa3

; Calculate bsa_mean = (bsa1 + bsa2 + bsa3) / 3.0
        vaddsd xmm0,xmm3,real8 ptr [r14+rbx]            ;xmm0 = bsa3 + bsa1
        vaddsd xmm1,xmm0,xmm5                           ;xmm1 = bsa3 + bsa1 + bsa2
        vdivsd xmm2,xmm1,real8 ptr [f64_3p0]            ;xmm2 = (bsa3 + bsa1 + bsa2) / 3.0
        mov rax,[rbp+ARG_BSA_MEAN]                      ;rax = bsa_mean array pointer
        vmovsd real8 ptr [rax+rbx],xmm2                 ;save bsa mean

        sub dword ptr [rbp+STK_N],1                     ;n -= 1
        jnz Loop1                                       ;repeat loop until done

        mov eax,1                                       ;set success return code

; Function epilogue
Done:   mov rsp,rbp                                     ;release local storage and restore rsp
        pop r15                                         ;restore NV GPRs
        pop r14
        pop r13
        pop r12
        pop rbx
        pop rbp
        pop rdi
        pop rsi
        ret

BadVal: xor eax,eax                                     ;set error return code
        jmp Done

CalcBSA_avx endp
        end
