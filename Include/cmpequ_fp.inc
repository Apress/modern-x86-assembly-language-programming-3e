;-----------------------------------------------------------------------------
; cmpequ_fp.inc
;-----------------------------------------------------------------------------

;-----------------------------------------------------------------------------
; See AMD & Intel programming references manuals for more information
; regarding compare predicates and invalid arithmetic (IA) exceptions.
;
; Compare predicate abbreviations
;   EQ = equal                  NEQ = not equal
;   LT = less than              LE = less than or equal
;   NLT = not less than         NLE = not less than or equal
;   GT = greater than           GE = greater than or equal
;   NGT = not greater than      NGE = not greater than or equal
;   ORD = ordered               UNORD = unordered
;   
; Compare predicate suffix letters
;   O = ordered                 U = unordered
;   S = signaling               Q = non-signaling (quiet)
;-----------------------------------------------------------------------------

;-----------------------------------------------------------------------------
; Predicate     ImmVal      x > y   x < y   x == y  x or y      IA on
;                                                   is a NaN    QNAN
;-----------------------------------------------------------------------------

CMP_EQ_OQ       equ 00h  ;  F       F       T       F           N
CMP_LT_OS       equ 01h  ;  F       T       F       F           Y
CMP_LE_OS       equ 02h  ;  F       T       T       F           Y
CMP_UNORD_Q     equ 03h  ;  F       F       F       T           N
CMP_NEQ_UQ      equ 04h  ;  T       T       F       T           N
CMP_NLT_US      equ 05h  ;  T       F       T       T           Y
CMP_NLE_US      equ 06h  ;  T       F       F       T           Y
CMP_ORD_Q       equ 07h  ;  T       T       T       F           N

CMP_EQ_UQ       equ 08h  ;  F       F       T       T           N
CMP_NGE_US      equ 09h  ;  F       T       F       T           Y
CMP_NGT_US      equ 0ah  ;  F       T       T       T           Y
CMP_FALSE_OQ    equ 0bh  ;  F       F       F       F           N
CMP_NEQ_OQ      equ 0ch  ;  T       T       F       F           N
CMP_GE_OS       equ 0dh  ;  T       F       T       F           Y
CMP_GT_OS       equ 0eh  ;  T       F       F       F           Y
CMP_TRUE_UQ     equ 0fh  ;  T       T       T       T           N

CMP_EQ_OS       equ 10h  ;  F       F       T       F           Y
CMP_LT_OQ       equ 11h  ;  F       T       F       F           N
CMP_LE_OQ       equ 12h  ;  F       T       T       F           N
CMP_UNORD_S     equ 13h  ;  F       F       F       T           Y
CMP_NEQ_US      equ 14h  ;  T       T       F       T           Y
CMP_NLT_UQ      equ 15h  ;  T       F       T       T           N
CMP_NLE_UQ      equ 16h  ;  T       F       F       T           N
CMP_ORD_S       equ 17h  ;  T       T       T       F           Y

CMP_EQ_US       equ 18h  ;  F       F       T       T           Y
CMP_NGE_UQ      equ 19h  ;  F       T       F       T           N
CMP_NGT_UQ      equ 1ah  ;  F       T       T       T           N
CMP_FALSE_OS    equ 1bh  ;  F       F       F       F           Y
CMP_NEQ_OS      equ 1ch  ;  T       T       F       F           Y
CMP_GE_OQ       equ 1dh  ;  T       F       T       F           N
CMP_GT_OQ       equ 1eh  ;  T       F       F       F           N
CMP_TRUE_US     equ 1fh  ;  T       T       T       T           Y
