;------------------------------------------------------------------------------
; Ch02_03_fasm.asm
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; int ShiftU32_a(unsigned int* a_shl, unsigned int* a_shr, unsigned int a,
;   unsigned int count);
;
; returns:  0 = invalid shift count, 1 = valid shift count
;------------------------------------------------------------------------------

       .code
ShiftU32_a proc
        cmp r9d,32                          ;is count >= 32
        jae BadCnt                          ;jump if count >= 32

        mov r10,rcx                         ;save a_shl
        mov ecx,r9d                         ;ecx = count

        mov eax,r8d                         ;eax = a
        shl eax,cl                          ;eax = a << count;
        mov [r10],eax                       ;save shl result

        shr r8d,cl                          ;r8d = a >> count
        mov [rdx],r8d                       ;save shr result

        mov eax,1                           ;valid shift count return code
        ret                                 ;return to caller

BadCnt: xor eax,eax                         ;invalid shift count return code
        ret

ShiftU32_a endp
        end
