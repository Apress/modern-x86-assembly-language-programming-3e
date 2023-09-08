;------------------------------------------------------------------------------
; Ch02_03_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; int ShiftU32_asm(unsigned int* a_shl, unsigned int* a_shr, unsigned int a,
;   unsigned int count);
;
; returns:  0 = invalid shift count, 1 = valid shift count
;------------------------------------------------------------------------------

        section .text

        global ShiftU32_a
ShiftU32_a:
        cmp ecx,32                          ;is count >= 32
        jae BadCnt                          ;jump if count >= 32

        mov eax,edx                         ;eax = a
        shl eax,cl                          ;eax = a << count;
        mov [rdi],eax                       ;save shl result

        shr edx,cl                          ;edx = a >> count
        mov [rsi],edx                       ;save shr result

        mov eax,1                           ;valid shift count return code
        ret                                 ;return to caller

BadCnt: xor eax,eax                         ;invalid shift count return code
        ret
