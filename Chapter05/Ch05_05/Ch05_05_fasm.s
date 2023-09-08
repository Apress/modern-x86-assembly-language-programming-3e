;------------------------------------------------------------------------------
; Ch05_05_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"
        %include "cmpequ_fp.inc"

;------------------------------------------------------------------------------
; void CompareF32_avx(uint8_t* cmp_results, float a, float b);
;------------------------------------------------------------------------------

        section .text

        global CompareF32_avx
CompareF32_avx:

; Perform compare for equality
        vcmpss xmm5,xmm0,xmm1,CMP_EQ_OQ     ;perform compare operation
        vmovd eax,xmm5                      ;eax = compare result (all 1s or 0s)
        and al,1                            ;mask out unneeded bits
        mov [rdi],al                        ;save result

; Perform compare for inequality
        vcmpss xmm5,xmm0,xmm1,CMP_NEQ_OQ
        vmovd eax,xmm5
        and al,1
        mov [rdi+1],al

; Perform compare for less than
        vcmpss xmm5,xmm0,xmm1,CMP_LT_OQ
        vmovd eax,xmm5
        and al,1
        mov [rdi+2],al

; Perform compare for less than or equal
        vcmpss xmm5,xmm0,xmm1,CMP_LE_OQ
        vmovd eax,xmm5
        and al,1
        mov [rdi+3],al

; Perform compare for greater than
        vcmpss xmm5,xmm0,xmm1,CMP_GT_OQ
        vmovd eax,xmm5
        and al,1
        mov [rdi+4],al

; Perform compare for greater than or equal
        vcmpss xmm5,xmm0,xmm1,CMP_GE_OQ
        vmovd eax,xmm5
        and al,1
        mov [rdi+5],al

; Perform compare for ordered
        vcmpss xmm5,xmm0,xmm1,CMP_ORD_Q
        vmovd eax,xmm5
        and al,1
        mov [rdi+6],al

; Perform compare for unordered
        vcmpss xmm5,xmm0,xmm1,CMP_UNORD_Q
        vmovd eax,xmm5
        and al,1
        mov [rdi+7],al
        ret
