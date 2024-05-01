; =====================
; * Tuto Commodore 64 *
; =====================

; ===============
; * Les Defines *
; ===============
PTR_ADR = $02

INDEX_MAP = $04
MAP_PY    = $05

; -----------------------
; * Define System Tiles *
; -----------------------
TILES_ID  = $06
TILES_PX  = $07
TILES_PY  = $08
BUFFER_PX = $09
BUFFER_PY = $0A

; -------------------
; * Define Joystick *
; -------------------
JOY_USE   = $0B
JOY_UP    = %11110
JOY_DOWN  = %11101
JOY_LEFT  = %11011
JOY_RIGHT = %10111
JOY_FIRE  = %01111

; ===========
; * Startup *
; ===========
  *=$0800 ; org
; ================
; * Header Basic *
; ================
  .byte $00,$0c,$08,$0a,$00,$9e,$20,$32 
  .byte $30,$36,$34,$00,$00,$00,$00,$00
  
  ; 10 sys $810
  
F_MAIN ; $810 

; * initier le CLS *
  lda #32 ; charger la valeur 1 (A) dans le registre A
  ldy #0 ; Registre X = 0
  jsr F_CLS
  
  jsr F_DRAW_MAP
  
  
  ; ---------------
  ; * Init player *
  ; ---------------
  lda #$25
  sta TILES_ID
  
  lda #1
  sta TILES_PX
  
  lda #2
  sta TILES_PY
  
  jsr F_DRAW_TILES
  
  
; =================
; * Boucle du jeu *
; =================
GAME_LOOPS
; -----------------------------
; * Charger les donnée du JOY *
; -----------------------------
  lda $DC00
  and #%11111

; --------------------------------
; * Tester si le Joy est utilisé *
; --------------------------------
  cmp #%11111
  bne END_RESET_JOY_USE
  ldx #0
  stx JOY_USE
END_RESET_JOY_USE

; -------------------------------------
; * Tester si on peux utiliser le Joy *
; -------------------------------------
  ldx JOY_USE
  cpx #1
  BNE READ_JOY
  jmp END_JOY_TEST
  
; -----------------------
; * Lecture du Joystick *
; -----------------------  
READ_JOY  


  ; *** Direction UP ***
  cmp #JOY_UP
  bne END_TEST_UP

  ; seter JOY USE
  ldx #1
  stx JOY_USE  

  ; Test blocage Haut
  ldx TILES_PY
  cpx #0
  beq END_TEST_UP
  
  ; ---------------------
  ; * Test collision UP *
  ; --------------------
  lda TILES_PX 
  sta BUFFER_PX 
  
  lda TILES_PY 
  sta BUFFER_PY 
  
  dec BUFFER_PY 
  jsr F_GET_TILES 
  lda TILES_ID 
  cmp #$20 ; $20 - A 
  bne  END_TEST_UP
  
  
  ; * Clean Tiles *
   lda #$20
  sta TILES_ID
  jsr F_DRAW_TILES
  
  ; * Draw Player *
  lda #$25
  sta TILES_ID
  dec TILES_PY
  jsr F_DRAW_TILES
  jmp END_JOY_TEST
END_TEST_UP
  
  
    ; *** Direction DOWN ***
  cmp #JOY_DOWN
  bne END_TEST_DOWN

  ; seter JOY USE
  ldx #1
  stx JOY_USE  

  ; Test blocage BAS
  ldx TILES_PY
  cpx #15
  beq END_TEST_DOWN
  
  ; ---------------------
  ; * Test collision UP *
  ; --------------------
  lda TILES_PX 
  sta BUFFER_PX 
  
  lda TILES_PY 
  sta BUFFER_PY 
  
  inc BUFFER_PY 
  jsr F_GET_TILES 
  lda TILES_ID 
  cmp #$20 ; $20 - A 
  bne  END_TEST_DOWN
  
  
  ; * Clean Tiles *
  lda #$20
  sta TILES_ID
  jsr F_DRAW_TILES
  
  ; * Draw Player *
  lda #$25
  sta TILES_ID
  inc TILES_PY
  jsr F_DRAW_TILES
  jmp END_JOY_TEST
END_TEST_DOWN

   ; *** Direction left ***
  cmp #JOY_LEFT
  bne END_TEST_LEFT

  ; seter JOY USE
  ldx #1
  stx JOY_USE  

  ; Test blocage GAUCHE
  ldx TILES_PX
  cpx #0
  beq END_TEST_LEFT
  
  ; -----------------------
  ; * Test collision LEFT *
  ; ----------------------
  lda TILES_PX 
  sta BUFFER_PX 
  
  lda TILES_PY 
  sta BUFFER_PY 
  
  dec BUFFER_PX 
  jsr F_GET_TILES 
  lda TILES_ID 
  cmp #$20 ; $20 - A 
  bne  END_TEST_LEFT
  
  
  ; * Clean Tiles *
  lda #$20
  sta TILES_ID
  jsr F_DRAW_TILES
  
  ; * Draw Player *
  lda #$25
  sta TILES_ID
  dec TILES_PX
  jsr F_DRAW_TILES
  jmp END_JOY_TEST
END_TEST_LEFT
  
  
   ; *** Direction right ***
  cmp #JOY_RIGHT
  bne END_TEST_RIGHT

  ; seter JOY USE
  ldx #1
  stx JOY_USE  

  ; Test blocage Droite
  ldx TILES_PX
  cpx #15
  beq END_TEST_RIGHT
  
  ; ------------------------
  ; * Test collision RIGHT *
  ; ------------------------
  lda TILES_PX 
  sta BUFFER_PX 
  
  lda TILES_PY 
  sta BUFFER_PY 
  
  inc BUFFER_PX
  jsr F_GET_TILES 
  lda TILES_ID 
  cmp #$20 ; $20 - A 
  bne  END_TEST_RIGHT
  
  
  ; * Clean Tiles *
  lda #$20
  sta TILES_ID
  jsr F_DRAW_TILES
  
  ; * Draw Player *
  lda #$25
  sta TILES_ID
  inc TILES_PX
  jsr F_DRAW_TILES
  jmp END_JOY_TEST
END_TEST_RIGHT


END_JOY_TEST

 jmp GAME_LOOPS
  

; ===================
; * Fichier include *
; ===================
  .include "class_video.asm"
  .include "class_map.asm"
 
 
; =============== 
; * Data du jeu *
; ===============
DATA_MAP

  .byte $24,$23,$23,$23,$23,$23,$20,$20,$23,$23,$23,$23,$23,$23,$23,$24
  .byte $23,$20,$23,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$23
  .byte $23,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$23
  .byte $23,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$23
  .byte $23,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$23
  .byte $23,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$23
  .byte $23,$20,$23,$23,$23,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$23
  .byte $23,$20,$23,$23,$23,$20,$22,$20,$20,$20,$20,$20,$20,$20,$20,$23
  .byte $23,$20,$23,$23,$23,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$23
  .byte $23,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$23
  .byte $23,$20,$23,$23,$23,$23,$20,$20,$20,$20,$20,$20,$20,$20,$20,$23
  .byte $23,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$23
  .byte $23,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$23
  .byte $23,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$23
  .byte $23,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$23
  .byte $24,$23,$23,$23,$23,$23,$20,$20,$23,$23,$23,$23,$23,$23,$23,$24
  
  
; ==================================
; * Adresse Ligne du screen memory *
; ==================================  
LIGNE_ADRESSE
  .word $400,$428,$450,$478,$4A0,$4C8,$4F0,$518
  .word $540,$568,$590,$5B8,$5E0,$608,$630,$658
  
 
  
  