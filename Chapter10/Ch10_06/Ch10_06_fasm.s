;------------------------------------------------------------------------------
; Ch10_06_fasm.ssm
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

; Offsets for local histograms on stack
                section .rdata align=32
HistoOffsets    dd  256 * 0, 256 * 1, 256 * 2, 256 * 3
                dd  256 * 4, 256 * 5, 256 * 6, 256 * 7

;------------------------------------------------------------------------------
; void BuildHistogram_avx2(uint32_t* histo, const uint8_t* pixel_buff,
;   size_t num_pixels);
;------------------------------------------------------------------------------

HS      equ     256 * 4                         ;size of each local histogram

        section .text

        global BuildHistogram_avx2
BuildHistogram_avx2:
        mov r11,rsp                             ;save copy of rsp
        mov r8,rdx                              ;r8 = num_pixels
        mov rdx,rsi                             ;rdx = pixel_buff
        mov r10,rdi                             ;r10 = histo

; Validate arguments
        test r10,1fh
        jnz BadArg                              ;jump if histo not 32b aligned
        test rdx,1fh
        jnz BadArg                              ;jump if pixel_buff not 32b aligned

        test r8,r8
        jz BadArg                               ;jump if num_pixels == 0
        test r8,1fh
        jnz BadArg                              ;jump if (num_pixels % 32) != 0

; Allocate stack space for temp histograms
        and rsp,0ffffffffffffffe0h              ;align rsp to 32-byte boundary
        sub rsp,HS*8                            ;allocate local histogram space

; Initialize local histograms to zero
        xor eax,eax                             ;rax = fill value
        mov rdi,rsp                             ;rdi = ptr to local histograms
        mov rcx,HS*8/8                          ;rcx = size in qwords
        rep stosq                               ;zero local histograms

; Initialize
        mov eax,1
        vmovd xmm0,eax
        vpbroadcastd ymm0,xmm0                  ;ymm0 = packed dwords of 1
        vmovdqa ymm1,[HistoOffsets]             ;ymm1 = local histogram offsets

        mov rax,-8                              ;pixel_buffer (pb) array offset

; Build local histograms
Loop1:  add rax,8                               ;i += 8

; Gather entries from local histograms (i.e., histo0[pb[i]] - histo7[pb[i+7]])
        vpmovzxbd ymm2,[rdx+rax]                ;load pb[i:i+7] as dwords
        vpaddd ymm2,ymm2,ymm1                   ;add offsets of local histograms
        vpcmpeqb ymm3,ymm3,ymm3                 ;set vpgatherdd mask to all ones
        vpgatherdd ymm4,[rsp+ymm2*4],ymm3       ;gather local histogram entries

; Update local histograms
        vpaddd ymm4,ymm4,ymm0                   ;histoX[pb[i+X]]+=1 (X=0,1,...7)

; Extract histo4[pb[i+4]] - histo7[pb[i+7]] for later use
        vextracti128 xmm3,ymm2,1                ;histo4 - histo7 offsets
        vextracti128 xmm5,ymm4,1                ;histo4[pb[i+4]] - histo7[pb[i+7]]

; Save histo0[pb[i]] - histo3[pb[i+3]]
        vmovd r9d,xmm2
        vmovd [rsp+r9*4],xmm4                   ;save histo0[pb[i+0]]

        vpsrldq xmm2,xmm2,4
        vpsrldq xmm4,xmm4,4
        vmovd r9d,xmm2
        vmovd [rsp+r9*4],xmm4                   ;save histo1[pb[i+1]]

        vpsrldq xmm2,xmm2,4
        vpsrldq xmm4,xmm4,4
        vmovd r9d,xmm2
        vmovd [rsp+r9*4],xmm4                   ;save histo3[pb[i+2]]

        vpsrldq xmm2,xmm2,4
        vpsrldq xmm4,xmm4,4
        vmovd r9d,xmm2
        vmovd [rsp+r9*4],xmm4                   ;save histo3[pb[i+3]]

; Save histo4[pb[i+4]] - histo7[pb[i+7]]
        vmovd r9d,xmm3
        vmovd [rsp+r9*4],xmm5                   ;save histo4[pb[i+4]]

        vpsrldq xmm3,xmm3,4
        vpsrldq xmm5,xmm5,4
        vmovd r9d,xmm3
        vmovd [rsp+r9*4],xmm5                   ;save histo5[pb[i+5]]

        vpsrldq xmm3,xmm3,4
        vpsrldq xmm5,xmm5,4
        vmovd r9d,xmm3
        vmovd [rsp+r9*4],xmm5                   ;save histo6[pb[i+6]]

        vpsrldq xmm3,xmm3,4
        vpsrldq xmm5,xmm5,4
        vmovd r9d,xmm3
        vmovd [rsp+r9*4],xmm5                   ;save histo7[pb[i+7]]

        sub r8,8                                ;num_pixels -= 8
        jnz Loop1                               ;repeat until done

; Reduce 8 local histograms to final histogram
        mov rax,-8                              ;rax = array offset

Loop2:  add rax,8                               ;i + 8
        vmovdqa ymm0,[rsp+rax*4 + HS*0]         ;load histo0[i:i+7]
        vmovdqa ymm1,[rsp+rax*4 + HS*1]         ;load histo1[i:i+7]
        vpaddd ymm0,ymm0,[rsp+rax*4 + HS*2]     ;add histo2[i:i+7]
        vpaddd ymm1,ymm1,[rsp+rax*4 + HS*3]     ;add histo3[i:i+7] 
        vpaddd ymm0,ymm0,[rsp+rax*4 + HS*4]     ;add histo4[i:i+7] 
        vpaddd ymm1,ymm1,[rsp+rax*4 + HS*5]     ;add histo5[i:i+7] 
        vpaddd ymm0,ymm0,[rsp+rax*4 + HS*6]     ;add histo6[i:i+7] 
        vpaddd ymm1,ymm1,[rsp+rax*4 + HS*7]     ;add histo7[i:i+7]
        vpaddd ymm2,ymm0,ymm1                   ;ymm2 = histo[i:i+7]

        vmovdqa [r10+rax*4],ymm2                ;save histo[i:i+7]

        cmp rax,248                             ;i < 248?
        jb Loop2                                ;jump if yes

        mov eax,1                               ;set success return code

Done:   mov rsp,r11                             ;restore rsp
        vzeroupper
        ret

BadArg: xor eax,eax                             ;set bad argument return code
        jmp Done
