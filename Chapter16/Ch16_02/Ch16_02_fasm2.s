;------------------------------------------------------------------------------
; Ch16_01.fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; int GetProcessorVendorInfo_asm(char* vendor, size_t vendor_len, char* brand,
;   size_t brand_len);
;------------------------------------------------------------------------------

VENDOR_LEN_MIN  equ 13
BRAND_LEN_MIN   equ 49

        section .text

        global GetProcessorVendorInfo_a
GetProcessorVendorInfo_a:
        push rbx

; Make sure string buffers are large enough
        cmp rsi,VENDOR_LEN_MIN
        jb BadArg
        cmp rcx,BRAND_LEN_MIN
        jb BadArg

        mov r9,rdx                          ;save copy of arg brand

; Query processor vendor information string
        xor eax,eax                         ;leaf value for vendor ID string
        cpuid
        mov r11d,eax                        ;save max leaf value

        mov [rdi],ebx                       ;save vendor[0:3]
        mov [rdi+4],edx                     ;save vendor[4:7]
        mov [rdi+8],ecx                     ;save vendor[8:11]
        mov [rdi+12],byte 0                 ;null terminate string

; Query processor brand information string
        mov eax,80000000h                   ;request max leaf for extended info
        cpuid
        cmp eax,80000004h                   ;processor brand string available?
        jb NoInfo                           ;jump if no

        mov eax,80000002h                   ;request brand string chars 0 - 15
        cpuid
        mov [r9+0],eax                      ;save brand[0:3]
        mov [r9+4],ebx                      ;save brand[4:7]
        mov [r9+8],ecx                      ;save brand[8:11]
        mov [r9+12],edx                     ;save brand[12:15]

        mov eax,80000003h                   ;request brand string chars 16 - 31
        cpuid
        mov [r9+16],eax                     ;save brand[16:19]
        mov [r9+20],ebx                     ;save brand[20:23]
        mov [r9+24],ecx                     ;save brand[24:27]
        mov [r9+28],edx                     ;save brand[28:31]

        mov eax,80000004h                   ;request brand string chars 32 - 47
        cpuid
        mov [r9+32],eax                     ;save brand[32:35]
        mov [r9+36],ebx                     ;save brand[36:39]
        mov [r9+40],ecx                     ;save brand[40:43]
        mov [r9+44],edx                     ;save brand[44:47]
        mov [r9+48],byte 0                  ;null terminate string
        jmp SetRC
    
NoInfo: mov eax,412F4eh                     ;eax = "N/A\0"
        mov [r9],eax

SetRC:  mov eax,r11d                        ;set success return code

Done:   pop rbx
        ret

BadArg: xor eax,eax                         ;set error return code
        jmp Done
