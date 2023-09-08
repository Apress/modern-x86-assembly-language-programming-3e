;------------------------------------------------------------------------------
; Ch04_01_fasm.asm
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; int64_t SumElementsI32_a(const int32_t* x, size_t n);
;------------------------------------------------------------------------------

        .code
SumElementsI32_a proc

; Perform required initializations
        xor eax,eax                         ;sum = 0
        sub rcx,4                           ;rcx = &x[-1]

; Make sure n is valid
        or rdx,rdx                          ;n == 0?
        jz Done                             ;jump if yes

; Sum the elements of x[]
Loop1:  add rcx,4                           ;rcx points to next element in x[]

        movsxd r11,dword ptr [rcx]          ;load (sign-extended) element from x[]
        add rax,r11                         ;update sum in rax

        sub rdx,1                           ;n -= 1
        jnz Loop1                           ;repeat until n is zero

Done:   ret                                 ;return to caller

SumElementsI32_A endp
        end
