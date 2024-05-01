; ===================
; * Class_video.asm *
; ===================

; ================
; * Fonction CLS *
; ================
; A = Index du charset
; Y = Couleur du charset
F_CLS

  ldx #0

SCREEN_BC
  sta $400,x ; $400; $401 $ 402
  sta $400+250,x ; 
  sta $400+500,x ; 
  sta $400+750,x ; 
  inx ; X=X+1
  cpx #250
  bne SCREEN_BC 
 
 

  ldx #0
  tya
  
COLOR_BC
  sta $D800,x ; $400; $401 $ 402
  sta $D800+250,x ; 
  sta $D800+500,x ; 
  sta $D800+750,x ; 
  inx
  cpx #250
  bne COLOR_BC ; 
  
  rts