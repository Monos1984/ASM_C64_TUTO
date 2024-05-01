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
  lda #1 ; charger la valeur 1 (A) dans le registre A
  ldx #0 ; Registre X = 0

SCREEN_BC
  sta $400,x ; $400; $401 $ 402
  sta $400+250,x ; 
  sta $400+500,x ; 
  sta $400+750,x ; 
  inx ; X=X+1
  cpx #250
  bne SCREEN_BC 
 
 

  ldx #0
  
COLOR_BC
  lda #2
  sta $D800,x ; $400; $401 $ 402
  
  lda #0
  sta $D800+250,x ; 
  
  lda #4
  sta $D800+500,x ; 
  
  lda #15
  sta $D800+750,x ; 
  inx
  cpx #250
  bne COLOR_BC ; 
 
FIN
  jmp FIN

  