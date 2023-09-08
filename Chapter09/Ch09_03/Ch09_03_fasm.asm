;------------------------------------------------------------------------------
; Ch09_03_fasm.asm
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; bool PackedConvertFP_avx(const XmmVal& a, XmmVal& b, CvtOp cvt_op);
;------------------------------------------------------------------------------

        .code
PackedConvertFP_avx proc

; Make sure cvt_op is valid
        cmp r8d,CvtOpTableCount             ;is cvt_op valid?
        jae InvalidCvtOp                    ;jmp if cvt_op is invalid

; Jump to code block specfied by cvt_op
        mov eax,1                           ;set valid cvt_op return code
        mov r8d,r8d                         ;r8 = cvt_op (zero extended)
        lea r9,[CvtOpTable]                 ;r9 = address of CvtOpTable
        mov r10,[r9+r8*8]                   ;r10 = address of entry in CvtOpTable
        jmp qword ptr r10                   ;jump to conversion code block

; Convert packed signed doubleword integers to packed SPFP values
I32_F32:
        vmovdqa xmm0,xmmword ptr [rcx]
        vcvtdq2ps xmm1,xmm0
        vmovaps xmmword ptr [rdx],xmm1
        ret

; Convert packed SPFP values to packed signed doubleword integers
F32_I32:
        vmovaps xmm0,xmmword ptr [rcx]
        vcvtps2dq xmm1,xmm0
        vmovdqa xmmword ptr [rdx],xmm1
        ret

; Convert packed signed doubleword integers to packed DPFP values
I32_F64:
        vmovdqa xmm0,xmmword ptr [rcx]
        vcvtdq2pd xmm1,xmm0
        vmovapd xmmword ptr [rdx],xmm1
        ret

; Convert packed DPFP values to packed signed doubleword integers
F64_I32:
        vmovapd xmm0,xmmword ptr [rcx]
        vcvtpd2dq xmm1,xmm0
        vmovdqa xmmword ptr [rdx],xmm1
        ret

; Convert packed SPFP to packed DPFP
F32_F64:
        vmovaps xmm0,xmmword ptr [rcx]
        vcvtps2pd xmm1,xmm0
        vmovapd xmmword ptr [rdx],xmm1
        ret

; Convert packed DPFP to packed SPFP
F64_F32:
        vmovapd xmm0,xmmword ptr [rcx]
        vcvtpd2ps xmm1,xmm0
        vmovaps xmmword ptr [rdx],xmm1
        ret

InvalidCvtOp:
        xor eax,eax                         ;set invalid cvt_op return code
        ret

; The order of values in the following table must match the enum CvtOp
; that's defined in Ch09_03.h.

            align 8
CvtOpTable  equ $
            dq I32_F32, F32_I32
            dq I32_F64, F64_I32
            dq F32_F64, F64_F32
CvtOpTableCount equ ($ - CvtOpTable) / size qword

PackedConvertFP_avx endp
        end

