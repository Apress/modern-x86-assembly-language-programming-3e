;------------------------------------------------------------------------------
; Ch04_02_fasm.asm
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; void CalcArrayVals_a(int64_t* c, const int64_t* a, const int64_t* b, size_t n);
;------------------------------------------------------------------------------

        .code
CalcArrayVals_a proc frame
        push r12                            ;save non-volatile register r12
        .pushreg r12
        .endprolog

; Make sure n is valid
        or r9,r9                            ;n == 0?
        jz Done                             ;jump if yes

; Initialize
        mov r10,rdx                         ;r10 = ptr to a[]
        mov r11,-8                          ;r11 = common offset for arrays

; Calculate c[i] = a[i] * 25) / (b[i] + 10);
Loop1:  add r11,8                           ;r11 = offset for a[i], b[i], and c[i]

        mov rax,[r10+r11]                   ;rax = a[i]
        imul rax,rax,25                     ;rax = a[i] * 25

        mov r12,[r8+r11]                    ;r12 = b[i]
        add r12,10                          ;r12 = b[i] + 10

        cqo                                 ;rdx:rax = a[i] * 25
        idiv r12                            ;rax = (a[i] * 25) / (b[i] + 10)

        mov [rcx+r11],rax                   ;save quotient to c[i]

        sub r9,1                            ;n -= 1
        jnz Loop1                           ;repeat until n == 0

        pop r12                             ;restore r12
Done:   ret                                 ;return to caller

CalcArrayVals_a endp
        end
