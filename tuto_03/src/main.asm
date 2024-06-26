; =====================
; * Tuto Commodore 64 *
; =====================

PTR_ADR  = $02
PTR_ADR2 = $03

INDEX_MAP = $04
MAP_PY    = $05


  *=$0800 ; org
; ================
; * Header Basic *
; ================
  .byte $00,$0c,$08,$0a,$00,$9e,$20,$32 
  .byte $30,$36,$34,$00,$00,$00,$00,$00
  
  ; 10 sys $810
  
F_MAIN ; $810 

; * Effacer L'ecran avec un CLS *
  lda #32 ; Espace
  ldy #0 ;  couleur
  jsr F_CLS

; ===================
; * Draw Map Engine *
; ===================
  ldx #0
  ldy #0 
  lda #0
 
  sta INDEX_MAP 
  sta MAP_PY
 
DRAW_MAP_BC
  lda MAP_PY ; A = la ligne à travailler
  asl a ; Decalage de bit vers la gauche.     %01  %10 %100 %1000
  tax
 
  lda LIGNE_ADRESSE,x
  sta PTR_ADR
 
  inx
  
  lda LIGNE_ADRESSE,x
  sta PTR_ADR+1
  
  ldy #0
  ldx INDEX_MAP
  
DRAW_LIGNE_BC
  lda DATA_MAP,x
  sta (PTR_ADR),y
  inx
  iny 
 
  cpy #16
  bne DRAW_LIGNE_BC
  
  stx INDEX_MAP
  ldy #0
  inc MAP_PY
  
  ldx MAP_PY
  cpx #16
  bne DRAW_MAP_BC
  
FIN
  jmp FIN

  
; ====================
; * Fichier includes *
; ====================
 .include "class_video.asm"
 
 
; ============ 
; * DATA MAP *
; ============

DATA_MAP
  .byte $24,$23,$23,$23,$23,$23,$20,$20,$23,$23,$23,$23,$23,$23,$23,$24
  .byte $23,$20,$23,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$23
  .byte $23,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$23
  .byte $23,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$23
  .byte $23,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$23
  .byte $23,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$23
  .byte $23,$20,$23,$23,$23,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$23
  .byte $23,$20,$23,$23,$23,$20,$22,$20,$20,$20,$20,$29,$20,$20,$20,$23
  .byte $23,$20,$23,$23,$23,$20,$20,$20,$20,$20,$20,$20,$34,$20,$20,$23
  .byte $23,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$23
  .byte $23,$20,$23,$23,$23,$23,$20,$20,$20,$20,$20,$20,$20,$20,$20,$23
  .byte $23,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$23
  .byte $23,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$23
  .byte $23,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$23
  .byte $23,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$23
  .byte $24,$23,$23,$23,$23,$23,$20,$20,$23,$23,$23,$23,$23,$23,$23,$24
  
LIGNE_ADRESSE
  .word $400,$428,$450,$478,$4A0,$4C8,$4F0,$518
  .word $540,$568,$590,$5B8,$5E0,$608,$630,$658
  
  
  ; $00 $04
  ; $28,$04
  
  ld (C),A