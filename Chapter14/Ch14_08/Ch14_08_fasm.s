;------------------------------------------------------------------------------
; Ch14_08_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

; Indices for matrix permutations
            section .rdata align=64
MatIndCol0  dq 0, 4,  8, 12, 0, 4,  8, 12
MatIndCol1  dq 1, 5,  9, 13, 1, 5,  9, 13
MatIndCol2  dq 2, 6, 10, 14, 2, 6, 10, 14
MatIndCol3  dq 3, 7, 11, 15, 3, 7, 11, 15

; Indices for vector permutations
VecIndW     dq 0, 0, 0, 0, 4, 4, 4, 4
VecIndX     dq 1, 1, 1, 1, 5, 5, 5, 5
VecIndY     dq 2, 2, 2, 2, 6, 6, 6, 6
VecIndZ     dq 3, 3, 3, 3, 7, 7, 7, 7

;------------------------------------------------------------------------------
; void MatVecMulF64_avx512(Vec4x1_F64* vec_b, const float* m,
;   const Vec4x1_F64* vec_a, size_t num_vec);
;------------------------------------------------------------------------------

NVPI    equ     2                           ;num_vec_per_iteration
SIZEVEC equ     32                          ;size (bytes) of Vec4x1_F64 struct

        section .text

        global MatVecMulF64_avx512
MatVecMulF64_avx512:

; Validate arguments
        test rcx,rcx
        jz Done                             ;jump if num_vec == 0

        test rdi,3fh
        jnz Done                            ;jump if vec_b not 64b aligned
        test rsi,3fh
        jnz Done                            ;jump if m not 64b aligned
        test rdx,3fh
        jnz Done                            ;jump if vec_a 64b aligned

; Load indices for matrix and vector permutations
        vmovdqa64 zmm20,[MatIndCol0]        ;m col 0 indices
        vmovdqa64 zmm21,[MatIndCol1]        ;m col 1 indices
        vmovdqa64 zmm22,[MatIndCol2]        ;m col 2 indices
        vmovdqa64 zmm23,[MatIndCol3]        ;m col 3 indices

        vmovdqa64 zmm24,[VecIndW]           ;W component indices
        vmovdqa64 zmm25,[VecIndX]           ;X component indices
        vmovdqa64 zmm26,[VecIndY]           ;Y component indices
        vmovdqa64 zmm27,[VecIndZ]           ;Z component indices

; Load source matrix m and permute NVPI copies of each column
        vmovapd zmm0,[rsi]                  ;zmm0  = matrix m (rows 0 & 1)
        vmovapd zmm1,[rsi+64]               ;zmm1  = matrix m (rows 2 & 3)
        vpermi2pd zmm20,zmm0,zmm1           ;zmm20 = m col 0
        vpermi2pd zmm21,zmm0,zmm1           ;zmm21 = m col 1
        vpermi2pd zmm22,zmm0,zmm1           ;zmm22 = m col 2
        vpermi2pd zmm23,zmm0,zmm1           ;zmm23 = m col 3

        xor eax,eax                         ;initialize offset for FinalV
        cmp rcx,NVPI                        ;num_vec >= NVPI?
        jb FinalV                           ;jump if no
        mov rax,-SIZEVEC*NVPI               ;initialize offset for Loop1

; Calculate matrix-vector products using SIMD arithmetic
        align 16
Loop1:  add rax,SIZEVEC*NVPI                ;update offset
        vmovapd zmm4,[rdx+rax]              ;zmm4 = vec_a[i:i+NVPI-1]
        vpermpd zmm0,zmm24,zmm4             ;zmm0 = vec_a W components
        vpermpd zmm1,zmm25,zmm4             ;zmm1 = vec_a X components
        vpermpd zmm2,zmm26,zmm4             ;zmm2 = vec_a Y components
        vpermpd zmm3,zmm27,zmm4             ;zmm3 = vec_a Z components

; Perform matrix-vector multiplications (NVPI vectors)
        vmulpd zmm4,zmm20,zmm0              ;zmm4  = m col 0 * W
        vfmadd231pd zmm4,zmm21,zmm1         ;zmm4 += m col 1 * X
        vfmadd231pd zmm4,zmm22,zmm2         ;zmm4 += m col 2 * Y
        vfmadd231pd zmm4,zmm23,zmm3         ;zmm4 += m col 3 * Z

; Save matrix-vector products (NVPI vectors)
        vmovntpd [rdi+rax],zmm4             ;save vec_b[i:i+NVPI-1]

        sub rcx,NVPI                        ;num_vec -= NVPI
        cmp rcx,NVPI                        ;num_vec >= NVPI?
        jae Loop1                           ;jump if yes

; Test for more vectors
        test rcx,rcx                        ;num_vec == 0?
        jz Done                             ;jump if yes

        add rax,SIZEVEC*NVPI                ;adjust offset for final vec

; Calculate final matrix-vector product
FinalV: vbroadcastsd ymm0,[rdx+rax]         ;ymm0 = vec_a[i] W components
        vbroadcastsd ymm1,[rdx+rax+8]       ;ymm1 = vec_a[i] X components
        vbroadcastsd ymm2,[rdx+rax+16]      ;ymm2 = vec_a[i] Y components
        vbroadcastsd ymm3,[rdx+rax+24]      ;ymm3 = vec_a[i] Z components

        vmulpd ymm4,ymm20,ymm0              ;ymm4  = m col 0 * W
        vfmadd231pd ymm4,ymm21,ymm1         ;ymm4 += m col 1 * X
        vfmadd231pd ymm4,ymm22,ymm2         ;ymm4 += m col 2 * Y
        vfmadd231pd ymm4,ymm23,ymm3         ;ymm4 += m col 3 * Z

        vmovntpd [rdi+rax],ymm4             ;save vec_b[i]

Done:   vzeroupper
        ret
