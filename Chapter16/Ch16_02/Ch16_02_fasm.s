;------------------------------------------------------------------------------
; Ch16_02.fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

; Note: The equ statements below must match the values assigned
; in C++ namespace CpuFlags (see Ch16_02.h). Values must also be
; consecutively numbered starting from zero.
FL_POPCNT           equ 0
FL_AVX              equ 1
FL_AVX2             equ 2 
FL_FMA              equ 3
FL_AVX512F          equ 4
FL_AVX512VL         equ 5
FL_AVX512DQ         equ 6
FL_AVX512BW         equ 7
FL_AVX512_VBMI      equ 8
FL_AVX512_VBMI2     equ 9
FL_AVX512_FP16      equ 10
FL_AVX512_BF16      equ 11
FL_NUM_FLAGS        equ 12

; CPUID flag bits.
; See cpuid instruction documentation for more information.
BIT_FMA             equ 1 << 12        ;CPUID(EAX=01h):ECX[bit 12]
BIT_POPCNT          equ 1 << 23        ;CPUID(EAX=01h):ECX[bit 23]
BIT_OSXSAVE         equ 1 << 27        ;CPUID(EAX=01h):ECX[bit 27]
BIT_AVX             equ 1 << 28        ;CPUID(EAX=01h):ECX[bit 28]
BIT_AVX2            equ 1 << 5         ;CPUID(EAX=07h,ECX=00h):EBX[bit 5]
BIT_AVX512F         equ 1 << 16        ;CPUID(EAX=07h,ECX=00h):EBX[bit 16]
BIT_AVX512DQ        equ 1 << 17        ;CPUID(EAX=07h,ECX=00h):EBX[bit 17]
BIT_AVX512BW        equ 1 << 30        ;CPUID(EAX=07h,ECX=00h):EBX[bit 30]
BIT_AVX512VL        equ 1 << 31        ;CPUID(EAX=07h,ECX=00h):EBX[bit 31]
BIT_AVX512_VBMI     equ 1 << 1         ;CPUID(EAX=07h,ECX=00h):ECX[bit 1]
BIT_AVX512_VBMI2    equ 1 << 6         ;CPUID(EAX=07h,ECX=00h):ECX[bit 6]
BIT_AVX512_FP16     equ 1 << 23        ;CPUID(EAX=07h,ECX=00h):EDX[bit 23]
BIT_AVX512_BF16     equ 1 << 5         ;CPUID(EAX=07h,ECX=01h):EAX[bit 5]

; AVX/AVX-512 state flags.
; See xgetbv instruction documentation for more information.
STATE_AVX           equ 06h
STATE_AVX512        equ 0e0h

;------------------------------------------------------------------------------
; bool GetCpuidFlags(uint8_t* flags, size_t flags_len);
;------------------------------------------------------------------------------

        section .text

        global GetCpuidFlags_a
GetCpuidFlags_a:
        push rbx

; Make sure flags buffer is large enough
        cmp rsi,FL_NUM_FLAGS                ;flags_len >= FL_NUM_FLAGS?
        jb BadArg                           ;jump if no

; Initialize all flags to false
        xor eax,eax                         ;al = fill value
        mov r10,rdi                         ;save copy of arg flags
        mov rcx,FL_NUM_FLAGS
        rep stosb                           ;set all flags to false

; Verify CPUID support for leaf value eax = 07h
        xor eax,eax
        cpuid                               ;get max leaf value
        cmp eax,7                           ;max leaf >= 7?
        jb Done                             ;jump if no

; Verify OS support for xgetbv instruction
        mov eax,1
        cpuid
        test ecx,BIT_OSXSAVE                ;OS enabled xgetbv?
        jz Done                             ;jump if no
        mov r8d,ecx                         ;save cpuid(eax=01h):ecx results

; Verify OS support for AVX/AVX2
        xor ecx,ecx                         ;select XCR0
        xgetbv                              ;result in edx:eax
        mov r9d,eax                         ;save AVX-512 state flags for later
        and eax,STATE_AVX
        cmp eax,STATE_AVX                   ;OS support for AVX/AVX2?
        jne Done                            ;jump if no

; Verify CPU support for AVX and FMA
        test r8d,BIT_AVX
        setnz byte [r10+FL_AVX]

        test r8d,BIT_FMA
        setnz byte [r10+FL_FMA]

        test r8d,BIT_POPCNT
        setnz byte [r10+FL_POPCNT]

; Verify CPU support for AVX2
        mov eax,7                           ;eax = leaf value
        xor ecx,ecx                         ;ecx = sub-leaf value
        cpuid

        test ebx,BIT_AVX2
        setnz byte [r10+FL_AVX2]

; Verify OS support for AVX-512
        and r9d,STATE_AVX512
        cmp r9d,STATE_AVX512                ;OS support for AVX-512?
        jne Done                            ;jump if no

; Verify CPU support for AVX512F, AVX512VL, AVX512DQ, and AVX512BW
        test ebx,BIT_AVX512F
        setnz byte [r10+FL_AVX512F]

        test ebx,BIT_AVX512VL
        setnz byte [r10+FL_AVX512VL]

        test ebx,BIT_AVX512DQ
        setnz byte [r10+FL_AVX512DQ]

        test ebx,BIT_AVX512BW
        setnz byte [r10+FL_AVX512BW]

; Verify CPU support for AVX512_VBMI and AVX512_VBMI2
        test ecx,BIT_AVX512_VBMI
        setnz byte [r10+FL_AVX512_VBMI]

        test ecx,BIT_AVX512_VBMI2
        setnz byte [r10+FL_AVX512_VBMI2]

; Verify CPU support for AVX512_FP16
        test edx,BIT_AVX512_FP16
        setnz byte [r10+FL_AVX512_FP16]

; Verify CPU support for AVX512_BF16
        mov eax,7
        mov ecx,1
        cpuid
        test eax,BIT_AVX512_BF16
        setnz byte [r10+FL_AVX512_BF16]

Done:   mov eax,1                           ;set success return code
        pop rbx
        ret

BadArg: xor eax,eax                         ;set error return code
        jmp Done
