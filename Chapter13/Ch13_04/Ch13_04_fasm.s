;------------------------------------------------------------------------------
; Ch13_04_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"
        %include "cmpequ_int.asmh"

; Image statistics structure. This must match the structure that's
; defined in Ch13_04.h

struc IS
.PixelBuffer         resq 1
.PixelMinVal         resd 1
.PixelMaxVal         resd 1
.NumPixels           resq 1
.NumPixelsInRange    resq 1
.PixelSum            resq 1
.PixelSumSquares     resq 1
.PixelMean           resq 1
.PixelStDev          resq 1
endstruc

;------------------------------------------------------------------------------
; UpdateSumVars_M - update pixel_sums (zmm16) and pixel_sum_sqs (zmm17)
;
; Macro Parameters:
;   EI (%1)         pixel block extract index
;
; Registers:
;   zmm5            pixel buffer values pb[i:i+63]
;   zmm16           pixel_sums (16 dwords)
;   zmm17           pixel_sum_sqs (16 dwords)
;   zmm18/xmm18     scratch registers
;------------------------------------------------------------------------------

%macro  UpdateSumVars_M 1
        vextracti64x2 xmm18,zmm5,%1         ;extract pixels pb[i+EI*16:i+EI*16+15]
        vpmovzxbd zmm18,xmm18               ;promote to dwords
        vpaddd zmm16,zmm16,zmm18            ;update pixel_sums
        vpmulld zmm18,zmm18,zmm18
        vpaddd zmm17,zmm17,zmm18            ;update pixel_sum_sqs
%endmacro

;------------------------------------------------------------------------------
; UpdateQwords_M - add dword elements in ZmmSrc to qword sums in ZmmDes
;
; Macro Parameters:
;   ZmmDes (%1)     zmm destination register
;   ZmmSrc (%2)     zmm source register
;   YmmSrc (%3)     ymm source register (must be same number as ZmmSrc)
;
; Registers:
;   zmm31/ymm31     scratch registers
;------------------------------------------------------------------------------

%macro  UpdateQwords_M 3
        vextracti32x8 ymm31,%2,1            ;extract ZmmSrc dwords 8:15
        vpaddd ymm31,ymm31,%3               ;add ZmmSrc dwords 8:15 and 0:7
        vpmovzxdq zmm31,ymm31               ;promote to qwords
        vpaddq %1,%1,zmm31                  ;update ZmmDes qwords 0:7
%endmacro

;------------------------------------------------------------------------------
; SumQwords_M  - sum qword elements in ZmmSrc
;
; Macro Parameters:
;   GprDes (%1)     destination general-purpose register
;   GprTmp (%2)     temp general-purpose register (must be different than GprDes)
;   ZmmSrc (%3)     zmm source register
;   YmmSrc (%4)     ymm source register (must be same number as ZmmSrc)
;
; Registers:
;   ymm30/xmm30     scratch registers
;   xmm31           scratch register
;------------------------------------------------------------------------------

%macro SumQwords_M 4
        vextracti64x4 ymm30,%3,1        ;ymm30 = ZmmSrc qword elements 4:7
        vpaddq ymm30,ymm30,%4           ;sum ZmmSrc qwords 4:7 and 0:3
        vextracti64x2 xmm31,ymm30,1     ;xmm31 = ymm30 qwords 2:3
        vpaddq xmm31,xmm31,xmm30        ;xmm31 = sum of ymm30 qwords

        vpextrq %2,xmm31,0              ;extract xmm31 qword 0
        vpextrq %1,xmm31,1              ;extract xmm31 qword 1
        add %1,%2                       ;GprDes = scalar qword sum
%endmacro

;------------------------------------------------------------------------------
; void CalcImageStats_avx512(ImageStats& im_stats);
;------------------------------------------------------------------------------

NSE     equ 64                                  ;num_simd_elements

        section .text
        extern CheckArgs

        global CalcImageStats_avx512
CalcImageStats_avx512:

; Validate values in im_stats
        push rdi                                ;save im_stats
        call CheckArgs                          ;validate values im_stats
        pop rdi                                 ;restore im_stats
        or eax,eax
        jz Done                                 ;jump if CheckArgs failed

