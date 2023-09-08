;------------------------------------------------------------------------------
; Ch06_02_fasm.asm
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; void CalcSumProd_avx(const int64_t* a, const int64_t* b, int32_t n,
;    int64_t* sum_a, int64_t* sum_b, int64_t* prod_a, int64_t* prod_b);
;
; Named expressions for constant values:
;
; NUM_PUSHREG   number of prologue non-volatile register pushes
; STK_LOCAL1    size in bytes of STK_LOCAL1 area (see figure in text)
; STK_LOCAL2    size in bytes of STK_LOCAL2 area (see figure in text)
; STK_PAD       extra bytes (0 or 8) needed to 16-byte align RSP
; STK_TOTAL     total size in bytes of local stack
; RBP_RA        number of bytes between RBP and return address on stack
;------------------------------------------------------------------------------

NUM_PUSHREG     equ 4
STK_LOCAL1      equ 32
STK_LOCAL2      equ 16
STK_PAD         equ ((NUM_PUSHREG AND 1) XOR 1) * 8
STK_TOTAL       equ STK_LOCAL1 + STK_LOCAL2 + STK_PAD
RBP_RA          equ NUM_PUSHREG * 8 + STK_LOCAL1 + STK_PAD

; Test SIMD values. Note that TestVal1 is Intentionally misaligned
                .const
                align 4
TestVal0        db 0ffh
TestVal1        db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15

        .code
CalcSumProd_avx proc frame

; Function prologue
        push rbp                            ;save non-volatile register RBP
        .pushreg rbp
        push rbx                            ;save non-volatile register RBX
        .pushreg rbx
        push r12                            ;save non-volatile register R12
        .pushreg r12
        push r13                            ;save non-volatile register R13
        .pushreg r13

        sub rsp,STK_TOTAL                   ;allocate local stack space
        .allocstack STK_TOTAL
        lea rbp,[rsp+STK_LOCAL2]            ;set frame pointer
        .setframe rbp,STK_LOCAL2
        .endprolog                          ;end of prologue

; Initialize local variables on the stack (demonstration only)
        vmovdqu xmm5,xmmword ptr [TestVal1]
        vmovdqa xmmword ptr [rbp-16],xmm5   ;save xmm5 to LocalVar2A/2B
        mov qword ptr [rbp],0aah            ;save 0xaa to LocalVar1A
        mov qword ptr [rbp+8],0bbh          ;save 0xbb to LocalVar1B
        mov qword ptr [rbp+16],0cch         ;save 0xcc to LocalVar1C
        mov qword ptr [rbp+24],0ddh         ;save 0xdd to LocalVar1D

; Save argument values to home area (optional)
        mov [rbp+RBP_RA+8],rcx
        mov [rbp+RBP_RA+16],rdx
        mov [rbp+RBP_RA+24],r8
        mov [rbp+RBP_RA+32],r9

; Perform required initializations for processing loop
        test r8d,r8d                        ;is n <= 0?
        jle Done                            ;jump if n <= 0

        mov rbx,-8                          ;rbx = offset to array elements
        xor r10,r10                         ;r10 = sum_a
        xor r11,r11                         ;r11 = sum_b
        mov r12,1                           ;r12 = prod_a
        mov r13,1                           ;r13 = prod_b

; Compute the array sums and products
@@:     add rbx,8                           ;rbx = offset to next elements
        mov rax,[rcx+rbx]                   ;rax = a[i]
        add r10,rax                         ;update sum_a
        imul r12,rax                        ;update prod_a
        mov rax,[rdx+rbx]                   ;rax = b[i]
        add r11,rax                         ;update sum_b
        imul r13,rax                        ;update prod_b

        sub r8d,1                           ;n -= 1
        jnz @B                              ;repeat until done

; Save the final results
        mov [r9],r10                        ;save sum_a
        mov rax,[rbp+RBP_RA+40]             ;rax = ptr to sum_b
        mov [rax],r11                       ;save sum_b
        mov rax,[rbp+RBP_RA+48]             ;rax = ptr to prod_a
        mov [rax],r12                       ;save prod_a
        mov rax,[rbp+RBP_RA+56]             ;rax = ptr to prod_b
        mov [rax],r13                       ;save prod_b

; Function epilogue
Done:   lea rsp,[rbp+STK_LOCAL1+STK_PAD]    ;restore rsp
        pop r13                             ;restore non-volatile GP registers
        pop r12
        pop rbx
        pop rbp
        ret

CalcSumProd_avx endp
        end
