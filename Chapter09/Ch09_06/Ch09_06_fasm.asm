;------------------------------------------------------------------------------
; Ch09_06_fasm.asm
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; void CalcColMeansF64_avx(double* col_means, const double* x,
;   size_t nrows, size_t ncols);
;------------------------------------------------------------------------------

NSE     equ 4                               ;num_simd_elements
NSE2    equ 2                               ;num_simd_elements2

        .code
CalcColMeansF64_avx proc frame

; Function prologue
        push rsi
        .pushreg rsi
        push rdi
        .pushreg rdi
        .endprolog

; Validate nrows and ncols
        test r8,r8
        jz Done                             ;jump if nrows == 0
        test r9,r9
        jz Done                             ;jump if ncols == 0

; Initialize all elements in col_means to 0.0
        mov r10,rcx                         ;save col_means for later
        mov rdi,rcx                         ;rdi = col_means
        mov rcx,r9                          ;number of elements in ncol_means
        xor eax,eax                         ;rax = fill value
        rep stosq                           ;fill col_means with 0

;------------------------------------------------------------------------------
; Registers used in code below:
;
; rsi = &x[i][j]            r8  = nrows       rax = scratch register
; rcx = &x[0][0]            r9  = ncols
; rdx = &col_means[j]       r10 = i
; rdi = &col_means[0]       r11 = j
;------------------------------------------------------------------------------

; Initialize
        mov rcx,rdx                         ;rcx = &x[0][0]
        mov rdi,r10                         ;rdi = &col_means[0]
        xor r10,r10                         ;i = 0

; Repeat Loop1 while i < nrows
Loop1:  cmp r10,r8
        jae CalcCM                          ;jump if i >= nrows

        xor r11,r11                         ;j = 0

; Repeat Loop2 while j < ncols
Loop2:  cmp r11,r9
        jb F1                               ;jump if j < ncols

        add r10,1                           ;i += 1
        jmp Loop1

; Calculate &x[i][j] and &col_means[j]
F1:     mov rax,r10                         ;rax = i
        mul r9                              ;rax = i * ncols
        add rax,r11                         ;rax = i * ncols + j
        lea rsi,[rcx+rax*8]                 ;rsi = &x[i][j]
        lea rdx,[rdi+r11*8]                 ;rdx = &col_means[j]

        mov rax,r11                         ;rax = j
        add rax,NSE                         ;rax = j + NSE
        cmp rax,r9
        ja F2                               ;jump if j + NSE > ncols

; Update sums (4 columns)
        vmovupd ymm0,ymmword ptr [rdx]      ;ymm0 = col_means[j:j+3]
        vaddpd ymm1,ymm0,[rsi]              ;col_means[j:j+3] += x[i][j:j+3]
        vmovupd ymmword ptr [rdx],ymm1      ;save result

        add r11,NSE                         ;j += NSE
        jmp Loop2

F2:     mov rax,r11                         ;rax = j
        add rax,NSE2                        ;rax = j + NSE2
        cmp rax,r9
        ja F3                               ;jump if j + NSE2 > ncols

; Update sums (2 columns)
        vmovupd xmm0,xmmword ptr [rdx]      ;xmm0 = col_means[j:j+1]
        vaddpd xmm1,xmm0,[rsi]              ;col_means[j:j+1] += x[i][j:j+1]
        vmovupd xmmword ptr [rdx],xmm1      ;save result

        add r11,NSE2                        ;j += NSE2
        jmp Loop2

; Update sums (1 column)
F3:     vmovsd xmm0,real8 ptr [rdx]         ;xmm0 = col_means[j]
        vaddsd xmm1,xmm0,real8 ptr [rsi]    ;col_means[j] += x[i][j]
        vmovsd real8 ptr [rdx],xmm1         ;save result

        add r11,1                           ;j += 1
        jmp Loop2

; Calculate column means
CalcCM: mov rax,-1                          ;j = -1
        vcvtsi2sd xmm2,xmm2,r8              ;xmm2 = nrows (DPFP)

Loop3:  add rax,1                           ;j += 1
        vmovsd xmm0,real8 ptr [rdi+rax*8]   ;col_means[j]
        vdivsd xmm1,xmm0,xmm2               ;mean = col_means[j] / nrows
        vmovsd real8 ptr [rdi+rax*8],xmm1   ;save result

        sub r9,1                            ;ncols -= 1
        jnz Loop3                           ;repeat until done

Done:   vzeroupper
        pop rdi
        pop rsi
        ret
CalcColMeansF64_avx endp
        end