; Initialize
        mov rdx,[rdi+IS.PixelBuffer]            ;rdx = pixel_buffer (pb)
        mov r8,[rdi+IS.NumPixels]               ;r8 = num_pixels

        vpbroadcastb zmm0,[rdi+IS.PixelMinVal]  ;pixel_min_vals
        vpbroadcastb zmm1,[rdi+IS.PixelMaxVal]  ;pixel_max_vals

        vpxorq zmm2,zmm2,zmm2                   ;zmm2 = pixel_sums (8 qwords)
        vpxorq zmm3,zmm3,zmm3                   ;zmm3 = pixel_sum_sqs (8 qwords)

        xor r9,r9                               ;r9 = num_pixels_in_range
        lea rax,[rdx+r8-NSE]                    ;rax = addr of final pixel block
        sub rdx,NSE                             ;adjust pb for Loop1

;------------------------------------------------------------------------------
; Registers used in code below:
;
;   rax     &pixel_buffer[num_pixels]   zmm0    pixel_min_vals
;   rdi     im_stats                    zmm1    pixel_max_vals
;   rdx     pixel_buffer                zmm2    pixel_sums (8 qwords)
;   r8      num_pixels                  zmm3    pixel_sum_sqs (8 qwords)
;   r9      num_pixels_in_range         zmm4    pixel values
;   r10     scratch register            zmm5    pixel values in range (or zero)
;   r11     scratch register            zmm16 - zmm18 scratch registers
;------------------------------------------------------------------------------

; Load next block of 64 pixels, calc in-range pixels
        align 16
Loop1:  add rdx,NSE                             ;rdx = &pb[i:i+63]
        vmovdqa64 zmm4,[rdx]                    ;load pb[i:i+63]
        vpcmpub k1,zmm4,zmm0,CMP_GE             ;k1 = mask of pixels GE PixelMinVal
        vpcmpub k2,zmm4,zmm1,CMP_LE             ;k2 = mask of pixels LE PixelMaxVal
        kandq k3,k1,k2                          ;k3 = mask of in-range pixels
        vmovdqu8 zmm5{k3}{z},zmm4               ;zmm5 = pixels in range (or zero)

        kmovq r10,k3                            ;r10 = in-range mask
        popcnt r10,r10                          ;r10 = number of in-range pixels
        add r9,r10                              ;update num_pixels_in_range

; Update pixel_sums and pixel_sums_sqs
        vpxord zmm16,zmm16,zmm16                ;loop pixel_sums (16 dwords)
        vpxord zmm17,zmm17,zmm17                ;loop pixel_sum_sqs (16 dwords)

        UpdateSumVars_M 0                       ;process pb[i:i+15]
        UpdateSumVars_M 1                       ;process pb[i+16:i+31]
        UpdateSumVars_M 2                       ;process pb[i+32:i+47]
        UpdateSumVars_M 3                       ;process pb[i+48:i+63]

        UpdateQwords_M zmm2,zmm16,ymm16         ;update pixel_sums
        UpdateQwords_M zmm3,zmm17,ymm17         ;update pixel_sum_sqs

        cmp rdx,rax                             ;more pixels?
        jb Loop1                                ;jump if yes

; Calculate final image statistics
        SumQwords_M r10,rax,zmm2,ymm2           ;r10 = pixel_sum
        SumQwords_M r11,rax,zmm3,ymm3           ;r11 = pixel_sum_sqs

        mov [rdi+IS.NumPixelsInRange],r9        ;save num_pixels_in_range
        mov [rdi+IS.PixelSum],r10               ;save pixel_sum
        mov [rdi+IS.PixelSumSquares],r11        ;save pixel_sum_sqs

        vcvtusi2sd xmm16,xmm16,r9               ;num_pixels_in_range as F64
        sub r9,1                                ;r9 = num_pixels_in_range - 1
        vcvtusi2sd xmm17,xmm16,r9               ;num_pixels_in_range - 1 as F64
        vcvtusi2sd xmm18,xmm18,r10              ;pixel_sum as F64
        vcvtusi2sd xmm19,xmm19,r11              ;pixel_sum_sqs as F64

        vmulsd xmm0,xmm16,xmm19                 ;num_pixels_in_range * pixel_sum_sqs
        vmulsd xmm1,xmm18,xmm18                 ;pixel_sum * pixel_sum
        vsubsd xmm2,xmm0,xmm1                   ;variance numerator
        vmulsd xmm3,xmm16,xmm17                 ;variance denominator
        vdivsd xmm4,xmm2,xmm3                   ;variance

        vdivsd xmm0,xmm18,xmm16                 ;calc mean
        vmovsd [rdi+IS.PixelMean],xmm0          ;save mean

        vsqrtsd xmm1,xmm1,xmm4                  ;calc st_dev
        vmovsd [rdi+IS.PixelStDev],xmm1         ;save st_dev

Done:   vzeroupper
        ret
