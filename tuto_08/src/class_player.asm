; ================
; * Class Player *
; ================

; =================================
; * Affichage du sprite du joueur *
; =================================
DRAW_SPRITE_PLAYER

 ; -------------------
 ; * Init MSB SPRITE *
 ; -------------------
 ldx #%00000000
 stx $D010

 ; ==================
 ; * Calcule sur PX *
 ; ==================
 lda PLAYER_PX 
 
 ; ---------------------------------------
 ; * Transformation Case en Pixel. (x16) *
 ; ---------------------------------------
 asl 
 asl 
 asl
 asl 

 ; ----------------------------------------------
 ; * Ajout de 24+8 pour le décalage ecran + map *
 ; ----------------------------------------------
 clc ; Desactive le drapeau carry 
 adc #32

 bcc SET_PX 
 ldx #%00000001
 stx $D010

SET_PX 
 sta $D000

 ; ==================
 ; * Calcule sur PY *
 ; ==================
 lda PLAYER_PY 
 
 ; ---------------------------------------
 ; * Transformation Case en Pixel. (x16) *
 ; ---------------------------------------
 asl 
 asl 
 asl
 asl 
 
 ; ----------------------------------------------
 ; * Ajout de 50 pour le décalage ecran + map *
 ; ----------------------------------------------
 clc ; Desactive le drapeau carry 
 adc #50
 
  sta $D001

  rts