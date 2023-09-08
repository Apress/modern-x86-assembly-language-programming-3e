;------------------------------------------------------------------------------
; Ch09_02 fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"
        %include "cmpequ_fp.inc"

;------------------------------------------------------------------------------
; void PackedCompareF32_avx(YmmVal* c, const YmmVal* a, const YmmVal* b);
;------------------------------------------------------------------------------

        section .text

        global PackedCompareF32_avx
PackedCompareF32_avx:
        vmovaps ymm0,[rsi]                  ;ymm0 = a
        vmovaps ymm1,[rdx]                  ;ymm1 = b

        vcmpps ymm2,ymm0,ymm1,CMP_EQ_OQ     ;packed compare for EQ
        vmovaps [rdi],ymm2

        vcmpps ymm2,ymm0,ymm1,CMP_NEQ_OQ    ;packed compare for NEQ
        vmovaps [rdi+32],ymm2

        vcmpps ymm2,ymm0,ymm1,CMP_LT_OQ     ;packed compare for LT
        vmovaps [rdi+64],ymm2

        vcmpps ymm2,ymm0,ymm1,CMP_LE_OQ     ;packed compare for LE
        vmovaps [rdi+96],ymm2

        vcmpps ymm2,ymm0,ymm1,CMP_GT_OQ     ;packed compare for GT
        vmovaps [rdi+128],ymm2

        vcmpps ymm2,ymm0,ymm1,CMP_GE_OQ     ;packed compare for GE
        vmovaps [rdi+160],ymm2

        vcmpps ymm2,ymm0,ymm1,CMP_ORD_Q     ;packed compare for ORD
        vmovaps [rdi+192],ymm2

        vcmpps ymm2,ymm0,ymm1,CMP_UNORD_Q   ;packed compare for UNORD
        vmovaps [rdi+224],ymm2

        vzeroupper
        ret

;------------------------------------------------------------------------------
; void PackedCompareF64_avx(YmmVal* c, const YmmVal* a, const YmmVal* b);
;------------------------------------------------------------------------------

        global PackedCompareF64_avx
PackedCompareF64_avx:
        vmovapd ymm0,[rsi]                  ;ymm0 = a
        vmovapd ymm1,[rdx]                  ;ymm1 = b

        vcmppd ymm2,ymm0,ymm1,CMP_EQ_OQ     ;packed compare for EQ
        vmovapd [rdi],ymm2

        vcmppd ymm2,ymm0,ymm1,CMP_NEQ_OQ    ;packed compare for NEQ
        vmovapd [rdi+32],ymm2

        vcmppd ymm2,ymm0,ymm1,CMP_LT_OQ     ;packed compare for LT
        vmovapd [rdi+64],ymm2

        vcmppd ymm2,ymm0,ymm1,CMP_LE_OQ     ;packed compare for LE
        vmovapd [rdi+96],ymm2

        vcmppd ymm2,ymm0,ymm1,CMP_GT_OQ     ;packed compare for GT
        vmovapd [rdi+128],ymm2

        vcmppd ymm2,ymm0,ymm1,CMP_GE_OQ     ;packed compare for GE
        vmovapd [rdi+160],ymm2

        vcmppd ymm2,ymm0,ymm1,CMP_ORD_Q     ;packed compare for ORD
        vmovapd [rdi+192],ymm2

        vcmppd ymm2,ymm0,ymm1,CMP_UNORD_Q   ;packed compare for UNORD
        vmovapd [rdi+224],ymm2

        vzeroupper
        ret
