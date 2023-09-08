;------------------------------------------------------------------------------
; Ch10_05_fasm.asm
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; void ConvertU8ToF32_avx2(float* pb_des, const uint8_t* pb_src,
;   size_t num_pixels);
;------------------------------------------------------------------------------

NSE     equ 32                              ;num_simd_elements

        extern g_LUT_U8ToF32:qword

        .code
ConvertU8ToF32_avx2 proc

; Validate arguments
        test r8,r8
        jz Done                                 ;jump if num_pixels == 0

        test rcx,1fh
        jnz Done                                ;jump if pb_des not 32b aligned
        test rdx,1fh
        jnz Done                                ;jump if pb_src not 32b aligned

; Initialize
        lea r9,qword ptr [g_LUT_U8ToF32]        ;r9 = pointer to LUT
        vpcmpeqb ymm5,ymm5,ymm5                 ;ymm5 = all ones

        mov rax,-1                              ;rax = index (i) for Loop2
        cmp r8,NSE                              ;num_pixels >= NSE?
        jb Loop2                                ;jump if no
        mov rax,-NSE                            ;rax = index (i) for Loop1

; Convert pixels from U8 to F32 using LUT and gather operations
Loop1:  add rax,NSE                             ;i += NSE
        vpmovzxbd ymm0,qword ptr [rdx+rax]      ;ymm0 = pb_src[i:i+7] (U32)
        vmovdqa ymm1,ymm5                       ;ymm1 = vgatherdps load mask
        vgatherdps ymm2,[r9+ymm0*4],ymm1        ;ymm2 = pb_src[i:i+7] (F32)
        vmovaps ymmword ptr [rcx+rax*4],ymm2    ;save pb_des[i:i+7]

        vpmovzxbd ymm0,qword ptr [rdx+rax+8]    ;ymm0 = pb_src[i+8:i+15] (U32)
        vmovdqa ymm1,ymm5                       ;ymm1 = vgatherdps load mask
        vgatherdps ymm2,[r9+ymm0*4],ymm1        ;ymm2 = pb_src[i_8:i+15] (F32)
        vmovaps ymmword ptr [rcx+rax*4+32],ymm2 ;save pb_des[i+8:i+15]

        vpmovzxbd ymm0,qword ptr [rdx+rax+16]   ;ymm0 = pb_src[i+16:i+23] (U32)
        vmovdqa ymm1,ymm5                       ;ymm1 = vgatherdps load mask
        vgatherdps ymm2,[r9+ymm0*4],ymm1        ;ymm2 = pb_src[i+16:i+23] (F32)
        vmovaps ymmword ptr [rcx+rax*4+64],ymm2 ;save pb_des[i+16:i+23]

        vpmovzxbd ymm0,qword ptr [rdx+rax+24]   ;ymm0 = pb_src[i+24:i+31] (U32)
        vmovdqa ymm1,ymm5                       ;ymm1 = vgatherdps load mask
        vgatherdps ymm2,[r9+ymm0*4],ymm1        ;ymm2 = pb_src[i+24:i+31] (F32)
        vmovaps ymmword ptr [rcx+rax*4+96],ymm2 ;save pb_des[i+24:i+31]

        sub r8,NSE                              ;num_pixels -= NSE
        cmp r8,NSE                              ;num_pixels >= NSE?
        jae Loop1                               ;jump if yes

; Convert any residual pixels using scalar instructions
        test r8,r8                              ;num_pixels == 0?
        jz Done                                 ;jump if yes
        add rax,NSE-1                           ;adjust i for Loop2

Loop2:  add rax,1                               ;i += 1
        movzx r10,byte ptr [rdx+rax]            ;load pb_src[i]
        vmovss xmm0,real4 ptr [r9+r10*4]        ;convert to F32 using LUT
        vmovss real4 ptr [rcx+rax*4],xmm0       ;save pb_des[i]

        sub r8,1                                ;num_pixels -= 1
        jnz Loop2                               ;jump if num_pixels != 0

Done:   vzeroupper
        ret
ConvertU8ToF32_avx2 endp
        end
