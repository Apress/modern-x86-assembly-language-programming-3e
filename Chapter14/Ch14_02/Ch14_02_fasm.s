;------------------------------------------------------------------------------
; Ch14_02_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"
        %include "cmpequ_fp.inc"

;------------------------------------------------------------------------------
; void PackedCompareF32_avx512(uint16_t* c, const ZmmVal* a, const ZmmVal* b);
;------------------------------------------------------------------------------

        section .text

        global PackedCompareF32_avx512
PackedCompareF32_avx512:

        vmovaps zmm0,[rsi]                  ;zmm0 = a
        vmovaps zmm1,[rdx]                  ;zmm1 = b

        vcmpps k1,zmm0,zmm1,CMP_EQ_OQ       ;packed compare for EQ
        kmovw [rdi],k1                      ;save mask

        vcmpps k1,zmm0,zmm1,CMP_NEQ_OQ      ;packed compare for NEQ
        kmovw [rdi+2],k1                    ;save mask

        vcmpps k1,zmm0,zmm1,CMP_LT_OQ       ;packed compare for LT
        kmovw [rdi+4],k1                    ;save mask

        vcmpps k1,zmm0,zmm1,CMP_LE_OQ       ;packed compare for LE
        kmovw [rdi+6],k1                    ;save mask

        vcmpps k1,zmm0,zmm1,CMP_GT_OQ       ;packed compare for GT
        kmovw [rdi+8],k1                    ;save mask

        vcmpps k1,zmm0,zmm1,CMP_GE_OQ       ;packed compare for GE
        kmovw [rdi+10],k1                   ;save mask

        vcmpps k1,zmm0,zmm1,CMP_ORD_Q       ;packed compare for ORD
        kmovw [rdi+12],k1                   ;save mask

        vcmpps k1,zmm0,zmm1,CMP_UNORD_Q     ;packed compare for UNORD
        kmovw [rdi+14],k1                   ;save mask

        vzeroupper
        ret

;------------------------------------------------------------------------------
; void PackedCompareF64_avx512(uint8_t c[8], const ZmmVal* a, const ZmmVal* b);
;------------------------------------------------------------------------------

        global PackedCompareF64_avx512
PackedCompareF64_avx512:

        vmovapd zmm0,[rsi]                  ;zmm0 = a
        vmovapd zmm1,[rdx]                  ;zmm1 = b

        vcmppd k1,zmm0,zmm1,CMP_EQ_OQ       ;packed compare for EQ
        kmovb [rdi],k1                      ;save mask

        vcmppd k1,zmm0,zmm1,CMP_NEQ_OQ      ;packed compare for NEQ
        kmovb [rdi+1],k1                    ;save mask

        vcmppd k1,zmm0,zmm1,CMP_LT_OQ       ;packed compare for LT
        kmovb [rdi+2],k1                    ;save mask

        vcmppd k1,zmm0,zmm1,CMP_LE_OQ       ;packed compare for LE
        kmovb [rdi+3],k1                    ;save mask

        vcmppd k1,zmm0,zmm1,CMP_GT_OQ       ;packed compare for GT
        kmovb [rdi+4],k1                    ;save mask

        vcmppd k1,zmm0,zmm1,CMP_GE_OQ       ;packed compare for GE
        kmovb [rdi+5],k1                    ;save mask

        vcmppd k1,zmm0,zmm1,CMP_ORD_Q       ;packed compare for ORD
        kmovb [rdi+6],k1                    ;save mask

        vcmppd k1,zmm0,zmm1,CMP_UNORD_Q     ;packed compare for UNORD
        kmovb [rdi+7],k1                    ;save mask

        vzeroupper
        ret
