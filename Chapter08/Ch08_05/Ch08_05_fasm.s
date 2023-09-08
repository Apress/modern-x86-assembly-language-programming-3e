;------------------------------------------------------------------------------
; Ch08_05.fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; bool CalcMinMaxU8_avx(uint8_t* x_min, uint8_t* x_max,
;   const uint8_t* x, size_t n);
;------------------------------------------------------------------------------

NSE     equ 16                              ;num_simd_elements
                                            ;(num pixels per iteration of Loop1)

        section .text

        global CalcMinMaxU8_avx
CalcMinMaxU8_avx:

; Make sure n and x are valid
        test rcx,rcx                        ;is n == 0?
        jz BadArg                           ;jump if yes

        test rcx,0fh                        ;is n even multiple of 16?
        jnz BadArg                          ;jump if no

        test rdx,0fh                        ;is x aligned to 16b boundary?
        jnz BadArg                          ;jump if no

; Initialize packed min and max values
        vpcmpeqb xmm4,xmm4,xmm4             ;packed minimums (all 0xff)
        vpxor xmm5,xmm5,xmm5                ;packed maximums (all 0x00)
        sub rdx,NSE                         ;adjust rdx for Loop1

; Find packed min-max values in x[]
Loop1:  add rdx,NSE                         ;rdx points to x[i:i+NSE-1]
        vmovdqa xmm0,[rdx]                  ;xmm0 = block of 16 pixels
        vpminub xmm4,xmm4,xmm0              ;update packed min values
        vpmaxub xmm5,xmm5,xmm0              ;update packed max values

        sub rcx,NSE                         ;n -= NSE
        jnz Loop1                           ;repeat until done

; Reduce packed min values
        vpsrldq xmm0,xmm4,8
        vpminub xmm0,xmm0,xmm4              ;xmm0[63:0] = final 8 min vals
        vpsrldq xmm1,xmm0,4
        vpminub xmm1,xmm0,xmm1              ;xmm1[31:0] = final 4 min vals
        vpsrldq xmm2,xmm1,2
        vpminub xmm2,xmm2,xmm1              ;xmm2[15:0] = final 2 min vals
        vpsrldq xmm3,xmm2,1
        vpminub xmm3,xmm3,xmm2              ;xmm3[7:0] = final min val
        vpextrb [rdi],xmm3,0                ;save final min val

; Reduce packed max values
        vpsrldq xmm0,xmm5,8
        vpmaxub xmm0,xmm0,xmm5              ;xmm0[63:0] = final 8 max vals
        vpsrldq xmm1,xmm0,4
        vpmaxub xmm1,xmm0,xmm1              ;xmm1[31:0] = final 4 max vals
        vpsrldq xmm2,xmm1,2
        vpmaxub xmm2,xmm2,xmm1              ;xmm2[15:0] = final 2 max vals
        vpsrldq xmm3,xmm2,1
        vpmaxub xmm3,xmm3,xmm2              ;xmm3[7:0] = final max val
        vpextrb [rsi],xmm3,0                ;save final max val

        mov eax,1                           ;set success return code
        ret

BadArg: xor eax,eax                         ;set error return code
        ret
