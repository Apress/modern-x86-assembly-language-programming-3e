;------------------------------------------------------------------------------
; Ch09_03 fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; bool PackedConvertFP_avx(const XmmVal& a, XmmVal& b, CvtOp cvt_op);
;------------------------------------------------------------------------------

        section .text

        global PackedConvertFP_avx
PackedConvertFP_avx:

; Make sure cvt_op is valid
        cmp edx,CvtOpTableCount             ;is cvt_op valid?
        jae InvalidCvtOp                    ;jmp if cvt_op is invalid

; Jump to code block specfied by cvt_op
        mov eax,1                           ;set valid cvt_op return code
        mov edx,edx                         ;rdx = cvt_op (zero extended)
        lea r9,[CvtOpTable]                 ;r9 = address of CvtOpTable
        mov r10,[r9+rdx*8]                  ;r10 = address of entry in CvtOpTable
        jmp qword r10                       ;jump to conversion code block

; Convert packed signed doubleword integers to packed SPFP values
I32_F32:
        vmovdqa xmm0,[rdi]                  ;load a
        vcvtdq2ps xmm1,xmm0                 ;perform conversion
        vmovaps [rsi],xmm1                  ;save to b
        ret

; Convert packed SPFP values to packed signed doubleword integers
F32_I32:
        vmovaps xmm0,[rdi]
        vcvtps2dq xmm1,xmm0
        vmovdqa [rsi],xmm1
        ret

; Convert packed signed doubleword integers to packed DPFP values
I32_F64:
        vmovdqa xmm0,[rdi]
        vcvtdq2pd xmm1,xmm0
        vmovapd [rsi],xmm1
        ret

; Convert packed DPFP values to packed signed doubleword integers
F64_I32:
        vmovapd xmm0,[rdi]
        vcvtpd2dq xmm1,xmm0
        vmovdqa [rsi],xmm1
        ret

; Convert packed SPFP to packed DPFP
F32_F64:
        vmovaps xmm0,[rdi]
        vcvtps2pd xmm1,xmm0
        vmovapd [rsi],xmm1
        ret

; Convert packed DPFP to packed SPFP
F64_F32:
        vmovapd xmm0,[rdi]
        vcvtpd2ps xmm1,xmm0
        vmovaps [rsi],xmm1
        ret

InvalidCvtOp:
        xor eax,eax                         ;set invalid cvt_op return code
        ret

; The order of values in the following table must match the enum CvtOp
; that's defined in Ch09_03.h.

        section .data align = 8

CvtOpTable equ $
        dq I32_F32, F32_I32
        dq I32_F64, F64_I32
        dq F32_F64, F64_F32
CvtOpTableCount equ ($ - CvtOpTable) / 8
