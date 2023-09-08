;------------------------------------------------------------------------------
; Ch05_04_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; void CompareF32_avx(uint8_t* cmp_results, float a, float b);
;------------------------------------------------------------------------------

        section .text

        global CompareF32_avx
CompareF32_avx:

; Set result flags based on compare status
        vucomiss xmm0,xmm1
        setp [rdi]                          ;RFLAGS.PF = 1 if unordered
        jnp L1
        xor al,al
        mov [rdi+1],al                      ;set all other cmp_results[]
        mov [rdi+2],al                      ;values to 0
        mov [rdi+3],al
        mov [rdi+4],al
        mov [rdi+5],al
        mov [rdi+6],al
        ret

L1:     setb [rdi+1]                        ;set byte if a < b
        setbe [rdi+2]                       ;set byte if a <= b
        sete [rdi+3]                        ;set byte if a == b
        setne [rdi+4]                       ;set byte if a != b
        seta [rdi+5]                        ;set byte if a > b
        setae [rdi+6]                       ;set byte if a >= b
        ret
