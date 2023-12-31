;------------------------------------------------------------------------------
; Ch03_04_fasm.asm
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; int SignedMin1_a(int a, int b, int c);
;------------------------------------------------------------------------------

        .code
SignedMin1_a proc
        mov eax,ecx
        cmp eax,edx                         ;compare a and b
        jle @F                              ;jump if a <= b
        mov eax,edx                         ;eax = b

@@:     cmp eax,r8d                         ;compare min(a, b) and c
        jle @F
        mov eax,r8d                         ;eax = min(a, b, c)
@@:     ret
SignedMin1_a endp

;------------------------------------------------------------------------------
; int SignedMin2_a(int a, int b, int c);
;------------------------------------------------------------------------------

SignedMin2_a proc
        cmp ecx,edx
        cmovg ecx,edx                       ;ecx = min(a, b)
        cmp ecx,r8d
        cmovg ecx,r8d                       ;ecx = min(a, b, c)
        mov eax,ecx
        ret
SignedMin2_a endp

;------------------------------------------------------------------------------
; int SignedMax1_a(int a, int b, int c);
;------------------------------------------------------------------------------

SignedMax1_a proc
        mov eax,ecx
        cmp eax,edx                         ;compare a and b
        jge @F                              ;jump if a >= b
        mov eax,edx                         ;eax = b

@@:     cmp eax,r8d                         ;compare max(a, b) and c
        jge @F
        mov eax,r8d                         ;eax = max(a, b, c)
@@:     ret
SignedMax1_a endp

;------------------------------------------------------------------------------
; int SignedMax2_a(int a, int b, int c);
;------------------------------------------------------------------------------

SignedMax2_a proc
        cmp ecx,edx
        cmovl ecx,edx                       ;ecx = max(a, b)
        cmp ecx,r8d
        cmovl ecx,r8d                       ;ecx = max(a, b, c)
        mov eax,ecx
        ret
SignedMax2_a endp
        end
