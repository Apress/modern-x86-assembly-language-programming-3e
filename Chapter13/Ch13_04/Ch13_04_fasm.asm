;------------------------------------------------------------------------------
; Ch13_04_fasm.asm
;------------------------------------------------------------------------------

            include <cmpequ_int.asmh>
            include <MacrosX86-64-AVX.asmh>

; Image statistics structure. This must match the structure that's
; defined in Ch13_04.h

IS                  struct
PixelBuffer         qword ?
PixelMinVal         dword ?
PixelMaxVal         dword ?
NumPixels           qword ?
NumPixelsInRange    qword ?
PixelSum            qword ?
PixelSumSquares     qword ?
PixelMean           real8 ?
PixelStDev          real8 ?
IS                  ends

;------------------------------------------------------------------------------
; UpdateSumVars_M - update pixel_sums (zmm16) and pixel_sum_sqs (zmm17)
;
; Macro Parameters:
;   EI              pixel block extract index
;
; Registers:
;   zmm5            pixel buffer values pb[i:i+63]
;   zmm16           pixel_sums (16 dwords)
;   zmm17           pixel_sum_sqs (16 dwords)
;   zmm18/xmm18     scratch registers
;------------------------------------------------------------------------------

UpdateSumVars_M macro EI
        vextracti64x2 xmm18,zmm5,EI         ;extract pixels pb[i+EI*16:i+EI*16+15]
        vpmovzxbd zmm18,xmm18               ;promote to dwords
        vpaddd zmm16,zmm16,zmm18            ;update pixel_sums
        vpmulld zmm18,zmm18,zmm18
        vpaddd zmm17,zmm17,zmm18            ;update pixel_sum_sqs
        endm

;------------------------------------------------------------------------------
; UpdateQwords_M - add dword elements in ZmmSrc to qword sums in ZmmDes
;
; Macro Parameters:
;   ZmmDes          zmm destination register
;   ZmmSrc          zmm source register
;   YmmSrc          ymm source register (must be same number as ZmmSrc)
;
; Registers:
;   zmm31/ymm31     scratch registers
;------------------------------------------------------------------------------

UpdateQwords_M macro ZmmDes,ZmmSrc,YmmSrc
        vextracti32x8 ymm31,ZmmSrc,1        ;extract ZmmSrc dwords 8:15
        vpaddd ymm31,ymm31,YmmSrc           ;add ZmmSrc dwords 8:15 and 0:7
        vpmovzxdq zmm31,ymm31               ;promote to qwords
        vpaddq ZmmDes,ZmmDes,zmm31          ;update ZmmDes qwords 0:7
        endm

;------------------------------------------------------------------------------
; SumQwords_M  - sum qword elements in ZmmSrc
;
; Macro Parameters:
;   GprDes          destination general-purpose register
;   GprTmp          temp general-purpose register (must be different than GprDes)
;   ZmmSrc          zmm source register
;   YmmSrc          ymm source register (must be same number as ZmmSrc)
;
; Registers:
;   ymm30/xmm30     scratch registers
;   xmm31           scratch register
;------------------------------------------------------------------------------

SumQwords_M macro GprDes,GprTmp,ZmmSrc,YmmSrc
        vextracti64x4 ymm30,ZmmSrc,1        ;ymm30 = ZmmSrc qword elements 4:7
        vpaddq ymm30,ymm30,YmmSrc           ;sum ZmmSrc qwords 4:7 and 0:3
        vextracti64x2 xmm31,ymm30,1         ;xmm31 = ymm30 qwords 2:3
        vpaddq xmm31,xmm31,xmm30            ;xmm31 = sum of ymm30 qwords

        vpextrq GprTmp,xmm31,0              ;extract xmm31 qword 0
        vpextrq GprDes,xmm31,1              ;extract xmm31 qword 1
        add GprDes,GprTmp                   ;GprDes = scalar qword sum
        endm

;------------------------------------------------------------------------------
; void CalcImageStats_avx512(ImageStats& im_stats);
;------------------------------------------------------------------------------

NSE     equ 64                                  ;num_simd_elements

        extern CheckArgs:proc

        .code
CalcImageStats_avx512 proc frame
        CreateFrame_M CIS_,0,0
        EndProlog_M

; Validate values in im_stats
        mov qword ptr [rbp+CIS_OffsetHomeRCX],rcx   ;save im_stats

        sub rsp,32                                  ;allocate CheckArgs home area
        call CheckArgs                              ;validate values im_stats
        or eax,eax
        jz Done                                     ;jump if CheckArgs failed

        mov rcx,qword ptr [rbp+CIS_OffsetHomeRCX]   ;rcx = im_stats 

; Initialize
        mov rdx,qword ptr [rcx+IS.PixelBuffer]  ;rdx = pixel_buffer (pb)   
        mov r8,qword ptr [rcx+IS.NumPixels]     ;r8 = num_pixels

        vpbroadcastb zmm0,byte ptr [rcx+IS.PixelMinVal]   ;pixel_min_vals
        vpbroadcastb zmm1,byte ptr [rcx+IS.PixelMaxVal]   ;pixel_max_vals

        vpxorq zmm2,zmm2,zmm2                   ;zmm2 = pixel_sums (8 qwords)
        vpxorq zmm3,zmm3,zmm3                   ;zmm3 = pixel_sum_sqs (8 qwords)

        xor r9,r9                               ;r9 = num_pixels_in_range
        lea rax,[rdx+r8-NSE]                    ;rax = addr of final pixel block
        sub rdx,NSE                             ;adjust pb for Loop1

;------------------------------------------------------------------------------
; Registers used in code below:
;
;   rax     &pixel_buffer[num_pixels]   zmm0    pixel_min_vals
;   rcx     im_stats                    zmm1    pixel_max_vals
;   rdx     pixel_buffer                zmm2    pixel_sums (8 qwords)
;   r8      num_pixels                  zmm3    pixel_sum_sqs (8 qwords)
;   r9      num_pixels_in_range         zmm4    pixel values
;   r10     scratch register            zmm5    pixel values in range (or zero)
;   r11     scratch register            zmm16 - zmm18 scratch registers
;------------------------------------------------------------------------------

; Load next block of 64 pixels, calc in-range pixels
        align 16
Loop1:  add rdx,NSE                             ;rdx = &pb[i:i+63]
        vmovdqa64 zmm4,zmmword ptr [rdx]        ;load pb[i:i+63]
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

        mov qword ptr [rcx+IS.NumPixelsInRange],r9  ;save num_pixels_in_range
        mov qword ptr [rcx+IS.PixelSum],r10         ;save pixel_sum
        mov qword ptr [rcx+IS.PixelSumSquares],r11  ;save pixel_sum_sqs

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

        vdivsd xmm0,xmm18,xmm16                     ;calc mean
        vmovsd real8 ptr [rcx+IS.PixelMean],xmm0    ;save mean

        vsqrtsd xmm1,xmm1,xmm4                      ;calc st_dev
        vmovsd real8 ptr [rcx+IS.PixelStDev],xmm1   ;save st_dev

Done:   vzeroupper
        DeleteFrame_M
        ret

CalcImageStats_avx512 endp
        end
