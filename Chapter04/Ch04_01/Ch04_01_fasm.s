;------------------------------------------------------------------------------
; Ch04_01_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; int64_t SumElementsI32_a(const int32_t* x, uint64_t n);
;------------------------------------------------------------------------------

        section .text

        global SumElementsI32_a
SumElementsI32_a:

; Perform required initializations
        xor eax,eax                         ;sum = 0
        sub rdi,4                           ;rdi = &x[-1]

; Make sure n is valid
        or rsi,rsi                          ;n == 0?
        jz Done                             ;jump if yes

; Sum the elements of the array
Loop1:  add rdi,4                           ;rdi points to next element in x[]

        movsxd r11,dword [rdi]              ;load (sign-extended) element from x[]
        add rax,r11                         ;update sum in rax

        sub rsi,1                           ;n -= 1
        jnz Loop1                           ;repeat until n is zero

Done:   ret                                 ;return to caller
