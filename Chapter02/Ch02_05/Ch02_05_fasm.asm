;------------------------------------------------------------------------------
; Ch02_05_fasm.asm
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; void MulI32_a(int* prod1, long long* prod2, int a, int b);
;------------------------------------------------------------------------------

        .code
MulI32_a proc
        mov eax,r8d                         ;eax = a
        imul r8d,r9d                        ;rd8 = a * b (32-bit product)
        mov [rcx],r8d                       ;save a * b to prod1

        mov r10,rdx                         ;r10 = prod2 pointer
        movsxd rax,eax                      ;rax = a (sign-extended)
        movsxd r11,r9d                      ;r11 = b (sign-extended)
        imul r11                            ;rdx:rax = a * b (128-bit product)
        mov [r10],rax                       ;save low-order qword to prod2
        ret                                 ;return to caller
MulI32_a endp

;------------------------------------------------------------------------------
; int DivI32_a(int* quo, int* rem, int a, int b);
;
; returns: 0 = error (divisor equals zero), 1 = success
;------------------------------------------------------------------------------

DivI32_a proc
        or r9d,r9d                          ;is b == 0?
        jz InvalidDivisor                   ;jump if yes

        mov r10,rdx                         ;r10 = rem pointer

        mov eax,r8d                         ;eax = a
        cdq                                 ;sign-extend a to 64-bits (edx:eax)
        idiv r9d                            ;eax = quotient, edx = remainder

        mov [rcx],eax                       ;save quotient
        mov [r10],edx                       ;save remainder

        mov eax,1                           ;set success return code
        ret                                 ;return to caller

InvalidDivisor:
        xor eax,eax                         ;set error return code
        ret
DivI32_a endp
        end
