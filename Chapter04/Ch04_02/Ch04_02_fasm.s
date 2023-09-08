;------------------------------------------------------------------------------
; Ch04_02_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; void CalcArrayVals_a(int64_t* c, const int64_t* a, const int64_t* b, size_t n);
;------------------------------------------------------------------------------

        section .text

        global CalcArrayVals_a
CalcArrayVals_a:

; Make sure n is valid
        or rcx,rcx                          ;n == 0?
        jz Done                             ;jump if yes

; Initialize
        mov r8,rdx                          ;r8 = ptr to b[]
        mov r11,-8                          ;r11 = common offset for arrays

; Calculate c[i] = a[i] * 25) / (b[i] + 10);
Loop1:  add r11,8                           ;r11 = offset for a[i], b[i], and c[i]

        mov rax,[rsi+r11]                   ;rax = a[i]
        imul rax,rax,25                     ;rax = a[i] * 25

        mov r9,[r8+r11]                     ;r9 = b[i]
        add r9,10                           ;r9 = b[i] + 10

        cqo                                 ;rdx:rax = a[i] * 25
        idiv r9                             ;rax = (a[i] * 25) / (b[i] + 10)

        mov [rdi+r11],rax                   ;save quotient to c[i]

        sub rcx,1                           ;n -= 1
        jnz Loop1                           ;repeat until n == 0

Done:   ret                                 ;return to caller
