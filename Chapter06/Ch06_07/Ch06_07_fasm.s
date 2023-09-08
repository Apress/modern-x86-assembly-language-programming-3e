;------------------------------------------------------------------------------
; Ch06_07_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

                section .rdata
F64_0p007184    dq 0.007184
F64_0p725       dq 0.725
F64_0p425       dq 0.425
F64_0p0235      dq 0.0235
F64_0p42246     dq 0.42246
F64_0p51456     dq 0.51456
F64_3600p0      dq 3600.0
F64_3p0         dq 3.0

;------------------------------------------------------------------------------
; bool CalcBSA_avx(const double* ht, const double* wt, int n,
;   double* bsa1, double* bsa2, double* bsa3, double* bsa_mean);
;------------------------------------------------------------------------------

; Offsets (relative to rsp) for stack local variables
STK_BSA3        equ 16
STK_TEMP1_F64   equ 8
STK_TEMP2_F64   equ 0

STK_LOCAL       equ 24          ;stack storage space in bytes for local variables
STK_PAD         equ 0           ;extra pad bytes for rsp 16-byte alignment

; Offsets for stack arguments
ARG_BSA_MEAN    equ 80

        section .text
        extern pow

        global CalcBSA_avx
CalcBSA_avx:
; Function prologue
        push rbp                            ;save non-volatile GPRs
        push rbx
        push r12
        push r13
        push r14
        push r15

        sub rsp,STK_LOCAL+STK_PAD           ;allocate local storage space

; Perform required error checks and initializations. Note that
; most arguments are copied to non-volatile registers to preserve
; their values across function boundaries.
        test edx,edx                        ;is n <= 0?
        jle BadVal                          ;jump if yes

        mov ebp,edx                         ;ebp = n
        mov r12,rdi                         ;r12 = ht ptr
        mov r13,rsi                         ;r13 = wt ptr
        mov r14,rcx                         ;r14 = bsa1 ptr
        mov r15,r8                          ;r15 = bsa2 ptr
        mov [rsp+STK_BSA3],r9               ;save bsa3 on stack
        mov rbx,-8                          ;common array offset

; Calculate bsa1 = 0.007184 * pow(ht, 0.725) * pow(wt, 0.425);
Loop1:  add rbx,8                           ;update array offset
        vmovsd xmm0,[r12+rbx]               ;xmm0 = ht
        vmovsd xmm1,[F64_0p725]             ;xmm1 = 0.754
        call pow wrt ..plt                  ;xmm0 = pow(ht, 0.725)
        vmovsd [rsp+STK_TEMP1_F64],xmm0     ;save intermediate result on stack

        vmovsd xmm0,[r13+rbx]               ;xmm0 = wt
        vmovsd xmm1,[F64_0p425]             ;xmm1 = 0.425
        call pow wrt ..plt                  ;xmm0 = pow(wt, 0.425)

        vmulsd xmm1,xmm0,[rsp+STK_TEMP1_F64]    ;xmm1 = pow(ht, 0.725) * pow(wt, 0.425)
        vmulsd xmm2,xmm1,[F64_0p007184]         ;xmm2 = bsa1
        vmovsd [r14+rbx],xmm2                   ;save bsa1

; Calculate bsa2 = 0.0235 * pow(ht, 0.42246) * pow(wt, 0.51456);
        vmovsd xmm0,[r12+rbx]               ;xmm0 = ht
        vmovsd xmm1,[F64_0p42246]           ;xmm1 = 0.42246
        call pow wrt ..plt                  ;xmm0 = pow(ht, 0.42246)
        vmovsd [rsp+STK_TEMP2_F64],xmm0     ;save intermediate result on stack

        vmovsd xmm0,[r13+rbx]               ;xmm0 = wt
        vmovsd xmm1,[F64_0p51456]           ;xmm1 = 0.51456
        call pow wrt ..plt                  ;xmm0 = pow(wt, 0.51456)

        vmulsd xmm1,xmm0,[rsp+STK_TEMP2_F64]    ;xmm1 = pow(wt, 0.51456) * pow(ht, 0.42246)
        vmulsd xmm5,xmm1,[F64_0p0235]           ;xmm5 = bsa2
        vmovsd [r15+rbx],xmm5                   ;save bsa2

; Calculate bsa3 = sqrt(ht * wt / 3600.0);
        vmovsd xmm0,[r12+rbx]               ;xmm0 = ht
        vmulsd xmm1,xmm0,[r13+rbx]          ;xmm1 = ht * wt
        vdivsd xmm2,xmm1,[F64_3600p0]       ;xmm2 = ht * wt / 3600
        vsqrtsd xmm3,xmm2,xmm2              ;xmm3 = bsa3
        mov rax,[rsp+STK_BSA3]              ;rax = bsa3 array pointer
        vmovsd [rax+rbx],xmm3               ;save bsa3

; Calculate bsa_mean = (bsa1 + bsa2 + bsa3) / 3.0
        vaddsd xmm0,xmm3,[r14+rbx]          ;xmm0 = bsa3 + bsa1
        vaddsd xmm1,xmm0,xmm5               ;xmm1 = bsa3 + bsa1 + bsa2
        vdivsd xmm2,xmm1,[F64_3p0]          ;xmm2 = (bsa3 + bsa1 + bsa2) / 3.0
        mov rax,[rsp+ARG_BSA_MEAN]          ;rax = bsa_mean array pointer
        vmovsd [rax+rbx],xmm2               ;save bsa mean

        sub ebp,1                           ;n -= 1
        jnz Loop1                           ;repeat loop until done

        mov eax,1                           ;set success return code

; Function epilogue
Done:   add rsp,STK_LOCAL+STK_PAD           ;release local storage space
        pop r15                             ;restore NV GPRs
        pop r14
        pop r13
        pop r12
        pop rbx
        pop rbp
        ret

BadVal: xor eax,eax                         ;set error return code
        jmp Done
