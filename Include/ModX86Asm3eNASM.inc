;-----------------------------------------------------------------------------
; ModX86ASm3eNASM.inc
;-----------------------------------------------------------------------------

; Use RIP-relative memory addressing
        default rel

; Mark stack as non-executable for Binutils 2.39+
        section .note.GNU-stack noalloc noexec nowrite progbits
