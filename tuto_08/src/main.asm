; Note : penser à modifier les colisions

; **********************************
; * Tuto Commodore 64 Chapitre 008 *
; * Mise en place des colisions    *
; **********************************

; ===============
; * Les Defines *
; ===============
  .include "define_system.asm"


PTR_ADR = $02 ; Pointeur adresse (2 octets)

INDEX_MAP = $04
MAP_PX    = $0C
MAP_PY    = $05

; -----------------------
; * Define System Tiles *
; -----------------------
TILES_ID = $06
TILES_PX = $07
TILES_PY = $08

BUFFER_PX =    $09
BUFFER_PY =    $0A
BUFFER_TILES = $10
; -------------------
; * Define Joystick *
; -------------------
JOY_USE   = $0B
JOY_UP    = %11110
JOY_DOWN  = %11101
JOY_LEFT  = %11011
JOY_RIGHT = %10111
JOY_FIRE  = %01111

; ----------------
; * Tiles Player *
; ----------------
TILES_PLAYER = $03
PLAYER_PX    = $10
PLAYER_PY    = $11


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

; ==================
; * initier le CLS *
; ==================
  lda #32 ; charger la valeur 1 (A) dans le registre A
  ldy #0 ; Registre X = 0
  jsr F_CLS
  
  
  
; ==========================
; * Initier la memoire Vic *
; ==========================  
  
; Screen Memory en $400 et generateur de charset en $3800 
; Adresse du  Screen Memory ... : S*1024
; Adresse Character Ram ....... : C*2048

; ------------------------
; * Encodage du Registre *
; ------------------------
;* SSSSCCCx
;       SSSSCCCX
  lda #%00011110
  sta VIC_MEMORY_CONTROLE 
 
; Charger le petit tileset en $3800
  
  
; --------------------------------------- 
; * Initiation du pointeur de sprite 0 *
; --------------------------------------
  lda #$D8 
  sta $7F8
  
  
  
  
; ---------------------
; * Spriteset Memcopy *  
; ---------------------
  ldx #0 
  
START_LOAD_SPRITESET_BC 
  lda SPRITESET,X
  sta $3600,X
  inx 
  cpx #64
  BNE START_LOAD_SPRITESET_BC 
  
; ------------------
; * Tilset Memcopy *
; ------------------  
  
  ldx #0
  
START_LOAD_TILESET_BC
  lda TILESET,X
  STA $3800,X
  inx
  cpx #(4*8) ; Le 4x8 sera calculé par le logiciel assembleur avant la "compilation" Il n'y pas de 4x8 dans le programme
  BNE START_LOAD_TILESET_BC
 
 
; ========================
; * Afficher la map Test *
; ========================  
  jsr F_DRAW_MAP
  
; ========================
; * Initiation du player *
; ========================

  lda #TILES_PLAYER
  sta TILES_ID
  
  lda #3
  sta TILES_PX
  sta PLAYER_PX
  
  lda #4
  sta TILES_PY
  sta PLAYER_PY
  
  jsr F_DRAW_TILES
  
  ; ========================
  ; * Initiation du sprite *
  ; ========================
  
; ------------------------
; * Activation du sprite *
; ------------------------
  lda #%00000001
  sta $D015
  
; -----------------------
; * Couleur du sprite 0 *
; -----------------------
  lda #$3
  sta $D027
  
  jsr DRAW_SPRITE_PLAYER
  
; =================
; * Boucle du jeu *
; =================
GAME_LOOPS
  jmp GAME_LOOPS
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

; ....................
; *** Direction UP ***
; ....................
  cmp #JOY_UP
  bne END_TEST_UP

  ; seter JOY USE
  ldx #1
  stx JOY_USE  

  ; Test blocage Haut
  ldx TILES_PY
  cpx #0
  beq END_TEST_UP
  

   ; Test de Collision UP
  lda TILES_PX
  sta BUFFER_PX
  
  lda TILES_PY
  sta BUFFER_PY
  dec BUFFER_PY
  jsr F_GET_TILES
  lda TILES_ID
  cmp #0
  bne END_TEST_UP
  
  
  ; * Clean Tiles *
  lda #0
  sta TILES_ID
  jsr F_DRAW_TILES
  
  ; * Draw Player *
  lda #TILES_PLAYER
  sta TILES_ID
  dec TILES_PY
  jsr F_DRAW_TILES
   
  jmp END_JOY_TEST
END_TEST_UP
  
; ......................
; *** Direction DOWN ***
; ......................
  cmp #JOY_DOWN
  bne END_TEST_DOWN

  ; seter JOY USE
  ldx #1
  stx JOY_USE  

  ; Test blocage BAS
  ldx TILES_PY
  cpx #15
  beq END_TEST_DOWN
  
  ; Test de Colision Bas 
  lda TILES_PX
  sta BUFFER_PX
  
  lda TILES_PY
  sta BUFFER_PY
  inc BUFFER_PY
  jsr F_GET_TILES
  lda TILES_ID
  cmp #0
  bne END_TEST_DOWN
  
  
  ; * Clean Tiles *
  lda #0
  sta TILES_ID
  jsr F_DRAW_TILES
  
  ; * Draw Player *
  lda #TILES_PLAYER
  sta TILES_ID
  inc TILES_PY
  jsr F_DRAW_TILES
  jmp END_JOY_TEST
