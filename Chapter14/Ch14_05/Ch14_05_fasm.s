;------------------------------------------------------------------------------
; Ch14_05_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; void MatrixMulF32_avx512(float* c, const float* a, const float* b,
;   const size_t* sizes);
;------------------------------------------------------------------------------

NSE         equ 16                          ;num_simd_elements
NSE_MOD     equ 0fh                         ;mask to calculate num_residual_cols
SF          equ 4                           ;scale factor for F32 elements

        section .text

        global MatrixMulF32_avx512
MatrixMulF32_avx512:
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

; Calculate mask for residual column loads and stores
        mov r12,r14                             ;r12 = c_ncols
        and r12,NSE_MOD                         ;num_residual_cols = c_ncols % NSE
        mov r9,rcx                              ;save rcx
        mov rcx,r12                             ;rcx = num_residual_cols
        mov eax,1
        shl eax,cl                              ;eax = 2 ** num_residual_cols
        sub eax,1                               ;eax = 2 ** num_residual_cols - 1
        kmovb k1,eax                            ;k1 = mask for residual col load/store
        mov rcx,r9                              ;restore rcx

        mov rax,-1                              ;rax = i

;------------------------------------------------------------------------------
; General-purpose registers used in code below:
;
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
        lea rdx,[rdx+r15*SF]                    ;rdx = &a[i+1][0]
        xor r9,r9                               ;r9 = j

; Repeat while there are at least NSE columns in current row of c
        align 16
Loop2:  lea r11,[r9+NSE]                        ;r11 = j + NSE
        cmp r11,r14
        ja ChkRes                               ;jump if j + NSE > c_ncols

        mov rbx,rdi                             ;rbx = &a[i][0]
        lea rsi,[r8+r9*SF]                      ;rsi = &b[0][j]
        vxorps zmm2,zmm2,zmm2                   ;initialize packed c_vals
        mov r10,r15                             ;r10 = a_ncols

; Calculate c[i][j:j+NSE-1]
        align 16
Loop3a: vbroadcastss zmm0,[rbx]                 ;broadcast a[i][k]
        vfmadd231ps zmm2,zmm0,[rsi]             ;zmm2 += a[i][k] * b[k][j:j+NSE-1]

        add rbx,SF                              ;rbx = &a[i][k+1]
        lea rsi,[rsi+r14*SF]                    ;rsi = &b[k+1][j]
        sub r10,1                               ;k -= 1
        jnz Loop3a                              ;repeat until done

; Save c[i][j:j+NSE-1]
        vmovups [rcx],zmm2                      ;save c[i][j:j+NSE-1]

        add r9,NSE                              ;j += num_simd_elements
        add rcx,NSE*SF                          ;rcx = &c[i][j+NSE] (next group)
        jmp Loop2

ChkRes: test r12,r12                            ;num_residual_cols == 0?
        jz Loop1                                ;jump if yes

        mov rbx,rdi                             ;rbx = &a[i][0]
        lea rsi,[r8+r9*SF]                      ;rsi = &b[0][j]
        vxorps zmm2,zmm2,zmm2                   ;initialize packed c_vals
        mov r10,r15                             ;r10 = a_ncols

; Calculate c[i][j:j+NRC] (NRC is num_residual_cols)
        align 16
Loop3b: vbroadcastss zmm0,[rbx]                 ;broadcast a[i][k]
        vmovups zmm1{k1},[rsi]                  ;load b[k][j:j+NRC]
        vfmadd231ps zmm2,zmm0,zmm1              ;zmm2 += a[i][k] * b[k][j:j+NRC]

        add rbx,SF                              ;rbx = &a[i][k+1]
        lea rsi,[rsi+r14*SF]                    ;rsi = &b[k+1][j]
        sub r10,1                               ;k -= 1
        jnz Loop3b                              ;repeat until done

; Save c[i][j:j+NRC]
        vmovups [rcx]{k1},zmm2                  ;save c[i][j:j+NRC]
        lea rcx,[rcx+r12*SF]                    ;rcx = &c[i][j+NRC+1] (next group)
        jmp Loop1

Done:   vzeroupper
        pop r15
        pop r14
        pop r13
        pop r12
        pop rbx
        ret
