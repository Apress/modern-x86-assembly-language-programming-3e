;------------------------------------------------------------------------------
; Ch03_03_fasm.asm
;------------------------------------------------------------------------------

; Simple LUT (.const section is read only)
                .const
PrimeNums       dd 2, 3, 5, 7, 11, 13, 17, 19, 23
                dd 29, 31, 37, 41, 43, 47, 53, 59
                dd 61, 67, 71, 73, 79, 83, 89, 97 

                public g_NumPrimes_a
g_NumPrimes_a   dd ($ - PrimeNums) / sizeof dword

; Data section (.data section is read/write)
                .data
                public g_SumPrimes_a
g_SumPrimes_a   dd -9999

;------------------------------------------------------------------------------
; int MemAddressing_a(int32_t i, int32_t* v1, int32_t* v2,
;   int32_t* v3, int32_t* v4);
;------------------------------------------------------------------------------

        .code
MemAddressing_a proc

; Make sure 'i' is valid
        cmp ecx,-1
        jle InvalidIndex                    ;jump if i <= -1
        cmp ecx,[g_NumPrimes_a]
        jge InvalidIndex                    ;jump if i >= g_NumPrimes_a

; Initialize
        movsxd r10,ecx                      ;extend i to 64-bits
        lea r11,[PrimeNums]                 ;r11 = address of PrimeNums

; Memory addressing - base register
        mov rcx,r10                         ;rcx = i
        shl rcx,2                           ;rcx = i * 4
        mov rax,r11                         ;rax = PrimeNums
        add rax,rcx                         ;rax = PrimeNums + i * 4
        mov eax,[rax]                       ;eax = PrimeNums[i]
        mov [rdx],eax                       ;save to v1

; Memory addressing - base register + index register
        mov rcx,r10                         ;rcx = i
        shl rcx,2                           ;rcx = i * 4
        mov eax,[r11+rcx]                   ;eax = PrimeNums[i]
        mov [r8],eax                        ;save to v2

; Memory addressing - base register + index register * scale factor
        mov eax,[r11+r10*4]                 ;eax = PrimeNums[i]
        mov [r9],eax                        ;save to v3

; Memory addressing - base register + index register * scale factor + disp
        sub r11,42                          ;r11 = PrimeNums - 42
        mov eax,[r11+r10*4+42]              ;eax = PrimeNums[i]
        mov r10,[rsp+40]                    ;r10 = v4 ptr
        mov [r10],eax                       ;save to v4

; Memory addressing - RIP relative
        add [g_SumPrimes_a],eax             ;update sum
        mov eax,1                           ;set success return code
        ret

InvalidIndex:
        xor eax,eax                         ;set error return code
        ret

MemAddressing_a endp
        end