END_TEST_DOWN

; ......................
; *** Direction left ***
; ......................
  cmp #JOY_LEFT
  bne END_TEST_LEFT

  ; seter JOY USE
  ldx #1
  stx JOY_USE  

  ; Test blocage GAUCHE
  ldx TILES_PX
  cpx #0
  beq END_TEST_LEFT
  
   ; Test de Colision left
  lda TILES_PX
  sta BUFFER_PX
  dec BUFFER_PX
   
  lda TILES_PY
  sta BUFFER_PY
 
  jsr F_GET_TILES
  lda TILES_ID
  cmp #0
  bne END_TEST_LEFT
  
  
  ; * Clean Tiles *
  lda #0
  sta TILES_ID
  jsr F_DRAW_TILES
  
  ; * Draw Player *
  lda #TILES_PLAYER
  sta TILES_ID
  dec TILES_PX
  jsr F_DRAW_TILES
   
  jmp END_JOY_TEST
END_TEST_LEFT
  
; .......................  
; *** Direction right ***
; .......................
  cmp #JOY_RIGHT
  bne END_TEST_RIGHT

  ; seter JOY USE
  ldx #1
  stx JOY_USE  

  ; Test blocage Droite
  ldx TILES_PX
  cpx #15
  beq END_TEST_RIGHT
  
  ; Test de Colision RIGHT
  lda TILES_PX
  sta BUFFER_PX
  inc BUFFER_PX
   
  lda TILES_PY
  sta BUFFER_PY
 
  jsr F_GET_TILES
  lda TILES_ID
  cmp #0
  bne END_TEST_RIGHT
  
  ; * Clean Tiles *
  lda #0
  sta TILES_ID
  jsr F_DRAW_TILES
  
  ; * Draw Player *
  lda #TILES_PLAYER
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
  .include "class_player.asm"
 
; =============== 
; * Data du jeu *
; ===============
DATA_MAP

  .byte $02,$01,$01,$01,$01,$01,$00,$00,$01,$01,$01,$01,$01,$01,$01,$02
  .byte $01,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01
  .byte $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01
  .byte $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01
  .byte $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01
  .byte $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01
  .byte $01,$00,$01,$01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01
  .byte $01,$00,$01,$01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01
  .byte $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01
  .byte $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01
  .byte $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01
  .byte $02,$01,$01,$01,$01,$01,$00,$00,$01,$01,$01,$01,$01,$01,$01,$02
  
; ===========
; * Tileset *
; ===========*
TILESET 

  .byte $0,$0,$0,$0,$0,$0,$0,$0 ;vide 
  .byte %11111111,%10001000,%10001000,%10001000,%10001000,%11111111,%00010001,%00010001
  .byte 255,255,255,255,255,255,255,255
  
  .byte %00111000
  .byte %00111000
  .byte %00010000
  .byte %11111111
  .byte %00010000
  .byte %00101000
  .byte %01000100
  .byte %10000010
  
; ==============
; * Spritesets *
; ==============
SPRITESET  

  .byte $ff,$ff,$00,$c0,$03,$00,$a0,$05,$00,$90,$09,$00,$8f,$f1,$00,$88
  .byte $11,$00,$88,$11,$00,$89,$91,$00,$89,$91,$00,$88,$11,$00,$88,$11
  .byte $00,$8f,$f1,$00,$90,$09,$00,$a0,$05,$00,$c0,$03,$00,$ff,$ff,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08


; Sprite Exemple  
   .byte $00,$00,$00  ; .byte %11111111,%11111111,%11111111
   .byte $00,$00,$00  ; .byte %1000000, %0000000, %0000001
   .byte $00,$00,$00  ; .byte %1000000, %0000000, %0000001
   .byte $00,$00,$00  ; .byte %11111111,%11111111,%11111111
   .byte $00,$00,$00 
   .byte $00,$00,$00 
   .byte $00,$00,$00 
   .byte $00,$00,$00 
   .byte $00,$00,$00 
   .byte $00,$00,$00 
   .byte $00,$00,$00 
   .byte $00,$00,$00 
   .byte $00,$00,$00 
   .byte $00,$00,$00 
   .byte $00,$00,$00 
   .byte $00,$00,$00 
   .byte $00,$00,$00 
   .byte $00,$00,$00 
   .byte $00,$00,$00 
   .byte $00,$00,$00 
   .byte $00,$00,$00  
   .byte $FF
; ================================
; * Configuration des Meta Tiles *
; ================================
CFG_TILES  ; lda CFG_TILES,x 
 .byte $0,$0,$0,$0,$0,$0,$0,$0  ;(0) VIDE/SOL
 .byte $1,$1,$1,$1,$0,$0,$0,$0  ;(1) Mur 
 .byte $2,$2,$2,$2,$0,$0,$0,$0  ;(2) Coin
 
  
; ==================================
; * Adresse Ligne du screen memory *
; ==================================  
; Debut de la mémoire video : $400 (le memoire vidéo n'est pas fixe !!!)
; Taille d'une ligne : 40 octets ($28)
LIGNE_ADRESSE
  .word $400,$428,$450,$478,$4A0,$4C8,$4F0,$518
  .word $540,$568,$590,$5B8,$5E0,$608,$630,$658
  .word $680,$6A8,$6D0,$6F8,$720,$748,$770,$798
  .word $7C0
  
  

  
 
  
  