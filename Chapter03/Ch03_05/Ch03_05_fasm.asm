;------------------------------------------------------------------------------
; Ch03_05_fasm.asm
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; bool CalcSumCubes_a(int64_t* sum, int64_t n);
;------------------------------------------------------------------------------

        extern g_ValMax:qword

        .code
CalcSumCubes_a proc

; Make sure n is valid
        test rdx,rdx                        ;n <= 0?
        jle BadArg                          ;jump if yes
        cmp rdx,[g_ValMax]                  ;n > g_ValMax?
        jg BadArg                           ;jump if yes

; Initialize
        xor r10,r10                         ;i = 0
        xor eax,eax                         ;sum = 0

; Calculate cube sum
Loop1:  add r10,1                           ;i += 1
        mov r11,r10                         ;r11 = i
        imul r11,r11                        ;r11 = i * i
        imul r11,r10                        ;r11 = i * i * i
        add rax,r11                         ;sum += i * i * i

        cmp r10,rdx                         ;i < n?
        jl Loop1                            ;jump if yes
       
Done:   mov [rcx],rax                       ;save final sum
        mov eax,1                           ;rc = true
        ret

BadArg: mov qword ptr [rcx],0               ;sum = 0 (error)
        xor eax,eax                         ;rc = false
        ret

CalcSumCubes_a endp
        end
