;------------------------------------------------------------------------------
; Ch04_03_fasm.asm
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; void CalcMat2dSquares_a(int32_t* y, const int32_t* x, size_t m, size_t n);
;------------------------------------------------------------------------------

        .code
CalcMat2dSquares_a proc frame
        push r12                            ;save caller's r12
        .pushreg r12
        .endprolog

; Make sure m and n are valid
        test r8,r8
        jz InvalidSize                      ;jump if m == 0
        test r9,r9
        jz InvalidSize                      ;jump if n == 0

;------------------------------------------------------------------------------
; Register use in code below:
;
; rcx = y   rdx = x     r8 = m          r9 = n
; r10 = i   r11 = j     r12 = scratch   rax = scratch
;------------------------------------------------------------------------------

; Initalize
        xor r10,r10                         ;i = 0

; Loop1 is outer for-loop, Loop2 is inner for-loop
Loop1:  xor r11,r11                         ;j = 0

; Calculate x[j][i] * x[j][i]
Loop2:  mov rax,r11                         ;rax = j
        imul rax,r8                         ;rax = j * m
        add rax,r10                         ;rax = j * m + i (kx)

        mov r12d,[rdx+rax*4]                ;r12d = x[j][i]
        imul r12d,r12d                      ;r12d = x[j][i] * x[j][i]

; Set y[i][j] = x[j][i] * x[j][i]
        mov rax,r10                         ;rax = i
        imul rax,r9                         ;rax = i * n
        add rax,r11                         ;rax = i * n + j (ky)

        mov [rcx+rax*4],r12d                ;save y[i][j]

; Update inner for-loop counter
        add r11,1                           ;j += 1
        cmp r11,r9
        jb Loop2                            ;jump if j < n

; Update outer for-loop counter
        add r10,1                           ;i += 1
        cmp r10,r8
        jb Loop1                            ;jump if i < m

InvalidSize:
        pop r12                             ;restore r12
        ret

CalcMat2dSquares_a endp
        end
