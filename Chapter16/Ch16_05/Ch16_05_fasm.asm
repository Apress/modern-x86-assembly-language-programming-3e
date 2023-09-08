;------------------------------------------------------------------------------
; Ch16_05_fasm.asm
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; size_t ReplaceChar_avx2(char* s, char char_old, char char_new);
;------------------------------------------------------------------------------

        .code
ReplaceChar_avx2 proc
        xor r9,r9                           ;num_replaced = 0
        sub rcx,1                           ;adjust pointer for Loop1

; Use GP registers to replace characters until string pointer is 16-byte aligned
Loop1:  add rcx,1                           ;rcx = &s[i]
        test rcx,0fh                        ;is rcx 16-byte aligned?
        jz Aln16                            ;jump if yes

        mov r10b,[rcx]                      ;r10b = s[i]
        or r10b,r10b                        ;null char?
        jz Done                             ;jump if yes

        cmp r10b,dl                         ;s[i] = char_old?
        jne Loop1                           ;jump if no

        mov [rcx],r8b                       ;s[i] = char_new
        add r9,1                            ;num_replaced += 1
        jmp Loop1

; Use XMM registers to replace characters
Aln16:  sub rcx,16                          ;adjust for Loop2
        vpxor xmm0,xmm0,xmm0                ;xmm0 = packed null chars

        vmovd xmm1,edx
        vpbroadcastb xmm1,xmm1              ;xmm1 = packed char_old

        vmovd xmm2,r8d
        vpbroadcastb xmm2,xmm2              ;xmm2 = packed char_new

Loop2:  add rcx,16                          ;update pointer

        vmovdqa xmm3,xmmword ptr [rcx]      ;xmm3 = s[i:i+15]

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
        vmovdqa xmmword ptr [rcx],xmm3      ;save s[i:i+15]
        jmp Loop2

; Use GP registers to process residual characters
NullCh: sub rcx,1                           ;adjust for Loop3

Loop3:  add rcx,1                           ;rcx points to s[i]
        mov r10b,[rcx]                      ;r10b = s[i]
        or r10b,r10b                        ;null char?
        jz Done                             ;jump if yes

        cmp r10b,dl                         ;s[i] == char_old?
        jne Loop3                           ;jump if no

        mov [rcx],r8b                       ;s[i] = char_new
        add r9,1                            ;num_replaced += 1
        jmp Loop3                           ;repeat until done

Done:   mov rax,r9                          ;return num_replaced to caller
        ret
ReplaceChar_avx2 endp
        end
