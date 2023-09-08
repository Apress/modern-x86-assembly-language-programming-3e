;------------------------------------------------------------------------------
; Ch13_03_fasm.asm
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"
        %include "cmpequ_int.asmh"

NSE     equ     64                              ;num_simd_elements

;------------------------------------------------------------------------------
; Macro PixelCmp_M
;------------------------------------------------------------------------------

%macro  PixelCmp_M 1
        align 16
%%L1:   add rax,NSE                         ;i += NSE
        vmovdqa64 zmm2,[rsi+rax]            ;load src[i:i+63]
        vpcmpub k1,zmm2,zmm1,%1             ;packed compare using CmpOp
        vmovdqu8 zmm3{k1}{z},zmm0           ;create pixel mask
        vmovdqa64 [rdi+rax],zmm3            ;save des[i:i+63]
        sub rdx,NSE                         ;num_pixels -= NSE
        jnz %%L1                            ;repeat until done
        jmp Done
%endmacro

;------------------------------------------------------------------------------
; void ComparePixels_avx512(uint8_t* des, const uint8_t* src, size_t num_pixels,
;   CmpOp cmp_op, uint8_t cmp_val);
;------------------------------------------------------------------------------

        section .text

        global ComparePixels_avx512
ComparePixels_avx512:

; Validate arguments
        mov eax,1                           ;load error return code

        test rdx,rdx
        jz Done                             ;jump if num_pixels == 0

        test rdx,3fh
        jnz Done                            ;jump if num_pixels % 64 != 0

        test rdi,3fh
        jnz Done                            ;jump if des not 64b aligned

        test rsi,3fh
        jnz Done                            ;jump if src not 64b aligned

        cmp rcx,CmpOpTableCount
        jae Done                            ;jump if cmp_op is invalid

; Initialize
        mov eax,0ffh
        vpbroadcastb zmm0,eax               ;zmm0 = packed 0xff
        vpbroadcastb zmm1,r8b               ;zmm1 = packed cmp_val
        mov rax,-NSE                        ;i = -NSE

; Jump to target compare code
        lea r10,[CmpOpTable]                ;r10 = address of CmpOpTable
        mov r11,[r10+rcx*8]                 ;r11 = address of compare code block
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

        section .data align = 8
CmpOpTable equ $
        dq CmpEQ
        dq CmpNE
        dq CmpLT
        dq CmpLE
        dq CmpGT
        dq CmpGE
CmpOpTableCount equ ($ - CmpOpTable) / 8
