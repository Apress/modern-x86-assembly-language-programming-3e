;------------------------------------------------------------------------------
; Example1_fasm.asm
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; void CalcZ_avx(float* z, const float* x, const float* x, size_t n);
;------------------------------------------------------------------------------

NSE     equ 8                                   ;num_simd_elements
SF      equ 4                                   ;scale factor for F32

        .code
CalcZ_avx proc

; Validate arguments
        test r9,r9                              ;n == 0?
        jz Done                                 ;jump if yes

; Initialize
        mov rax,-SF                             ;rax = array offset (Loop2)
        cmp r9,NSE                              ;n < NSE?
        jb Loop2                                ;jump if yes
        mov rax,-NSE*SF                         ;rax = array offset (Loop1)

; Calculate z[i:i+7] = x[i:i+7] + y[i:i+7]
Loop1:  add rax,NSE*SF                          ;update array offset
        vmovups ymm0,ymmword ptr [rdx+rax]      ;ymm0 = x[i:i+7]
        vmovups ymm1,ymmword ptr [r8+rax]       ;ymm1 = y[i:i+7]
        vaddps ymm2,ymm0,ymm1                   ;z[i:i+7] = x[i:i+7] + y[i:i+7]
        vmovups ymmword ptr [rcx+rax],ymm2      ;save z[i:i+7]

        sub r9,NSE                              ;n -= NSE
        cmp r9,NSE                              ;n >= NSE?
        jae Loop1                               ;jump if yes

        test r9,r9                              ;n == 0?
        jz Done                                 ;jump if yes
        add rax,NSE*SF-SF                       ;adjust array offset for Loop2

; Calculate z[i] = x[i] + y[i] for remaining elements
Loop2:  add rax,SF                              ;update array offset
        vmovss xmm0,real4 ptr [rdx+rax]         ;xmm0 = x[i]
        vmovss xmm1,real4 ptr [r8+rax]          ;xmm1 = y[i]
        vaddss xmm2,xmm0,xmm1                   ;z[i] = x[i] + y[i]
        vmovss real4 ptr [rcx+rax],xmm2         ;save z[i]

        sub r9,1                                ;n -= 1
        jnz Loop2                               ;repeat until done

Done:   vzeroupper
        ret                                     ;return to caller
CalcZ_avx endp
        end
