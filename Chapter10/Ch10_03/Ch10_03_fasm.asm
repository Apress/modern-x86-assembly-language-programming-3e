;------------------------------------------------------------------------------
; Ch10_03_fasm.asm
;------------------------------------------------------------------------------

; The members of CD must match the corresponding structure
; that's declared in Ch10_03.h

CD               struct
PbSrc            qword ?
PbDes            qword ?
NumPixels        qword ?
NumClippedPixels qword ?
ThreshLo         byte ?
ThreshHi         byte ?
CD               ends

;------------------------------------------------------------------------------
; void ClipPixels_avx2(ClipData* clip_data);
;------------------------------------------------------------------------------

NSE     equ 32                              ;num_simd_elements

        .code
ClipPixels_avx2 proc frame

; Function prologue
        push rbx
        .pushreg rbx
        push rsi
        .pushreg rsi
        push rdi
        .pushreg rdi
        .endprolog

; Initialize
        xor r11,r11                             ;r11 = NumClippedPixels

        mov r8,[rcx+CD.PbSrc]                   ;r8 = PbSrc
        test r8,1fh
        jnz Done                                ;jump if PbSrc not 32b aligned

        mov r9,[rcx+CD.PbDes]                   ;r9 = PbDes
        test r9,1fh
        jnz Done                                ;jump if PbDes not 32b aligned

        mov r10,[rcx+CD.NumPixels]              ;r10 = NumPixels
        test r10,r10                            ;NumPixels == 0?
        jz Done                                 ;jump if yes

        vpbroadcastb ymm4,[rcx+CD.ThreshLo]     ;packed ThreshLo
        vpbroadcastb ymm5,[rcx+CD.ThreshHi]     ;packed ThreshHi

        mov rax,-1                              ;rax = index (i) for Loop2
        cmp r10,NSE                             ;NumPixels >= NSE?
        jb Init2                                ;jump if no
        mov rax,-NSE                            ;rax = index (i) for Loop1

; First pixel clipping for-loop using SIMD arithmetic
Loop1:  add rax,NSE                             ;i += NSE
        vmovdqa ymm0,ymmword ptr [r8+rax]       ;load PbSrc[i:i+31]
        vpmaxub ymm1,ymm0,ymm4                  ;clip to ThreshLo
        vpminub ymm2,ymm1,ymm5                  ;clip to ThreshHi
        vmovdqa ymmword ptr [r9+rax],ymm2       ;save PbDes[i:i+31] (clipped pixels)

        vpcmpeqb ymm3,ymm2,ymm0                 ;compare clipped to original
        vpmovmskb edx,ymm3                      ;edx = mask of non-clipped pixels
        not edx                                 ;edx = mask of clipped pixels
        popcnt esi,edx                          ;esi = num clipped this iteration
        add r11,rsi                             ;update NumClippedPixels

        sub r10,NSE                             ;NumPixels -= NSE
        cmp r10,NSE                             ;NumPixels >= NSE?
        jae Loop1                               ;jump if yes

        test r10,r10                            ;NumPixels == 0?
        jz Done                                 ;jump if yes

; Perform initializations for Loop2
        add rax,NSE-1                           ;adjust i for Loop2

Init2:  movzx esi,byte ptr [rcx+CD.ThreshLo]    ;esi = ThreshLo
        movzx edi,byte ptr [rcx+CD.ThreshHi]    ;edi = ThreshHi
        xor ebx,ebx                             ;rbx = temp clipped count

; Second for-loop for residual pixels (if any) using scalar instructions
Loop2:  add rax,1                               ;i += 1
        movzx edx,byte ptr [r8+rax]             ;load next PbSrc[i]
        cmp edx,esi                             ;PbSrc[i] < ThreshLo?
        cmovb edx,esi                           ;edx = min(PbSrc[i], ThreshLo)
        setb bl                                 ;rbx = 1 if pixel clipped else 0
        jb Save2

        cmp edx,edi                             ;PbSrc[i] > ThreshHi?
        cmova edx,edi                           ;edx = max(PbSrc[i], ThreshHi)
        seta bl                                 ;rbx = 1 if pixel clipped else 0

Save2:  mov byte ptr [r9+rax],dl                ;save pixel to PbDes[i]
        add r11,rbx                             ;update clipped pixel count

        sub r10,1                               ;NumPixels -= 1
        jnz Loop2                               ;repeat until done

Done:   mov [rcx+CD.NumClippedPixels],r11       ;save NumClippedPixels

; Function epilogue
        vzeroupper
        pop rdi
        pop rsi
        pop rbx
        ret

ClipPixels_avx2 endp
        end
