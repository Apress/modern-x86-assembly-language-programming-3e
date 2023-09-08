;------------------------------------------------------------------------------
; Ch14_07_fasm.asm
;------------------------------------------------------------------------------

ConstVals   segment readonly align(64) 'const'

; Indices for matrix permutations
MatIndCol0  dword 0, 4,  8, 12, 0, 4,  8, 12, 0, 4,  8, 12, 0, 4,  8, 12
MatIndCol1  dword 1, 5,  9, 13, 1, 5,  9, 13, 1, 5,  9, 13, 1, 5,  9, 13
MatIndCol2  dword 2, 6, 10, 14, 2, 6, 10, 14, 2, 6, 10, 14, 2, 6, 10, 14
MatIndCol3  dword 3, 7, 11, 15, 3, 7, 11, 15, 3, 7, 11, 15, 3, 7, 11, 15

; Indices for vector permutations
VecIndW     dword 0, 0, 0, 0, 4, 4, 4, 4,  8,  8,  8,  8, 12, 12, 12, 12
VecIndX     dword 1, 1, 1, 1, 5, 5, 5, 5,  9,  9,  9,  9, 13, 13, 13, 13
VecIndY     dword 2, 2, 2, 2, 6, 6, 6, 6, 10, 10, 10, 10, 14, 14, 14, 14
VecIndZ     dword 3, 3, 3, 3, 7, 7, 7, 7, 11, 11, 11, 11, 15, 15, 15, 15
ConstVals   ends

;------------------------------------------------------------------------------
; void MatVecMulF32_avx512(Vec4x1_F32* vec_b, const float* m,
;   const Vec4x1_F32* vec_a, size_t num_vec);
;------------------------------------------------------------------------------

NVPI    equ     4                           ;num_vec_per_iteration
SIZEVEC equ     16                          ;size (bytes) of Vec4x1_F32 struct

        .code
MatVecMulF32_avx512 proc

; Validate arguments
        test r9,r9
        jz Done                             ;jump if num_vec == 0

        test rcx,3fh
        jnz Done                            ;jump if vec_b not 64b aligned
        test rdx,3fh
        jnz Done                            ;jump if m not 64b aligned
        test r8,3fh
        jnz Done                            ;jump if vec_a 64b aligned

; Load indices for matrix and vector permutations
        vmovdqa32 zmm16,zmmword ptr [MatIndCol0]    ;m col 0 indices
        vmovdqa32 zmm17,zmmword ptr [MatIndCol1]    ;m col 1 indices
        vmovdqa32 zmm18,zmmword ptr [MatIndCol2]    ;m col 2 indices
        vmovdqa32 zmm19,zmmword ptr [MatIndCol3]    ;m col 3 indices

        vmovdqa32 zmm24,zmmword ptr [VecIndW]       ;W component indices
        vmovdqa32 zmm25,zmmword ptr [VecIndX]       ;X component indices
        vmovdqa32 zmm26,zmmword ptr [VecIndY]       ;Y component indices
        vmovdqa32 zmm27,zmmword ptr [VecIndZ]       ;Z component indices

; Load source matrix m and permute NVPI copies of each column
        vmovaps zmm0,zmmword ptr [rdx]      ;zmm0  = matrix m
        vpermps zmm20,zmm16,zmm0            ;zmm20 = m col 0
        vpermps zmm21,zmm17,zmm0            ;zmm21 = m col 1
        vpermps zmm22,zmm18,zmm0            ;zmm22 = m col 2
        vpermps zmm23,zmm19,zmm0            ;zmm23 = m col 3

        mov rax,-SIZEVEC                    ;initialize offset for Loop2
        cmp r9,NVPI                         ;num_vec >= NVPI?
        jb Loop2                            ;jump if no
        mov rax,-SIZEVEC*NVPI               ;initialize offset for Loop1

; Calculate matrix-vector products using SIMD arithmetic
        align 16
Loop1:  add rax,SIZEVEC*NVPI                ;update offset
        vmovaps zmm4,zmmword ptr [r8+rax]   ;zmm4 = vec_a[i:i+NVPI-1]

        vpermps zmm0,zmm24,zmm4             ;zmm0 = vec_a W components
        vpermps zmm1,zmm25,zmm4             ;zmm1 = vec_a X components
        vpermps zmm2,zmm26,zmm4             ;zmm2 = vec_a Y components
        vpermps zmm3,zmm27,zmm4             ;zmm3 = vec_a Z components

; Perform matrix-vector multiplications (NVPI vectors)
        vmulps zmm4,zmm20,zmm0              ;zmm4  = m col 0 * W
        vfmadd231ps zmm4,zmm21,zmm1         ;zmm4 += m col 1 * X
        vfmadd231ps zmm4,zmm22,zmm2         ;zmm4 += m col 2 * Y
        vfmadd231ps zmm4,zmm23,zmm3         ;zmm4 += m col 3 * Z

; Save matrix-vector products (NVPI vectors)
        vmovntps zmmword ptr [rcx+rax],zmm4 ;save vec_b[i:i+NVPI-1]

        sub r9,NVPI                         ;num_vec -= NVPI
        cmp r9,NVPI                         ;num_vec >= NVPI?
        jae Loop1                           ;jump if yes

; Test for more vectors
        test r9,r9                          ;num_vec == 0?
        jz Done                             ;jump if yes

        add rax,SIZEVEC*NVPI-SIZEVEC        ;adjust i for Loop2

; Calculate remaining matrix-vector products
        align 16
Loop2:  add rax,SIZEVEC                         ;update offset
        vbroadcastss xmm0,real4 ptr [r8+rax]    ;xmm0 = vec_a[i] W components
        vbroadcastss xmm1,real4 ptr [r8+rax+4]  ;xmm1 = vec_a[i] X components
        vbroadcastss xmm2,real4 ptr [r8+rax+8]  ;xmm2 = vec_a[i] Y components
        vbroadcastss xmm3,real4 ptr [r8+rax+12] ;xmm3 = vec_a[i] Z components

        vmulps xmm4,xmm20,xmm0                  ;xmm4  = m col 0 * W
        vfmadd231ps xmm4,xmm21,xmm1             ;xmm4 += m col 1 * X
        vfmadd231ps xmm4,xmm22,xmm2             ;xmm4 += m col 2 * Y
        vfmadd231ps xmm4,xmm23,xmm3             ;xmm4 += m col 3 * Z

        vmovntps xmmword ptr [rcx+rax],xmm4     ;save vec_b[i]

        sub r9,1                                ;num_vec -= 1
        jnz Loop2                               ;repeat until done

Done:   vzeroupper
        ret
MatVecMulF32_avx512 endp
        end
