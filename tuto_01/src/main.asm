; =====================
; * Tuto Commodore 64 *
; =====================


  *=$0800 ; org
; ================
; * Header Basic *
; ================
  .byte $00,$0c,$08,$0a,$00,$9e,$20,$32 
  .byte $30,$36,$34,$00,$00,$00,$00,$00
  
  ; 10 sys $810
  
F_MAIN ; $810 
  lda #1 
  sta $400

  lda #2
  sta $401

  lda #3
  sta $402
  
  jmp F_MAIN

  