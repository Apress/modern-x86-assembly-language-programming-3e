;------------------------------------------------------------------------------
; Ch05_04_fasm.asm
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; void CompareF32_avx(uint8_t* cmp_results, float a, float b);
;------------------------------------------------------------------------------

        .code
CompareF32_avx proc

; Set result flags based on compare status
        vucomiss xmm1,xmm2
        setp byte ptr [rcx]                 ;RFLAGS.PF = 1 if unordered
        jnp L1
        xor al,al
        mov [rcx+1],al                      ;set all other cmp_results[]
        mov [rcx+2],al                      ;values to 0
        mov [rcx+3],al
        mov [rcx+4],al
        mov [rcx+5],al
        mov [rcx+6],al
        ret

L1:     setb byte ptr [rcx+1]               ;set byte if a < b
        setbe byte ptr [rcx+2]              ;set byte if a <= b
        sete byte ptr [rcx+3]               ;set byte if a == b
        setne byte ptr [rcx+4]              ;set byte if a != b
        seta byte ptr [rcx+5]               ;set byte if a > b
        setae byte ptr [rcx+6]              ;set byte if a >= b
        ret

CompareF32_avx endp
        end
