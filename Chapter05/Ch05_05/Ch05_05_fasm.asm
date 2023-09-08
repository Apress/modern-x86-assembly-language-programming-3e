;------------------------------------------------------------------------------
; Ch05_05_fasm.asm
;------------------------------------------------------------------------------

        include <cmpequ_fp.asmh>

;------------------------------------------------------------------------------
; void CompareF32_avx(uint8_t* cmp_results, float a, float b);
;------------------------------------------------------------------------------

        .code
CompareF32_avx proc

; Perform compare for equality
        vcmpss xmm5,xmm1,xmm2,CMP_EQ_OQ     ;perform compare operation
        vmovd eax,xmm5                      ;eax = compare result (all 1s or 0s)
        and al,1                            ;mask out unneeded bits
        mov [rcx],al                        ;save result

; Perform compare for inequality
        vcmpss xmm5,xmm1,xmm2,CMP_NEQ_OQ
        vmovd eax,xmm5
        and al,1
        mov [rcx+1],al

; Perform compare for less than
        vcmpss xmm5,xmm1,xmm2,CMP_LT_OQ
        vmovd eax,xmm5
        and al,1
        mov [rcx+2],al

; Perform compare for less than or equal
        vcmpss xmm5,xmm1,xmm2,CMP_LE_OQ
        vmovd eax,xmm5
        and al,1
        mov [rcx+3],al

; Perform compare for greater than
        vcmpss xmm5,xmm1,xmm2,CMP_GT_OQ
        vmovd eax,xmm5
        and al,1
        mov [rcx+4],al

; Perform compare for greater than or equal
        vcmpss xmm5,xmm1,xmm2,CMP_GE_OQ
        vmovd eax,xmm5
        and al,1
        mov [rcx+5],al

; Perform compare for ordered
        vcmpss xmm5,xmm1,xmm2,CMP_ORD_Q
        vmovd eax,xmm5
        and al,1
        mov [rcx+6],al

; Perform compare for unordered
        vcmpss xmm5,xmm1,xmm2,CMP_UNORD_Q
        vmovd eax,xmm5
        and al,1
        mov [rcx+7],al
        ret

CompareF32_avx endp
        end
