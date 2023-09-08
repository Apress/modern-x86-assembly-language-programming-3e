;------------------------------------------------------------------------------
; Ch14_03_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"
        %include "cmpequ_fp.inc"

            section .rdata
F64_minus1  dq -1.0

;------------------------------------------------------------------------------
; bool CalcDistances_avx512(double* d, const double* x1, const double* y1,
;   const double* x2, const double* y2, size_t n, double thresh);
;------------------------------------------------------------------------------

NSE     equ 8                               ;num_simd_elements

        section .text
        extern CheckArgs

        global CalcDistances_avx512
CalcDistances_avx512:
        push rbx                            ;save non-volatile GPRs
        push r12
        push r13
        push r14
        push r15
        sub rsp,16                          ;allocate stack space for arg saves

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
; n, and y2 are already in the correct registers for CheckArgs().
        call CheckArgs
        or eax,eax                          ;valid arguments?
        jz Err                              ;jump if CheckArgs() failed

;------------------------------------------------------------------------------
; Registers used in code below:
;
; rax = array offset        rbx = d         r10 = n         r12 = x1
; r13 = y1                  r14 = x2        r15 = y2
;
; zmm16 = packed thresh     zmm17 = packed -1.0
;------------------------------------------------------------------------------

; Initialize
        mov rax,-NSE*8                          ;array offset
        mov r10,[rsp]                           ;r10 = n
        vbroadcastsd zmm16,[rsp+8]              ;packed thresh
        vbroadcastsd zmm17,[F64_minus1]         ;packed -1.0

; Calculate distances using SIMD arithmetic
Loop1:  add rax,NSE*8                           ;rax = offset to next elements

        vmovapd zmm0,[r12+rax]                  ;zmm0 = x1[i:i+NSE-1]
        vsubpd zmm1,zmm0,[r14+rax]              ;zmm1 = x1 - x2
        vmulpd zmm1,zmm1,zmm1                   ;zmm1 = (x1 - x2) ** 2

        vmovapd zmm2,[r13+rax]                  ;zmm2 = y1[i:i+NSE-1]
        vsubpd zmm3,zmm2,[r15+rax]              ;zmm3 = y1 - y2
        vmulpd zmm3,zmm3,zmm3                   ;zmm3 = (y1 - y1) ** 2

        vaddpd zmm4,zmm1,zmm3                   ;(x1 - x2) ** 2 + (y1 - y1) ** 2
        vsqrtpd zmm0,zmm4                       ;dist (temp3 in C++ code)

; Calculate d = (temp3 >= thresh) ? temp3 * -1.0 : temp3; using SIMD arithmetic
        vcmppd k1,zmm0,zmm16,CMP_GE_OQ          ;compare raw dist to thresh
        vmovapd zmm2{k1}{z},zmm17               ;zmm2 = -1.0 (compare true) or zero
        vmulpd zmm3,zmm2,zmm0                   ;zmm3 = -1.0 * dist or 0.0
        knotb k2,k1                             ;k2 = mask for dist < thresh
        vmovapd zmm4{k2}{z},zmm0                ;zmm4 = dist or 0.0
        vorpd zmm5,zmm4,zmm3                    ;zmm5 = final result
        vmovapd [rbx+rax],zmm5                  ;save result to d[i:i+NSE-1]

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

Err:    xor eax,eax                             ;set errror return code
        jmp Done
