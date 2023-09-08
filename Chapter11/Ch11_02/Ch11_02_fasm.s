;------------------------------------------------------------------------------
; Ch11_02_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

; Data for vmaskmovps masks

            section .rdata
MaskMovLUT  equ $
mask0       dd 8 dup(0)
mask1       dd 1 dup(80000000h), 7 dup(0)
mask2       dd 2 dup(80000000h), 6 dup(0)
mask3       dd 3 dup(80000000h), 5 dup(0)
mask4       dd 4 dup(80000000h), 4 dup(0)
mask5       dd 5 dup(80000000h), 3 dup(0)
mask6       dd 6 dup(80000000h), 2 dup(0)
mask7       dd 7 dup(80000000h), 1 dup(0)

;------------------------------------------------------------------------------
; void MatrixMulF32_Aavx2(float* c, const float* a, const float* b,
;   const size_t* sizes);
;------------------------------------------------------------------------------

NSE         equ 8                           ;num_simd_elements
NSE_MOD     equ 07h                         ;mask to calculate num_residual_cols
SIZE_F32    equ 4                           ;size in bytes of float

        section .text

        global MatrixMulF32_avx2
MatrixMulF32_avx2:
        push rbx
        push r12
        push r13
        push r14
        push r15

; Re-arrange argument registers
        mov r9,rcx
        mov r8,rdx
        mov rdx,rsi
        mov rcx,rdi

; Load matrix sizes
        mov r13,[r9]                            ;r13 = c_nrows
        mov r14,[r9+8]                          ;r14 = c_ncols (also b_ncols)
        mov r15,[r9+16]                         ;r15 = a_ncols

; Load mask for vmaskmovps instruction
        mov r12,r14                             ;r12 = c_ncols
        and r12,NSE_MOD                         ;num_residual_cols = c_ncols % NSE

        mov rax,r12                             ;rax = num_residual_cols
        shl rax,5                               ;rax = num_residual_cols * 32
        lea r11,[MaskMovLUT]                    ;r11 = address of MaskMovLUT
        add rax,r11                             ;rax = address of maskX
        vmovdqu ymm5,[rax]                      ;ymm5 = maskX for vmaskmovps

        mov rax,-1                              ;rax = i

;------------------------------------------------------------------------------
; General-purpose registers used in code below
;   rax     i                                       r9      j
;   rbx     matrix a element pointer (p_aa)         r10     k
;   rcx     matrix c                                r11     scratch
;   rdx     matrix a                                r12     num_residual_cols
;   rsi     matrix b element pointer (p_bb)         r13     c_nrows
;   rdi     &a[i][0]                                r15     a_ncols
;   r8      matrix b
;------------------------------------------------------------------------------

; Repeat for each row in c
        align 16
Loop1:  add rax,1                               ;i += 1
        cmp rax,r13
        jae Done                                ;jump if i >= c_nrows

        mov rdi,rdx                             ;rdi = &a[i][0]
        lea rdx,[rdx+r15*SIZE_F32]              ;rdx = &a[i+1][0]
        xor r9,r9                               ;r9 = j

; Repeat while there are at least NSE columns in current row of c
        align 16
Loop2:  lea r11,[r9+NSE]                        ;r11 = j + NSE
        cmp r11,r14
        ja ChkRes                               ;jump if j + NSE > c_ncols

        mov rbx,rdi                             ;rbx = &a[i][0]
        lea rsi,[r8+r9*SIZE_F32]                ;rsi = &b[0][j]
        vxorps ymm2,ymm2,ymm2                   ;initialize packed c_vals
        mov r10,r15                             ;r10 = a_ncols

; Calculate c[i][j:j+7]
        align 16
Loop3a: vbroadcastss ymm0,[rbx]                 ;broadcast a[i][k]
        vfmadd231ps ymm2,ymm0,[rsi]             ;ymm2 += a[i][k] * b[k][j:j+7]

        add rbx,SIZE_F32                        ;rbx = &a[i][k+1]
        lea rsi,[rsi+r14*SIZE_F32]              ;rsi = &b[k+1][j]
        sub r10,1                               ;k -= 1
        jnz Loop3a                              ;repeat until done

; Save c[i][j:j+7]
        vmovups[rcx],ymm2                       ;save c[i][j:j+7]

        add r9,NSE                              ;j += num_simd_elements
        add rcx,NSE*SIZE_F32                    ;rcx = &c[i][j+8] (next SIMD group)
        jmp Loop2

ChkRes: test r12,r12                            ;num_residual_cols == 0?
        jz Loop1                                ;jump if yes

        mov rbx,rdi                             ;rbx = &a[i][0]
        lea rsi,[r8+r9*SIZE_F32]                ;rsi = &b[0][j]
        vxorps ymm2,ymm2,ymm2                   ;initialize packed c_vals
        mov r10,r15                             ;r10 = a_ncols

; Calculate c[i][j:j+NRC] (NRC is num_residual_cols)
        align 16
Loop3b: vbroadcastss ymm0,[rbx]                 ;broadcast a[i][k]
        vmaskmovps ymm1,ymm5,[rsi]              ;load b[k][j:j+NRC]
        vfmadd231ps ymm2,ymm1,ymm0              ;update product sums

        add rbx,SIZE_F32                        ;rbx = &a[i][k+1]
        lea rsi,[rsi+r14*SIZE_F32]              ;rsi = &b[k+1][j]
        sub r10,1                               ;k -= 1
        jnz Loop3b                              ;repeat until done

; Save c[i][j:j+NRC]
        vmaskmovps [rcx],ymm5,ymm2              ;save c[i][j:j+NRC]
        lea rcx,[rcx+r12*SIZE_F32]              ;rcx = &c[i][j+NRC+1] (next SIMD group)
        jmp Loop1

Done:   vzeroupper
        pop r15
        pop r14
        pop r13
        pop r12
        pop rbx
        ret
