;------------------------------------------------------------------------------
; Ch04_04_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; size_t CountChars_a(const char* s, char c);
;------------------------------------------------------------------------------

        section .text

        global CountChars_a
CountChars_a:

; Perform required initializations
        mov dl,sil                          ;dl = c
        mov rsi,rdi                         ;rsi = s
        xor ecx,ecx                         ;num_chars = 0
        xor r8d,r8d                         ;r8 = 0 (required for add below)

; Repeat loop until the entire string has been scanned
Loop1:  lodsb                               ;load next char into register al
        test al,al                          ;test for end-of-string
        jz Done                             ;jump if end-of-string found
        cmp al,dl                           ;test current char
        sete r8b                            ;r8b = 1 if match, 0 otherwise
        add rcx,r8                          ;num_chars += r8
        jmp Loop1

Done:   mov rax,rcx                         ;rax = num_chars
        ret
