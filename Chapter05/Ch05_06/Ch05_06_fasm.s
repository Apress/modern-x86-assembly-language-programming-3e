;------------------------------------------------------------------------------
; Ch05_06_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

MxcsrRcMask     equ 9fffh                   ;bit mask for MXCSR.RC
MxcsrRcShift    equ 13                      ;shift count for MXCSR.RC
MxcsrRSP        equ -8                      ;stack offset for vstmxcsr & vldmxcsr

;------------------------------------------------------------------------------
; Macro GetRC_M - copies MXCSR.RC to r10d[1:0]
;------------------------------------------------------------------------------

%macro GetRC_M 0
        vstmxcsr [rsp+MxcsrRSP]             ;save mxcsr register
        mov r10d,[rsp+MxcsrRSP]

        shr r10d,MxcsrRcShift               ;r10d[1:0] = MXCSR.RC
        and r10d,3                          ;clear unused bits
%endmacro

;------------------------------------------------------------------------------
; Macro SetRC_M - sets MXCSR.RC to %1[1:0] (%1 must be 32-bit register)
;------------------------------------------------------------------------------

%macro SetRC_M 1
        vstmxcsr [rsp+MxcsrRSP]             ;save current MXCSR
        mov eax,[rsp+MxcsrRSP]

        and %1,3                            ;clear unusned bits
        shl %1,MxcsrRcShift                 ;%1[14:13] = rc

        and eax,MxcsrRcMask                 ;clear non MXCSR.RC bits
        or eax,%1                           ;insert new MXCSR.RC

        mov [rsp+MxcsrRSP],eax
        vldmxcsr [rsp+MxcsrRSP]             ;load updated MXCSR
%endmacro

;------------------------------------------------------------------------------
; bool ConvertScalar_avx(Uval* des, const Uval* src, CvtOp cvt_op, RC rc)
;------------------------------------------------------------------------------

        section .text

        global ConvertScalar_avx
ConvertScalar_avx:

; Make sure cvt_op is valid
        cmp edx,CvtOpTableCount             ;is cvt_op >= CvtOpTableCount
        jae BadCvtOp                        ;jump if cvt_op is invalid

; Save current MSCSR.RC
        GetRC_M                             ;r10d = current RC

; Set new rounding mode
        SetRC_M ecx                         ;set new MXCSR.RC

; Jump to target conversion code block
        mov eax,edx                         ;rax = cvt_op
        lea r11,[CvtOpTable]                ;r11 = address of CvtOpTable
        lea r11,[r11+rax*8]                 ;r11 = address of entry in CvtOpTable
        jmp qword [r11]                     ;jump to selected code block

; Conversions between int32_t and float/double

I32_F32:
        mov eax,[rsi]                       ;load integer value
        vcvtsi2ss xmm0,xmm0,eax             ;convert to float
        vmovss [rdi],xmm0                   ;save result
        jmp Done

F32_I32:
        vmovss xmm0,[rsi]                   ;load float value
        vcvtss2si eax,xmm0                  ;convert to integer
        mov [rdi],eax                       ;save result
        jmp Done

I32_F64:
        mov eax,[rsi]                       ;load integer value
        vcvtsi2sd xmm0,xmm0,eax             ;convert to double
        vmovsd [rdi],xmm0                   ;save result
        jmp Done

F64_I32:
        vmovsd xmm0,[rsi]                   ;load double value
        vcvtsd2si eax,xmm0                  ;convert to integer
        mov [rdi],eax                       ;save result
        jmp Done

; Conversions between int64_t and float/double

I64_F32:
        mov rax,[rsi]                       ;load integer value
        vcvtsi2ss xmm0,xmm0,rax             ;convert to float
        vmovss [rdi],xmm0                   ;save result
        jmp Done

F32_I64:
        vmovss xmm0,[rsi]                   ;load float value
        vcvtss2si rax,xmm0                  ;convert to integer
        mov [rdi],rax                       ;save result
        jmp Done

I64_F64:
        mov rax,[rsi]                       ;load integer value
        vcvtsi2sd xmm0,xmm0,rax             ;convert to double
        vmovsd [rdi],xmm0                   ;save result
        jmp Done

F64_I64:
        vmovsd xmm0,[rsi]                   ;load double value
        vcvtsd2si rax,xmm0                  ;convert to integer
        mov [rdi],rax                       ;save result
        jmp Done

; Conversions between float and double

F32_F64:
        vmovss xmm0,[rsi]                   ;load float value
        vcvtss2sd xmm1,xmm1,xmm0            ;convert to double
        vmovsd [rdi],xmm1                   ;save result
        jmp Done

F64_F32:
        vmovsd xmm0,[rsi]                   ;load double value
        vcvtsd2ss xmm1,xmm1,xmm0            ;convert to float
        vmovss [rdi],xmm1                   ;save result
        jmp Done

BadCvtOp:
        xor eax,eax                         ;set error return code
        ret

Done:   SetRC_M r10d                        ;restore original MXCSR.RC
        mov eax,1                           ;set success return code
        ret

; The order of values in following table must match enum CvtOp
; that's defined in the .h file.

        section .data align = 8

CvtOpTable equ $
        dq I32_F32, F32_I32
        dq I32_F64, F64_I32
        dq I64_F32, F32_I64
        dq I64_F64, F64_I64
        dq F32_F64, F64_F32
CvtOpTableCount equ ($ - CvtOpTable) / 8
