;------------------------------------------------------------------------------
; Ch08_02_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; void MulI16_avx(XmmVal c[2], const XmmVal* a, const XmmVal* b);
;------------------------------------------------------------------------------

        section .text

        global MulI16_avx
MulI16_avx:

        vmovdqa xmm0,[rsi]                  ;xmm0 = a
        vmovdqa xmm1,[rdx]                  ;xmm1 = b

        vpmullw xmm2,xmm0,xmm1              ;packed mul - low result
        vpmulhw xmm3,xmm0,xmm1              ;packed mul - high result

        vpunpcklwd xmm4,xmm2,xmm3           ;packed low-order dwords
        vpunpckhwd xmm5,xmm2,xmm3           ;packed high-order dwords

        vmovdqa [rdi],xmm4                  ;save c[0]
        vmovdqa [rdi+16],xmm5               ;save c[1]
        ret

;------------------------------------------------------------------------------
; void MulI32a_avx(XmmVal* c, const XmmVal* a, const XmmVal* b);
;------------------------------------------------------------------------------

        global MulI32a_avx
MulI32a_avx:

        vmovdqa xmm0,[rsi]                  ;xmm0 = a
        vmovdqa xmm1,[rdx]                  ;xmm1 = b

        vpmulld xmm2,xmm0,xmm1              ;packed mul - low result

        vmovdqa [rdi],xmm2                  ;save c
        ret

;------------------------------------------------------------------------------
; void MulI32b_avx(XmmVal c[2], const XmmVal* a, const XmmVal* b);
;------------------------------------------------------------------------------

        global MulI32b_avx
MulI32b_avx:

        vmovdqa xmm0,[rsi]                  ;xmm0 = a
        vmovdqa xmm1,[rdx]                  ;xmm1 = b

        vpmuldq xmm2,xmm0,xmm1              ;packed mul - a & b even dwords
        vpsrldq xmm3,xmm0,4                 ;shift a_vals right 4 bytes
        vpsrldq xmm4,xmm1,4                 ;shift b_vals right 4 bytes
        vpmuldq xmm5,xmm3,xmm4              ;packed mul - a & b odd dwords

        vpextrq [rdi],xmm2,0                ;save qword product 0
        vpextrq [rdi+8],xmm5,0              ;save qword product 1
        vpextrq [rdi+16],xmm2,1             ;save qword product 2
        vpextrq [rdi+24],xmm5,1             ;save qword product 3
        ret
