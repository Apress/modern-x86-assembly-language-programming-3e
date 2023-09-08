;------------------------------------------------------------------------------
; Ch08_06_fasm.asm
;------------------------------------------------------------------------------

        include <MacrosX86-64-AVX.asmh>

;------------------------------------------------------------------------------
; bool CalcMeanU8_avx(double* mean_x, uint64_t* sum_x, const uint8_t* x,
;   uint32_t n);
;------------------------------------------------------------------------------

NSE     equ 64                              ;num pixels per iteration of Loop1

        .code
CalcMeanU8_avx proc frame

; Prologue
        CreateFrame_M MeanU8_,0,16
        SaveXmmRegs_M xmm15
        EndProlog_M

; Make sure n and x are valid
        test r9d,r9d                        ;is n <= 0?
        jz BadArg                           ;jump if yes

        test r9d,3fh                        ;is n even multiple of 64?
        jnz BadArg                          ;jump if no

        test r8,0fh                         ;is x aligned on a 16-byte boundary?
        jnz BadArg                          ;jump if no

; Initialize
        vpxor xmm5,xmm5,xmm5                ;packed sums (2 qwords)
        vpxor xmm15,xmm15,xmm15             ;packed zero for size promotions
        mov r10d,r9d                        ;r10d = n (for use in Loop1)
        sub r8,NSE                          ;adjust x for Loop1

; Calculate sum of all pixels
Loop1:  add r8,NSE                          ;r8 = &x[i]
        vpxor xmm0,xmm0,xmm0                ;initialize loop packed sums (16 words)
        vpxor xmm1,xmm1,xmm1

        vmovdqa xmm2,xmmword ptr [r8]       ;load pixel block x[i:i+15]
        vpunpcklbw xmm3,xmm2,xmm15          ;promote x[i:i+7] to words
        vpaddw xmm0,xmm0,xmm3               ;update sums[0:7]
        vpunpckhbw xmm4,xmm2,xmm15          ;promote x[i+8:i+15] to words
        vpaddw xmm1,xmm1,xmm4               ;update sums[8:15]

        vmovdqa xmm2,xmmword ptr [r8+16]    ;load pixel block x[i+16:i+31]
        vpunpcklbw xmm3,xmm2,xmm15          ;promote x[i+16:i+23] to words
        vpaddw xmm0,xmm0,xmm3               ;update sums[0:7]
        vpunpckhbw xmm4,xmm2,xmm15          ;promote x[i+24:i+31] to words
        vpaddw xmm1,xmm1,xmm4               ;update sums[8:15]

        vmovdqa xmm2,xmmword ptr [r8+32]    ;load pixel block x[i+32:i+47]
        vpunpcklbw xmm3,xmm2,xmm15          ;promote x[i+32:i+39] to words
        vpaddw xmm0,xmm0,xmm3               ;update sums[0:7]
        vpunpckhbw xmm4,xmm2,xmm15          ;promote x[i+40:i+47] to words
        vpaddw xmm1,xmm1,xmm4               ;update sums[8:15]

        vmovdqa xmm2,xmmword ptr [r8+48]    ;load pixel block x[i+48:i+63]
        vpunpcklbw xmm3,xmm2,xmm15          ;promote x[i+48:i+55] to words
        vpaddw xmm0,xmm0,xmm3               ;update sums[0:7]
        vpunpckhbw xmm4,xmm2,xmm15          ;promote x[i+56:i+63] to words
        vpaddw xmm1,xmm1,xmm4               ;update sums[8:15]

        vpaddw xmm0,xmm0,xmm1               ;loop packed sums (8 words)
        vpunpcklwd xmm1,xmm0,xmm15          ;promote loop packed sums to dwords
        vpunpckhwd xmm2,xmm0,xmm15
        vpaddd xmm3,xmm1,xmm2               ;loop packed sums (4 dwords)

        vpunpckldq xmm0,xmm3,xmm15          ;promote loop packed sums to qwords
        vpunpckhdq xmm1,xmm3,xmm15
        vpaddq xmm5,xmm5,xmm0               ;update packed sums (2 qwords)                   
        vpaddq xmm5,xmm5,xmm1

        sub r10d,NSE                        ;n -= NSE
        jnz Loop1                           ;repeat until done

; Reduce packed sums (2 qwords) to single qword
        vpextrq rax,xmm5,0                  ;rax = xmm5[63:0]
        vpextrq r10,xmm5,1                  ;r10 = xmm5[127:64]
        add rax,r10                         ;rax = final pixel sum
        mov qword ptr [rdx],rax             ;save final pixel sum

; Calculate mean
        vcvtsi2sd xmm0,xmm0,rax             ;convert sum to DPFP
        vcvtsi2sd xmm1,xmm1,r9d             ;convert n to DPFP
        vdivsd xmm2,xmm0,xmm1               ;mean = sum / n
        vmovsd real8 ptr [rcx],xmm2         ;save mean

        mov eax,1                           ;set success return code

; Epilogue
Done:   RestoreXmmRegs_M xmm15
        DeleteFrame_M
        ret

BadArg: xor eax,eax                         ;set error return code
        jmp Done

CalcMeanU8_avx endp
        end
