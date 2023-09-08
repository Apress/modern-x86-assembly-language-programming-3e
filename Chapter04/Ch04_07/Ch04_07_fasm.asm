;------------------------------------------------------------------------------
; Ch04_07_fasm.asm
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; int ReverseArrayI32_a(int32_t* y, const int32_t* x, int32_t n);
;------------------------------------------------------------------------------

        .code
ReverseArrayI32_a proc

; Save non-volatile registers
        mov r10,rsi
        mov r11,rdi

; Make sure n is valid
        xor eax,eax                         ;error return code
        test r8d,r8d                        ;is n <= 0?
        jle BadArg                          ;jump if n <= 0

; Initialize registers for reversal operation
        mov rsi,rdx                         ;rsi = x
        mov rdi,rcx                         ;rdi = y
        mov ecx,r8d                         ;rcx = n
        lea rsi,[rsi+rcx*4-4]               ;rsi = &x[n - 1]

; Save caller's RFLAGS.DF, then set RFLAGS.DF to 1
        pushfq                              ;save caller's RFLAGS.DF
        std                                 ;RFLAGS.DF = 1

; Repeat loop until array reversal is complete
Loop1:  lodsd                               ;eax = *x--
        mov [rdi],eax                       ;*y = eax
        add rdi,4                           ;y++
        sub rcx,1                           ;n -= 1
        jnz Loop1                           ;jump if more elements

; Restore caller's RFLAGS.DF and set return code
        popfq                               ;restore caller's RFLAGS.DF
        mov eax,1                           ;set success return code

; Restore non-volatile registers and return
BadArg: mov rsi,r10
        mov rdi,r11
        ret
ReverseArrayI32_a endp
        end
