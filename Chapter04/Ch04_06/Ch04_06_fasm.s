;------------------------------------------------------------------------------
; Ch04_06_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; void CopyArrayI32_a(int32_t* b, const int32_t* a, size_t n);
;------------------------------------------------------------------------------

        section .text

        global CopyArrayI32_a
CopyArrayI32_a:

; Copy a[] to b[]
; (note: rsi and rdi already contain pointers to a[] and b[])
        mov rcx,rdx                         ;rcx = element count
        rep movsd                           ;copy elements in a[] to b[]
        ret

;------------------------------------------------------------------------------
; void FillArrayI64_a(const int64_t* a, int64_t fill_val, size_t n);
;------------------------------------------------------------------------------

        global FillArrayI64_a
FillArrayI64_a:

; Fill a[] with fill_val
; (note: rdi already contains pointer to a[])
        mov rax,rsi                         ;rax = fill value
        mov rcx,rdx                         ;rcx = element count
        rep stosq                           ;set each element to fill_val
        ret
