;------------------------------------------------------------------------------
; Ch09_05 fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"
        %include "cmpequ_fp.inc"

        section .rdata
F64_minus1  dq  -1.0

;------------------------------------------------------------------------------
; bool CalcDistances_avx(double* d, const double* x1, const double* y1,
;   const double* x2, const double* y2, size_t n, double thresh);
;------------------------------------------------------------------------------

NSE     equ 4                               ;num simd elements per iteration

        section .text
        extern CheckArgs

        global CalcDistances_avx
CalcDistances_avx:
        push rbx                            ;save non-volatile GPRs
        push r12
        push r13
        push r14
        push r15
        sub rsp,16                          ;stack space arg saves

; Copy arguments in volatile registers to non-volatile registers.
; Also save args n and thresh on stack.
        mov rbx,rdi                         ;rbx = d
        mov r12,rsi                         ;r12 = x1
        mov r13,rdx                         ;r13 = y1
        mov r14,rcx                         ;r14 = x2
        mov r15,r8                          ;r15 = y2
        mov [rsp],r9                        ;save n on stack 
        vmovsd [rsp+8],xmm0                 ;save thresh on stack

; Make sure the arguments are valid. Note that arguments d, x1, y1, x2,
; y2, and n are already in the correct registers for CheckArgs().
        call CheckArgs
        or eax,eax                          ;valid arguments?
        jz BadArg                           ;jump if CheckArgs() failed

;------------------------------------------------------------------------------
; Registers used in code below:
;
; rax = array offset        rbx = d         r10 = n         r12 = x1
; r13 = y1                  r14 = x2        r15 = y2
;
; ymm14 = packed thresh     ymm15 = packed -1.0
;------------------------------------------------------------------------------

; Initialize
        mov rax,-NSE*8                      ;rax = array offset
        mov r10,[rsp]                       ;r10 = n
        vbroadcastsd ymm14,[rsp+8]          ;packed thresh
        vbroadcastsd ymm15,[F64_minus1]     ;packed -1.0

; Calculate distances using SIMD arithmetic
Loop1:  add rax,NSE*8                           ;rax = offset to next elements

        vmovapd ymm0,[r12+rax]                  ;ymm0 = x1[i:i+NSE-1]
        vsubpd ymm1,ymm0,[r14+rax]              ;ymm1 = x1 - x2
        vmulpd ymm1,ymm1,ymm1                   ;ymm1 = (x1 - x2) ** 2

        vmovapd ymm2,[r13+rax]                  ;ymm2 = y1[i:i+NSE-1]
        vsubpd ymm3,ymm2,[r15+rax]              ;ymm3 = y1 - y2
        vmulpd ymm3,ymm3,ymm3                   ;ymm3 = (y1 - y1) ** 2

        vaddpd ymm4,ymm1,ymm3                   ;(x1 - x2) ** 2 + (y1 - y1) ** 2
        vsqrtpd ymm0,ymm4                       ;raw dist (dist in C++ code)

; Calculate d = (temp3 >= thresh) ? temp3 * -1.0 : temp3;
        vcmppd ymm1,ymm0,ymm14,CMP_GE_OQ        ;compare raw dist to thresh
        vandpd ymm2,ymm1,ymm15                  ;ymm2 = -1.0 (compare true) or 0.0
        vmulpd ymm3,ymm2,ymm0                   ;ymm3 = -1.0 * dist or 0.0
        vandnpd ymm4,ymm1,ymm0                  ;ymm4 = 0.0 or dist
        vorpd ymm5,ymm3,ymm4                    ;ymm5 = final result
        vmovapd [rbx+rax],ymm5                  ;save result to d[i:i+NSE-1]

        sub r10,NSE                             ;n -= NSE
        jnz Loop1                               ;jump if yes

        mov eax,1                               ;set success return code

Done:   vzeroupper
        add rsp,16                              ;release local stack space
        pop r15                                 ;restore non-volatile registers
        pop r14
        pop r13
        pop r12
        pop rbx
        ret

BadArg: xor eax,eax                             ;set errror return code
        jmp Done
