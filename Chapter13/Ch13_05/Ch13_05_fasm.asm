;------------------------------------------------------------------------------
; Ch13_05_fasm.asm
;------------------------------------------------------------------------------

        include <MacrosX86-64-AVX.asmh>

; Offsets for local histograms on stack
ConstVals       segment readonly align(64) 'const'
HistoOffsets    dword   256 *  0, 256 *  1, 256 *  2, 256 *  3
                dword   256 *  4, 256 *  5, 256 *  6, 256 *  7
                dword   256 *  8, 256 *  9, 256 * 10, 256 * 11
                dword   256 * 12, 256 * 13, 256 * 14, 256 * 15

;------------------------------------------------------------------------------
; void BuildHistogram_avx512(uint32_t* histo, const uint8_t* pixel_buff,
;   size_t num_pixels);
;------------------------------------------------------------------------------

HS      equ     256 * 4                         ;size of histogram in bytes

        .code
BuildHistogram_avx512 proc frame
        CreateFrame_M BH_,0,0,rdi
        EndProlog_M

; Validate arguments
        mov r10,rcx                             ;save copy of histo

        test r10,3fh
        jnz BadArg                              ;jump if histo not 64b aligned
        test rdx,3fh
        jnz BadArg                              ;jump if pixel_buff not 64b aligned

        test r8,r8
        jz BadArg                               ;jump if num_pixels == 0
        test r8,3fh
        jnz BadArg                              ;jump if (num_pixels % 64) != 0

; Allocate stack space for temp histograms
        and rsp,0ffffffffffffffc0h              ;align rsp to 64-byte boundary
        sub rsp,HS*16                           ;allocate local histogram space

; Initialize local histograms to zero
        xor eax,eax                             ;rax = fill value
        mov rdi,rsp                             ;rdi = ptr to local histograms
        mov rcx,HS*16/8                         ;rcx = size in qwords
        rep stosq                               ;zero local histograms

; Initialize
        mov eax,1
        vpbroadcastd zmm16,eax                      ;packed dwords of 1
        vmovdqa32 zmm17,zmmword ptr [HistoOffsets]  ;zmm17 = local histogram offsets

        kxnord k0,k0,k0                         ;mask of all ones
        mov rax,-16                             ;pixel_buffer (pb) array offset

; Build local histograms
Loop1:  add rax,16                              ;i += 16

; Gather entries from local histograms (i.e., histo0[pb[i]] - histo15[pb[i+15]])
        vpmovzxbd zmm1,xmmword ptr [rdx+rax]    ;load pb[i:i+15] as dwords
        vpaddd zmm2,zmm1,zmm17                  ;add offsets of local histograms
        kmovd k1,k0                             ;set vpgatherdd mask to all ones
        vpgatherdd zmm3{k1},[rsp+zmm2*4]        ;zmm3 = histo entries

; Update local histograms
        vpaddd zmm4,zmm3,zmm16                  ;add ones

; Save updated histo0[pb[i]] - histo15[pb[i+15]]
        kmovd k2,k0                             ;set vpscatterdd mask to all ones
        vpscatterdd [rsp+zmm2*4]{k2},zmm4       ;save updated histo entries

        sub r8,16                               ;num_pixels -= 16
        jnz Loop1                               ;repeat until done

; Reduce 16 local histograms to final histogram
        mov rax,-16                             ;initialize array offset

Loop2:  add rax,16                                          ;rax += 16
        vmovdqa32 zmm0,zmmword ptr [rsp+rax*4 + HS*0]       ;load histo0[i:i+15]
        vmovdqa32 zmm1,zmmword ptr [rsp+rax*4 + HS*1]       ;load histo1[i:i+15]
        vpaddd zmm0,zmm0,zmmword ptr [rsp+rax*4 + HS*2]     ;add histo2[i:i+15]
        vpaddd zmm1,zmm1,zmmword ptr [rsp+rax*4 + HS*3]     ;add histo3[i:i+15] 
        vpaddd zmm0,zmm0,zmmword ptr [rsp+rax*4 + HS*4]     ;add histo4[i:i+15] 
        vpaddd zmm1,zmm1,zmmword ptr [rsp+rax*4 + HS*5]     ;add histo5[i:i+15] 
        vpaddd zmm0,zmm0,zmmword ptr [rsp+rax*4 + HS*6]     ;add histo6[i:i+15] 
        vpaddd zmm1,zmm1,zmmword ptr [rsp+rax*4 + HS*7]     ;add histo7[i:i+15] 
        vpaddd zmm0,zmm0,zmmword ptr [rsp+rax*4 + HS*8]     ;add histo8[i:i+15] 
        vpaddd zmm1,zmm1,zmmword ptr [rsp+rax*4 + HS*9]     ;add histo9[i:i+15]
        vpaddd zmm0,zmm0,zmmword ptr [rsp+rax*4 + HS*10]    ;add histo10[i:i+15]
        vpaddd zmm1,zmm1,zmmword ptr [rsp+rax*4 + HS*11]    ;add histo11[i:i+15] 
        vpaddd zmm0,zmm0,zmmword ptr [rsp+rax*4 + HS*12]    ;add histo12[i:i+15] 
        vpaddd zmm1,zmm1,zmmword ptr [rsp+rax*4 + HS*13]    ;add histo13[i:i+15] 
        vpaddd zmm0,zmm0,zmmword ptr [rsp+rax*4 + HS*14]    ;add histo14[i:i+15]
        vpaddd zmm1,zmm1,zmmword ptr [rsp+rax*4 + HS*15]    ;add histo15[i:i+15]
        vpaddd zmm2,zmm0,zmm1                               ;zmm2 = histo[i:i+15]

        vmovdqa32 zmmword ptr [r10+rax*4],zmm2              ;save histo[i:i+15]

        cmp rax,240                             ;i < 240
        jb Loop2                                ;jump if yes

        mov eax,1                               ;set success return code

Done:   vzeroupper
        DeleteFrame_M rdi
        ret

BadArg: xor eax,eax                             ;set bad argument return code
        jmp Done

BuildHistogram_avx512 endp
        end
