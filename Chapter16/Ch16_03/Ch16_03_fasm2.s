;------------------------------------------------------------------------------
; Ch16_03_fasm2.asm
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; bool AbsImageNT_avx2(uint8_t* pb_des, const uint8_t* pb_src0,
;   const uint8_t * pb_src1, size_t num_pixels);
;------------------------------------------------------------------------------

NSE     equ 32                              ;num_simd_elements

        section .text
        extern CheckArgs

        global AbsImageNT_avx2
AbsImageNT_avx2:
        push r12
        push r13
        push r14
        push r15
        sub rsp,8                           ;align rsp on 16-byte boundary

; Copy args to non-volatile registers
        mov r12,rdi                         ;pb_des
        mov r13,rsi                         ;pb_src0
        mov r14,rdx                         ;pb_src1
        mov r15,rcx                         ;num_pixels

; Validate arguments
        call CheckArgs
        or eax,eax                          ;arguments valid?
        jz Done                             ;jump if no

; Initialize
        vpxor ymm15,ymm15,ymm15             ;packed zeros
        mov rax,-NSE                        ;rax = array index i

; Calculate pb_des[i] = abs(pb_src0[i] - pb_src2[i])
Loop1:  add rax,NSE                         ;i += NSE
        vmovdqa ymm0,[r13+rax]              ;load pb_src0[i:i+NSE-1]
        vmovdqa ymm1,[r14+rax]              ;load pb_src1[i:i+NSE-1]

        vpunpcklbw ymm2,ymm0,ymm15          ;convert pb_src0 to words
        vpunpckhbw ymm3,ymm0,ymm15
        vpunpcklbw ymm4,ymm1,ymm15          ;convert pb_src1 to words
        vpunpckhbw ymm5,ymm1,ymm15

        vpsubw ymm0,ymm2,ymm4               ;calc pb_src0 - pb_src1
        vpsubw ymm1,ymm3,ymm5
        vpabsw ymm0,ymm0                    ;calc abs(pb_src0 - pb_src1)
        vpabsw ymm1,ymm1
        vpackuswb ymm2,ymm0,ymm1            ;convert result to bytes
 
        vmovntdq [r12+rax],ymm2             ;save pb_des[i:i+NSE-1]

        sub r15,NSE                         ;num_pixels -= NSE
        jnz Loop1                           ;repeat until done

        mov eax,1                           ;set success return code

Done:   vzeroupper
        add rsp,8
        pop r15
        pop r14
        pop r13
        pop r12
        ret
