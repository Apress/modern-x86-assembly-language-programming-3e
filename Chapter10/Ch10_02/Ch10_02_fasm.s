;------------------------------------------------------------------------------
; Ch10_02_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; void ZeroExtU8_U16_avx2(YmmVal* c, const YmmVal* a);
;------------------------------------------------------------------------------

        section .text
        
        global ZeroExtU8_U16_avx2
ZeroExtU8_U16_avx2:

        vmovdqa ymm0,[rsi]                  ;ymm0 = a (32 byte values)
        vextracti128 xmm1,ymm0,1            ;xmm1 = high-order byte values

        vpmovzxbw ymm2,xmm0                 ;zero extend a[0:15] to word
        vpmovzxbw ymm3,xmm1                 ;zero extend a[16:31] to words

        vmovdqa [rdi],ymm2                  ;save words c[0:15]
        vmovdqa [rdi+32],ymm3               ;save words c[16:31]

        vzeroupper
        ret

;------------------------------------------------------------------------------
; void ZeroExtU8_U32_avx2(YmmVal* c, const YmmVal* a);
;------------------------------------------------------------------------------

        global ZeroExtU8_U32_avx2
ZeroExtU8_U32_avx2:

        vmovdqa ymm0,[rsi]                  ;ymm0 = a (32 bytes values)
        vextracti128 xmm1,ymm0,1            ;xmm1 = high-order byte values

        vpmovzxbd ymm2,xmm0                 ;zero extend a[0:7] to dword
        vpsrldq xmm0,xmm0,8                 ;xmm0[63:0] = a[8:15]
        vpmovzxbd ymm3,xmm0                 ;zero extend a[8:15] to dword

        vpmovzxbd ymm4,xmm1                 ;zero extend a[16:23] to dword
        vpsrldq xmm1,xmm1,8                 ;xmm1[63:0] = a[24:31]
        vpmovzxbd ymm5,xmm1                 ;zero extend a[24:31] to dword

        vmovdqa [rdi],ymm2                  ;save dwords c[0:7]
        vmovdqa [rdi+32],ymm3               ;save dwords c[8:15]
        vmovdqa [rdi+64],ymm4               ;save dwords c[16:23]
        vmovdqa [rdi+96],ymm5               ;save dwords c[24:31]

        vzeroupper
        ret

;------------------------------------------------------------------------------
; void SignExtI16_I32_avx2(YmmVal* c, const YmmVal* a);
;------------------------------------------------------------------------------

        global SignExtI16_I32_avx2
SignExtI16_I32_avx2:

        vmovdqa ymm0,[rsi]                  ;ymm0 = a (16 word values)
        vextracti128 xmm1,ymm0,1            ;xmm1 = high-order word values

        vpmovsxwd ymm2,xmm0                 ;sign extend a[0:7] to dword
        vpmovsxwd ymm3,xmm1                 ;sign extend a[8:15] to dwords

        vmovdqa [rdi],ymm2                  ;save dwords c[0:7]
        vmovdqa [rdi+32],ymm3               ;save dwords c[8:15]

        vzeroupper
        ret

;------------------------------------------------------------------------------
; void SignExtI16_I64_avx2(YmmVal* c, const YmmVal* a);
;------------------------------------------------------------------------------

        global SignExtI16_I64_avx2
SignExtI16_I64_avx2:

        vmovdqa ymm0,[rsi]                  ;ymm0 = a (16 word values)
        vextracti128 xmm1,ymm0,1            ;xmm1 = high-order word values

        vpmovsxwq ymm2,xmm0                 ;sign extend a[0:3] to qword
        vpsrldq xmm0,xmm0,8                 ;xmm0[63:0] = a[4:7]
        vpmovsxwq ymm3,xmm0                 ;sign extend a[4:7] to qword

        vpmovsxwq ymm4,xmm1                 ;sign extend a[8:11] to qword
        vpsrldq xmm1,xmm1,8                 ;xmm1[63:0] = a[12:15]
        vpmovsxwq ymm5,xmm1                 ;sign extend a[12:15] to 2word

        vmovdqa [rdi],ymm2                  ;save qwords c[0:3]
        vmovdqa [rdi+32],ymm3               ;save qwords c[4:7]
        vmovdqa [rdi+64],ymm4               ;save qwords c[8:11]
        vmovdqa [rdi+96],ymm5               ;save qwords c[12:16]

        vzeroupper
        ret

