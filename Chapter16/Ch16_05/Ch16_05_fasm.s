;------------------------------------------------------------------------------
; Ch16_05_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; size_t ReplaceChar_avx2(char* s, char char_old, char char_new);
;------------------------------------------------------------------------------

        section .text

        global ReplaceChar_avx2
ReplaceChar_avx2:
        xor r9,r9                           ;num_replaced = 0
        sub rdi,1                           ;adjust pointer for Loop1

; Use GP registers to replace characters until string pointer is 16-byte aligned
Loop1:  add rdi,1                           ;rdi = &s[i]
        test rdi,0fh                        ;is rdi 16-byte aligned?
        jz Aln16                            ;jump if yes

        mov r10b,[rdi]                      ;r10b = s[i]
        or r10b,r10b                        ;null char?
        jz Done                             ;jump if yes

        cmp r10b,sil                        ;s[i] = char_old?
        jne Loop1                           ;jump if no

        mov [rdi],dl                        ;s[i] = char_new
        add r9,1                            ;num_replaced += 1
        jmp Loop1

; Use XMM registers to replace characters
Aln16:  sub rdi,16                          ;adjust for Loop2
        vpxor xmm0,xmm0,xmm0                ;xmm0 = packed null chars

        vmovd xmm1,esi
        vpbroadcastb xmm1,xmm1              ;xmm1 = packed char_old

        vmovd xmm2,edx
        vpbroadcastb xmm2,xmm2              ;xmm2 = packed char_new

Loop2:  add rdi,16                          ;update pointer

        vmovdqa xmm3,[rdi]                  ;xmm3 = s[i:i+15]

        vpcmpeqb xmm4,xmm3,xmm0             ;test for null char
        vpmovmskb r10,xmm4
        or r10,r10                          ;null char found?
        jnz NullCh                          ;jump if yes

        vpcmpeqb xmm4,xmm3,xmm1             ;compare s[i:i+15] to char_old
        vpmovmskb r10,xmm4
        popcnt r10,r10                      ;r10 = num_matches
        jz Loop2                            ;jump if no char_old matches

        add r9,r10                          ;num_replaced += num_matches
        vpandn xmm5,xmm4,xmm3               ;remove char_old (keeps non-matches)
        vpand xmm3,xmm4,xmm2                ;insert char_new (zeros non-matches)
        vpor xmm3,xmm3,xmm5                 ;merge for final result
        vmovdqa [rdi],xmm3                  ;save s[i:i+15]
        jmp Loop2

; Use GP registers to process residual characters
NullCh: sub rdi,1                           ;adjust for Loop3

Loop3:  add rdi,1                           ;rdi points to s[i]
        mov r10b,[rdi]                      ;r10b = s[i]
        or r10b,r10b                        ;null char?
        jz Done                             ;jump if yes

        cmp r10b,sil                        ;s[i] == char_old?
        jne Loop3                           ;jump if no

        mov [rdi],dl                        ;s[i] = char_new
        add r9,1                            ;num_replaced += 1
        jmp Loop3                           ;repeat until done

Done:   mov rax,r9                          ;return num_replaced to caller
        ret
