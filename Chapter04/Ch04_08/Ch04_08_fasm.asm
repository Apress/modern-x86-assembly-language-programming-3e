;------------------------------------------------------------------------------
; Ch04_08_fasm.asm
;------------------------------------------------------------------------------

TestStruct struct
Val8    db ?
PadA    db 7 dup (?)
Val64   dq ?
Val16   dw ?
PadB    db 2 dup (?)
Val32   dd ?
TestStruct ends

;------------------------------------------------------------------------------
; int64_t SumStructVals_a(const TestStruct* ts);
;------------------------------------------------------------------------------

        .code
SumStructVals_a proc

; Compute ts->Val8 + ts->Val16, note sign extensions to 32-bits
        movsx eax,byte ptr [rcx+TestStruct.Val8]
        movsx edx,word ptr [rcx+TestStruct.Val16]
        add eax,edx

; Sign extend previous result to 64 bits
        movsxd rax,eax

; Add ts->Val32 to sum
        movsxd rdx,[rcx+TestStruct.Val32]
        add rax,rdx

; Add ts->Val64 to sum
        add rax,[rcx+TestStruct.Val64]
        ret

SumStructVals_a endp
        end
