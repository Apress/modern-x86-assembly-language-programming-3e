;------------------------------------------------------------------------------
; Ch17_01_fasm.asm
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; bool CalcResult_avx(double* y, const double* x, size_t n);
;------------------------------------------------------------------------------

NSE     equ         8                           ;num_simd_elements

        .const
F64_2p0  real8 2.0

        .code
CalcResult_avx proc

; Forward conditional jumps are used in this code block since
; the fall-through cases are more likely to occur
        test r8,r8
        jz Error                                ;jump if n == 0
        test r8,07h
        jnz Error                               ;jump if (n % NSE) != 0
        test rcx,1fh
        jnz Error                               ;jump if y not 32-byte aligned
        test rdx,1fh
        jnz Error                               ;jump if x not 32-byte aligned

; Initialize
        mov rax,-NSE*8                          ;rax = common array offset
        vbroadcastsd ymm5,[F64_2p0]             ;packed 2.0

; Simple array processing loop
        align 16
Loop1:  add rax,NSE*8                           ;update offset for x[] and y[]

        vmovapd ymm0,ymmword ptr [rdx+rax]      ;load x[i:i+3]
        vdivpd ymm1,ymm0,ymm5
        vsqrtpd ymm2,ymm1
        vmovapd ymmword ptr [rcx+rax],ymm2      ;save y[i:i+3]

        vmovapd ymm0,ymmword ptr [rdx+rax+32]   ;load x[i+4:i+7]
        vdivpd ymm1,ymm0,ymm5
        vsqrtpd ymm2,ymm1
        vmovapd ymmword ptr [rcx+rax+32],ymm2   ;save y[i+4:i+7]

; A backward conditional jump is used in this code block since
; the fall-through case is less likely to occur
        sub r8,NSE
        jnz Loop1

        mov eax,1                              ;set success return code
        vzeroupper
        ret

; Error handling code that's unlikely to execute
Error:  xor eax,eax                            ;set error return code
        ret
CalcResult_avx endp
        end
