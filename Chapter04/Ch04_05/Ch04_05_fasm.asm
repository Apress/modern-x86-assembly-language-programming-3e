;------------------------------------------------------------------------------
; Ch04_05_fasm.asm
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; int64_t CompareArrays_a(const int32_t* x, const int32_t* y, int64_t n);
;
; Returns       -1          Value of n is invalid
;               0 <= i < n  Index of first non-matching element
;               n           All elements match
;------------------------------------------------------------------------------

        .code
CompareArrays_a proc

; Save caller's non-volatile registers
        mov r10,rsi
        mov r11,rdi

; Validate n
        mov rax,-1                          ;rax = return code for invalid n
        test r8,r8
        jle Done                            ;jump if n <= 0

; Compare the arrays for equality
        mov rsi,rcx                         ;rsi = x
        mov rdi,rdx                         ;rdi = y
        mov rcx,r8                          ;rcx = n
        mov rax,r8                          ;rax = n

        repe cmpsd                          ;compare arrays

; Calculate index of first non-match
        jz Done                             ;jump if arrays are equal
        sub rax,rcx                         ;rax = index of mismatch + 1
        sub rax,1                           ;rax = index of mismatch

; Restore caller's non-volatile registers and return
Done:   mov rsi,r10
        mov rdi,r11
        ret
CompareArrays_a endp
        end
