;------------------------------------------------------------------------------
; Ch04_06_fasm.asm
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; void CopyArrayI32_a(int32_t* b, const int32_t* a, size_t n);
;------------------------------------------------------------------------------

        .code
CopyArrayI32_a proc

; Save non-volatile registers rsi and rdi
        mov r10,rsi
        mov r11,rdi

; Copy a[] to b[]
        mov rsi,rdx                         ;rsi = source array
        mov rdi,rcx                         ;rdi = destination array
        mov rcx,r8                          ;rcx = element count

        rep movsd                           ;copy elements from a[] to b[]

; Restore non-volatile registers and return
        mov rsi,r10
        mov rsi,r11
        ret
CopyArrayI32_a endp

;------------------------------------------------------------------------------
; void FillArrayI64_a(const int64_t* a, int64_t fill_val, size_t n);
;------------------------------------------------------------------------------

FillArrayI64_a proc

; Save non-volatile registers rsi and rdi
        mov r10,rsi
        mov r11,rdi

; Fill a[] with fill_val
        mov rdi,rcx                         ;rdi = destination array
        mov rax,rdx                         ;rax = fill value
        mov rcx,r8                          ;rcx = element count

        rep stosq                           ;set each element in a[] to fill_val

; Restore non-volatile registers and return
        mov rsi,r10
        mov rsi,r11
        ret
FillArrayI64_a endp
        end
