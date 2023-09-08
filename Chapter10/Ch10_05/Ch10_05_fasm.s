;------------------------------------------------------------------------------
; Ch10_05_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; void ConvertU8ToF32_avx2(float* pb_des, const uint8_t* pb_src,
;   size_t num_pixels);
;------------------------------------------------------------------------------

NSE     equ 32                                  ;num_simd_elements

        section .text
        extern g_LUT_U8ToF32

        global ConvertU8ToF32_avx2
ConvertU8ToF32_avx2:

; Validate arguments
        test rdx,rdx
        jz Done                                 ;jump if num_pixels == 0

        test rdi,1fh
        jnz Done                                ;jump if pb_des not 32b aligned
        test rsi,1fh
        jnz Done                                ;jump if pb_src not 32b aligned

; Initialize
        lea r9,[g_LUT_U8ToF32]                  ;r9 = pointer to LUT
        vpcmpeqb ymm5,ymm5,ymm5                 ;ymm5 = all ones

        mov rax,-1                              ;rax = index (i) for Loop2
        cmp rdx,NSE                             ;num_pixels >= NSE?
        jb Loop2                                ;jump if no
        mov rax,-NSE                            ;rax = index (i) for Loop1

; Convert pixels from U8 to F32 using LUT and gather operations
Loop1:  add rax,NSE                             ;i += NSE
        vpmovzxbd ymm0,[rsi+rax]                ;ymm0 = pb_src[i:i+7] (U32)
        vmovdqa ymm1,ymm5                       ;ymm1 = vgatherdps load mask
        vgatherdps ymm2,[r9+ymm0*4],ymm1        ;ymm2 = pb_src[i:i+7] (F32)
        vmovaps [rdi+rax*4],ymm2                ;save pb_des[i:i+7]

        vpmovzxbd ymm0,[rsi+rax+8]              ;ymm0 = pb_src[i+8:i+15] (U32)
        vmovdqa ymm1,ymm5                       ;ymm1 = vgatherdps load mask
        vgatherdps ymm2,[r9+ymm0*4],ymm1        ;ymm2 = pb_src[i_8:i+15] (F32)
        vmovaps [rdi+rax*4+32],ymm2             ;save pb_des[i+8:i+15]

        vpmovzxbd ymm0,[rsi+rax+16]             ;ymm0 = pb_src[i+16:i+23] (U32)
        vmovdqa ymm1,ymm5                       ;ymm1 = vgatherdps load mask
        vgatherdps ymm2,[r9+ymm0*4],ymm1        ;ymm2 = pb_src[i+16:i+23] (F32)
        vmovaps [rdi+rax*4+64],ymm2             ;save pb_des[i+16:i+23]

        vpmovzxbd ymm0,[rsi+rax+24]             ;ymm0 = pb_src[i+24:i+31] (U32)
        vmovdqa ymm1,ymm5                       ;ymm1 = vgatherdps load mask
        vgatherdps ymm2,[r9+ymm0*4],ymm1        ;ymm2 = pb_src[i+24:i+31] (F32)
        vmovaps [rdi+rax*4+96],ymm2             ;save pb_des[i+24:i+31]

        sub rdx,NSE                             ;num_pixels -= NSE
        cmp rdx,NSE                             ;num_pixels >= NSE?
        jae Loop1                               ;jump if yes

; Convert any residual pixels using scalar instructions
        test rdx,rdx                            ;num_pixels == 0?
        jz Done                                 ;jump if yes
        add rax,NSE-1                           ;adjust i for Loop2

Loop2:  add rax,1                               ;i += 1
        movzx r10,byte [rsi+rax]                ;load pb_src[i]
        vmovss xmm0,[r9+r10*4]                  ;convert to F32 using LUT
        vmovss [rdi+rax*4],xmm0                 ;save pb_des[i]

        sub rdx,1                               ;num_pixels -= 1
        jnz Loop2                               ;jump if num_pixels != 0

Done:   vzeroupper
        ret
