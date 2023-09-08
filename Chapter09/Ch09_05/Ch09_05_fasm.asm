;------------------------------------------------------------------------------
; Ch09_05_fasm.asm
;------------------------------------------------------------------------------

        include <cmpequ_fp.asmh>
        include <MacrosX86-64-AVX.asmh>

        .const
F64_minus1  real8 -1.0

;------------------------------------------------------------------------------
; bool CalcDistances_avx(double* d, const double* x1, const double* y1,
;   const double* x2, const double* y2, size_t n, double thresh);
;------------------------------------------------------------------------------

NSE     equ 4                           ;num simd elements per iteration

        extern CheckArgs:proc

        .code
CalcDistances_avx proc frame

; Function prologue
        CreateFrame_M CD_,0,32,rbx,r12,r13,r14,r15
        SaveXmmRegs_M xmm14,xmm15
        EndProlog_M

; Copy arguments in volatile registers to non-volatile registers
        mov rbx,rcx                                 ;rbx = d
        mov r12,rdx                                 ;r12 = x1
        mov r13,r8                                  ;r13 = y1
        mov r14,r9                                  ;r14 = x2
        mov r15,[rbp+CD_OffsetStackArgs]            ;r15 = y2

; Make sure the arguments are valid. Note that arguments d, x1, y1, and x2 are
; already in the correct registers for CheckArgs().
        mov rax,[rbp+CD_OffsetStackArgs+8]          ;rax = n
        push rax                                    ;copy n to stack
        push r15                                    ;copy y2 to stack
        sub rsp,32                                  ;create home area
        call CheckArgs
        or eax,eax                                  ;valid arguments?
        jz BadArg                                   ;jump if CheckArgs() failed

;------------------------------------------------------------------------------
; Registers used in code below:
;
; rax = array offset        rbx = d         r10 = n         r12 = x1
; r13 = y1                  r14 = x2        r15 = y2
;
; ymm14 = packed thresh     ymm15 = packed -1.0
;------------------------------------------------------------------------------

; Initialize
        mov rax,-NSE*8                                              ;array offset
        mov r10,[rbp+CD_OffsetStackArgs+8]                          ;r10 = n
        vbroadcastsd ymm14,real8 ptr [rbp+CD_OffsetStackArgs+16]    ;packed thresh
        vbroadcastsd ymm15,real8 ptr [F64_minus1]                   ;packed -1.0

; Calculate distances using SIMD arithmetic
Loop1:  add rax,NSE*8                           ;rax = offset to next elements

        vmovapd ymm0,ymmword ptr [r12+rax]      ;ymm0 = x1[i:i+NSE-1]
        vsubpd ymm1,ymm0,[r14+rax]              ;ymm1 = x1 - x2
        vmulpd ymm1,ymm1,ymm1                   ;ymm1 = (x1 - x2) ** 2

        vmovapd ymm2,ymmword ptr [r13+rax]      ;ymm2 = y1[i:i+NSE-1]
        vsubpd ymm3,ymm2,[r15+rax]              ;ymm3 = y1 - y2
        vmulpd ymm3,ymm3,ymm3                   ;ymm3 = (y1 - y1) ** 2

        vaddpd ymm4,ymm1,ymm3                   ;(x1 - x2) ** 2 + (y1 - y1) ** 2
        vsqrtpd ymm0,ymm4                       ;distance (dist in C++ code)

; Calculate d = (temp3 >= thresh) ? temp3 * -1.0 : temp3; using SIMD arithmetic
        vcmppd ymm1,ymm0,ymm14,CMP_GE_OQ        ;compare raw dist to thresh
        vandpd ymm2,ymm1,ymm15                  ;ymm2 = -1.0 (compare true) or 0.0
        vmulpd ymm3,ymm2,ymm0                   ;ymm3 = -1.0 * dist or 0.0
        vandnpd ymm4,ymm1,ymm0                  ;ymm4 = 0.0 or dist
        vorpd ymm5,ymm3,ymm4                    ;ymm5 = final result
        vmovapd ymmword ptr [rbx+rax],ymm5      ;save result to d[i:i+NSE-1]

        sub r10,NSE                             ;n -= NSE
        jnz Loop1                               ;jump if yes

        mov eax,1                               ;set success return code

; Function epilogue
Done:   vzeroupper
        RestoreXmmRegs_M xmm14,xmm15
        DeleteFrame_M rbx,r12,r13,r14,r15       ;delete stack frame and restore regs
        ret

BadArg: xor eax,eax                             ;set errror return code
        jmp Done

CalcDistances_avx endp
        end
