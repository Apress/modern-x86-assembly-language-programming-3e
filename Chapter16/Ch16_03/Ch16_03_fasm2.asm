;------------------------------------------------------------------------------
; Ch16_03_fasm2.asm
;------------------------------------------------------------------------------

        include <MacrosX86-64-AVX.asmh>

;------------------------------------------------------------------------------
; bool AbsImageNT_avx2(uint8_t* pb_des, const uint8_t* pb_src0,
;   const uint8_t * pb_src1, size_t num_pixels);
;------------------------------------------------------------------------------

NSE     equ 32                              ;num_simd_elements

        extern CheckArgs:proc

        .code
AbsImageNT_avx2 proc frame
        CreateFrame_M TI_,0,16,r12,r13,r14,r15
        SaveXmmRegs_M xmm15
        EndProlog_M

; Copy args to non-volatile registers
        mov r12,rcx                         ;pb_des
        mov r13,rdx                         ;pb_src0
        mov r14,r8                          ;pb_src1
        mov r15,r9                          ;num_pixels

; Validate arguments
        sub rsp,32                          ;allocate home area
        call CheckArgs
        or eax,eax                          ;arguments valid?
        jz Done                             ;jump if no

; Initialize
        vpxor ymm15,ymm15,ymm15             ;packed zeros
        mov rax,-NSE                        ;rax = array index i

; Calculate pb_des[i] = abs(pb_src0[i] - pb_src2[i])
Loop1:  add rax,NSE                         ;i += NSE
        vmovdqa ymm0,ymmword ptr [r13+rax]  ;load pb_src0[i:i+NSE-1]
        vmovdqa ymm1,ymmword ptr [r14+rax]  ;load pb_src1[i:i+NSE-1]

        vpunpcklbw ymm2,ymm0,ymm15          ;convert pb_src0 to words
        vpunpckhbw ymm3,ymm0,ymm15
        vpunpcklbw ymm4,ymm1,ymm15          ;convert pb_src1 to words
        vpunpckhbw ymm5,ymm1,ymm15

        vpsubw ymm0,ymm2,ymm4               ;calc pb_src0 - pb_src1
        vpsubw ymm1,ymm3,ymm5
        vpabsw ymm0,ymm0                    ;calc abs(pb_src0 - pb_src1)
        vpabsw ymm1,ymm1
        vpackuswb ymm2,ymm0,ymm1            ;convert result to bytes

        vmovntdq ymmword ptr [r12+rax],ymm2 ;save pb_des[i:i+NSE-1]

        sub r15,NSE                         ;num_pixels -= NSE
        jnz Loop1                           ;jump if not done

        mov eax,1                           ;set success return code

Done:   vzeroupper
        RestoreXmmRegs_M xmm15
        DeleteFrame_M r12,r13,r14,r15
        ret

AbsImageNT_avx2 endp
        end
