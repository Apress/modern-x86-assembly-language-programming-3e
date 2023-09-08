;------------------------------------------------------------------------------
; Ch03_04_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; int SignedMin1_a(int a, int b, int c);
;------------------------------------------------------------------------------

        section .text

        global SignedMin1_a
SignedMin1_a:
        mov eax,esi
        cmp eax,edi                         ;compare a and b
        jle F1                              ;jump if a <= b
        mov eax,edi                         ;eax = b

F1:     cmp eax,edx                         ;compare min(a, b) and c
        jle F2
        mov eax,edx                         ;eax = min(a, b, c)
F2:     ret

;------------------------------------------------------------------------------
; int SignedMin2_a(int a, int b, int c);
;------------------------------------------------------------------------------

        global SignedMin2_a
SignedMin2_a:
        cmp edi,esi
        cmovg edi,esi                       ;edi = min(a, b)
        cmp edi,edx
        cmovg edi,edx                       ;edi = min(a, b, c)
        mov eax,edi
        ret

;------------------------------------------------------------------------------
; int SignedMax1_a(int a, int b, int c);
;------------------------------------------------------------------------------

        global SignedMax1_a
SignedMax1_a:
        mov eax,esi
        cmp eax,edi                         ;compare a and b
        jge F3                              ;jump if a >= b
        mov eax,edi                         ;eax = b

F3:     cmp eax,edx                         ;compare max(a, b) and c
        jge F4
        mov eax,edx                         ;eax = max(a, b, c)
F4:     ret

;------------------------------------------------------------------------------
; int SignedMax2_a(int a, int b, int c);
;------------------------------------------------------------------------------

        global SignedMax2_a
SignedMax2_a:
        cmp esi,edi
        cmovl esi,edi                       ;esi = max(a, b)
        cmp esi,edx
        cmovl esi,edx                       ;esi = max(a, b, c)
        mov eax,esi
        ret
