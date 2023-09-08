;------------------------------------------------------------------------------
; Ch02_05_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; void MulI32_a(int* prod1, long long* prod2, int a, int b);
;------------------------------------------------------------------------------

        section .text

        global MulI32_a
 MulI32_a:
        mov eax,edx                         ;eax = a
        imul edx,ecx                        ;ecx = a * b (32-bit product)
        mov [rdi],edx                       ;save a * b to prod1

        movsxd rax,eax                      ;rax = a (sign-extended)
        movsxd rcx,ecx                      ;rcx = b (sign-extended)
        imul rcx                            ;rdx:rax = a * b (128-bit product)
        mov [rsi],rax                       ;save low-order qword to prod2

        ret                                 ;return to caller

;------------------------------------------------------------------------------
; int DivI32_a(int* quo, int* rem, int a, int b);
;
; returns: 0 = error (divisior equals zero), 1 = success
;------------------------------------------------------------------------------

        global DivI32_a
DivI32_a:
        or ecx,ecx                          ;is b == 0?
        jz InvalidDivisor                   ;jump if yes

        mov eax,edx                         ;eax = a
        cdq                                 ;sign-extend a to 64-bits (edx:eax)
        idiv ecx                            ;eax = quotient, edx = remainder

        mov [rdi],eax                       ;save quotient
        mov [rsi],edx                       ;save remainder

        mov eax,1                           ;set success return code
        ret                                 ;return to caller

InvalidDivisor:
        xor eax,eax                         ;set error return code
        ret
