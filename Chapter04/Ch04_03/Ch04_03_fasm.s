;------------------------------------------------------------------------------
; Ch04_03_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; void CalcMat2dSquares_a(int32_t* y, const int32_t* x, size_t m, size_t n);
;------------------------------------------------------------------------------

        section .text

        global CalcMat2dSquares_a
CalcMat2dSquares_a:

; Make sure m and n are valid
        test rdx,rdx
        jz InvalidSize                      ;jump if m == 0
        test rcx,rcx
        jz InvalidSize                      ;jump if n == 0

;------------------------------------------------------------------------------
; Register use in code below:
;
; rdi = y   rsi = x     rdx = m       rcx = n
; r8 = i    r9 = j      r10 = tempval rax = tempval
;------------------------------------------------------------------------------

; Initalize
        xor r8,r8                           ;i = 0

; Loop1 is outer for-loop, Loop2 is inner for-loop
Loop1:  xor r9,r9                           ;j = 0

; Calculate x[j][i] * x[j][i]
Loop2:  mov rax,r9                          ;rax = j
        imul rax,rdx                        ;rax = j * m
        add rax,r8                          ;rax = j * m + i (kx)

        mov r10d,[rsi+rax*4]                ;r10d = x[j][i]
        imul r10d,r10d                      ;r10d = x[j][i] * x[j][i]

; Set y[i][j] = x[j][i] * x[j][i]
        mov rax,r8                          ;rax = i
        imul rax,rcx                        ;rax = i * n
        add rax,r9                          ;rax = i * n + j (ky)

        mov [rdi+rax*4],r10d                ;save y[i][j]

; Update inner for-loop counter
        add r9,1                            ;j += 1
        cmp r9,rcx
        jb Loop2                            ;jump if j < n

; Update outer for-loop counter
        add r8,1                            ;i += 1
        cmp r8,rdx
        jb Loop1                            ;jump if i < m

InvalidSize:
        ret
