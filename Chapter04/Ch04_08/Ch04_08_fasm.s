;------------------------------------------------------------------------------
; Ch04_08_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

; Test structure
struc TestStruct
.Val8:    resb  1
.PadA:    resb  7
.Val64:   resq  1
.Val16:   resw  1
.PadB     resb  2
.Val32:   resd  1
endstruc

;------------------------------------------------------------------------------
; int64_t SumStructVals_a(const TestStruct* ts);
;------------------------------------------------------------------------------

        section .text

        global SumStructVals_a
SumStructVals_a:

; Compute ts->Val8 + ts->Val16, note sign extensions to 32-bits
        movsx eax,byte [rdi+TestStruct.Val8]
        movsx edx,word [rdi+TestStruct.Val16]
        add eax,edx

; Sign extend previous result to 64 bits
        movsxd rax,eax

; Add ts->Val32 to sum
        movsxd rdx,[rdi+TestStruct.Val32]
        add rax,rdx

; Add ts->Val64 to sum
        add rax,[rdi+TestStruct.Val64]
        ret
