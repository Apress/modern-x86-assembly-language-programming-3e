;------------------------------------------------------------------------------
; Ch16_04_fasm.asm
;------------------------------------------------------------------------------

        include <MacrosX86-64-AVX.asmh>

; VecSOA structure. This structure must match the structure that's
; defined in Ch16_04.h

VecSOA      struct
NumVec      qword ?
X           qword ?
Y           qword ?
Z           qword ?
VecSOA      ends

;------------------------------------------------------------------------------
; bool VecCrossProducts_avx2(VecSOA* c, const VecSOA* a, const VecSOA* b);
;------------------------------------------------------------------------------

NSE     equ 4                           ;num_simd_elements
                                        ;(num CrossProds per iteration of Loop1)

        extern CheckArgs:proc

        .code
VecCrossProducts_avx2 proc frame
        CreateFrame_M CP_,0,48,r12,r13,r14,r15
        SaveXmmRegs_M xmm6,xmm7,xmm8
        EndProlog_M

; Preserve argument values in non-volatile GP registers
        mov r13,rcx                         ;arg c
        mov r14,rdx                         ;arg a
        mov r15,r8                          ;arg b

; Validate arguments
        sub rsp,32                          ;allocate home area
        call CheckArgs
        or eax,eax                          ;arguments valid?
        jz Done                             ;jump if no

; Perform required initializations
        mov r8,[r13+VecSOA.NumVec]          ;number of vector CPs to calculate

        mov r9,[r13+VecSOA.X]               ;c.X pointer
        mov rcx,[r13+VecSOA.Y]              ;c.Y pointer
        mov rdx,[r13+VecSOA.Z]              ;c.Z pointer

        mov r10,[r14+VecSOA.X]              ;a.X pointer
        mov r11,[r14+VecSOA.Y]              ;a.Y pointer
        mov r12,[r14+VecSOA.Z]              ;a.Z pointer

        mov r13,[r15+VecSOA.X]              ;b.X pointer
        mov r14,[r15+VecSOA.Y]              ;b.Y pointer
        mov r15,[r15+VecSOA.Z]              ;b.Z pointer

        mov rax,-NSE                        ;initialize i

; Load next block of vectors
Loop1:  add rax,NSE                             ;i += NSE

        vmovapd ymm0,ymmword ptr [r10+rax*8]    ;ymm0 = a.X[i:i+NSE-1]
        vmovapd ymm1,ymmword ptr [r11+rax*8]    ;ymm1 = a.Y[i:i+NSE-1]
        vmovapd ymm2,ymmword ptr [r12+rax*8]    ;ymm2 = a.Z[i:i+NSE-1]

        vmovapd ymm3,ymmword ptr [r13+rax*8]    ;ymm3 = b.X[i:i+NSE-1]
        vmovapd ymm4,ymmword ptr [r14+rax*8]    ;ymm4 = b.Y[i:i+NSE-1]
        vmovapd ymm5,ymmword ptr [r15+rax*8]    ;ymm5 = b.Z[i:i+NSE-1]

; Calculate cross products
        vmulpd ymm6,ymm1,ymm5
        vmulpd ymm7,ymm2,ymm4
        vsubpd ymm8,ymm6,ymm7                   ;c.X = a.Y * b.Z - a.Z * b.Y

; Note: VecCrossProductsNT_avx2() uses vmovntpd instead of vmovapd
        vmovapd ymmword ptr [r9+rax*8],ymm8     ;save c.X[i:i+NSE-1]

        vmulpd ymm6,ymm2,ymm3
        vmulpd ymm7,ymm0,ymm5
        vsubpd ymm8,ymm6,ymm7                   ;c.Y = a.Z * b.X - a.X * b.Z

; Note: VecCrossProductsNT_avx2() uses vmovntpd instead of vmovapd
        vmovapd ymmword ptr [rcx+rax*8],ymm8    ;save c.Y[i:i+NSE-1]

        vmulpd ymm6,ymm0,ymm4
        vmulpd ymm7,ymm1,ymm3
        vsubpd ymm8,ymm6,ymm7                   ;c.Z = a.X * b.Y - a.Y * b.X

; Note: VecCrossProductsNT_avx2() uses vmovntpd instead of vmovapd
        vmovapd ymmword ptr [rdx+rax*8],ymm8    ;save c.Z[i:i+NSE-1]

        sub r8,NSE                              ;num_pixels -= NSE
        jnz Loop1                               ;repeat until done

        mov eax,1                               ;set success return code

Done:   vzeroupper
        RestoreXmmRegs_M xmm6,xmm7,xmm8
        DeleteFrame_M r12,r13,r14,r15
        ret
VecCrossProducts_avx2 endp
        end
