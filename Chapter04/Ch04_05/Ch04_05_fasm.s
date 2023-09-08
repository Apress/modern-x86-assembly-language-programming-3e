;------------------------------------------------------------------------------
; Ch04_05_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; int64_t CompareArrays_a(const int32_t* x, const int32_t* y, int64_t n);
;
; Returns       -1          Value of n is invalid
;               0 <= i < n  Index of first non-matching element
;               n           All elements match
;------------------------------------------------------------------------------

        section .text

        global CompareArrays_a
CompareArrays_a:

; Validate n
        mov rax,-1                          ;rax = return code for invalid n
        test rdx,rdx
        jle Done                            ;jump if n <= 0

; Compare the arrays for equality
; (rsi and rdi already contain pointers to arrays x and y)
        mov rcx,rdx                         ;rcx = n
        mov rax,rdx                         ;rax = n

        repe cmpsd                          ;compare arrays

; Calculate index of first non-match
        jz Done                             ;jump if arrays are equal
        sub rax,rcx                         ;rax = index of mismatch + 1
        sub rax,1                           ;rax = index of mismatch

Done:   ret
