;------------------------------------------------------------------------------
; Ch13_03_fasm.asm
;------------------------------------------------------------------------------

        include <cmpequ_int.asmh>

NSE     equ     64                              ;num_simd_elements

;------------------------------------------------------------------------------
; Macro PixelCmp_M
;------------------------------------------------------------------------------

PixelCmp_M macro CmpOp
        align 16
@@:     add rax,NSE                             ;i += NSE
        vmovdqa64 zmm2,zmmword ptr [rdx+rax]    ;load src[i:i+63]
        vpcmpub k1,zmm2,zmm1,CmpOp              ;packed compare using CmpOp
        vmovdqu8 zmm3{k1}{z},zmm0               ;create pixel mask
        vmovdqa64 zmmword ptr [rcx+rax],zmm3    ;save des[i:i+63]
        sub r8,NSE                              ;num_pixels -= NSE
        jnz @B                                  ;repeat until done
        jmp Done
        endm

;------------------------------------------------------------------------------
; void ComparePixels_avx512(uint8_t* des, const uint8_t* src, size_t num_pixels,
;   CmpOp cmp_op, uint8_t cmp_val);
;------------------------------------------------------------------------------

        .code
ComparePixels_avx512 proc

; Validate arguments
        mov eax,1                           ;load error return code

        test r8,r8
        jz Done                             ;jump if num_pixels == 0

        test r8,3fh
        jnz Done                            ;jump if num_pixels % 64 != 0

        test rcx,3fh
        jnz Done                            ;jump if des not 64b aligned

        test rdx,3fh
        jnz Done                            ;jump if src not 64b aligned

        cmp r9,CmpOpTableCount
        jae Done                            ;jump if cmp_op is invalid

; Initialize
        mov eax,0ffh
        vpbroadcastb zmm0,eax               ;zmm0 = packed 0xff
        vpbroadcastb zmm1,byte ptr [rsp+40] ;zmm1 = packed cmp_val
        mov rax,-NSE                        ;i = -NSE

; Jump to target compare code
        lea r10,[CmpOpTable]                ;r10 = address of CmpOpTable
        mov r11,[r10+r9*8]                  ;r11 = address of compare code block
        jmp r11                             ;jump to specified compare code block

; Compare code blocks using macro PixelCmp_M
CmpEQ:  PixelCmp_M CMP_EQ
CmpNE:  PixelCmp_M CMP_NEQ
CmpLT:  PixelCmp_M CMP_LT
CmpLE:  PixelCmp_M CMP_LE
CmpGT:  PixelCmp_M CMP_GT
CmpGE:  PixelCmp_M CMP_GE

Done:   vzeroupper
        ret

; The order of values in following table must match enum CmpOp
; that's defined in Ch03_03.h.

        align 8
CmpOpTable equ $
        qword CmpEQ
        qword CmpNE
        qword CmpLT
        qword CmpLE
        qword CmpGT
        qword CmpGE
CmpOpTableCount equ ($ - CmpOpTable) / size qword

ComparePixels_avx512 endp
        end
