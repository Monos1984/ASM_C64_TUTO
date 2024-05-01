; =============================
; * Class_map                 *
; =============================  
  
; ======================  
; *  Fonction Draw Map *
; ====================== 
F_DRAW_MAP  

  ldx #0
  ldy #0
  lda #0
  
  sta MAP_PX
  sta MAP_PY
  sta TILES_PY
    
  lda #1
  sta TILES_PX
 
  
DRAW_MAP_BC
  jsr F_GET_TILES ; id du MT => ID_TILES (MAP_PX,MAP_PY)  ID_TILES  = F_GET_TILES(MAP_PX,MAP_PY) 
  
  lda TILES_ID 

; x8 pour pointer sur  tableau de CFG 
  asl A 
  asl A 
  asl A 
  
  sta BUFFER_TILES 
  
; * TILES H_G *
  ldx BUFFER_TILES
  lda CFG_TILES,x
  sta TILES_ID 
  jsr F_DRAW_TILES 


; * TILES H_D *
  inc TILES_PX
  ldx BUFFER_TILES
  lda CFG_TILES+1,x
  sta TILES_ID
  JSR F_DRAW_TILES

; * TILES B_G
  inc TILES_PY 
  dec TILES_PX 
  ldx BUFFER_TILES
  lda CFG_TILES+2,x
  sta TILES_ID
  JSR F_DRAW_TILES
  
; * TILES B_D *
   inc TILES_PX
   ldx BUFFER_TILES
   lda CFG_TILES+2,x
   sta TILES_ID
   JSR F_DRAW_TILES
   
;* Initiation du prochain tiles *
  inc MAP_PX 
  inc TILES_PX
  dec TILES_PY 
  
  lda MAP_PX
  cmp #16
  BNE DRAW_MAP_BC 
  
  lda #0
  sta MAP_PX
  
  lda #1
  sta TILES_PX 
  
  inc TILES_PY
  inc TILES_PY


  inc MAP_PY 
  lda MAP_PY
  cmp #12
  BNE DRAW_MAP_BC 
  
  
  rts
  
; ==============
; * Draw Tiles *
; ==============
F_DRAW_TILES


  ; ----------------------------------
  ; * Charger la position Y du tiles *
  ; ----------------------------------
  lda TILES_PY
  asl a
  tax
  
  ; --------------------------------------------------
  ; * Memoriser l'adresse de la ligne par apport à Y *
  ; --------------------------------------------------
  lda LIGNE_ADRESSE,x
  sta PTR_ADR
  
  inx
  lda LIGNE_ADRESSE,x
  sta PTR_ADR+1
  
  ; -----------------------------------
  ; * Charger l'index du tiles dans A *
  ; -----------------------------------
  lda TILES_ID
  
  ; ----------------------------------------------------
  ; * Charger la position X du tiles à afficher dans Y *
  ; ----------------------------------------------------
  ldy TILES_PX
  
  ; -------------------------------
  ; * Afficher le tiles à l'écran *
  ; -------------------------------
  sta (PTR_ADR),y
  
 
  rts
  
; ==================================
; * Recuperer l'id tiles de la map *
; ==================================
; Formule : PY * Largeur du tab + Px (PY*16+px)
F_GET_TILES

; Registre A = PY * 16
  lda MAP_PY
  asl a
  asl a
  asl a
  asl a

; Registre A = Registre A + PX
  clc ; Virer le carry ! On expliquera un peux plus tard
  adc MAP_PX
  
; Envois A dans X  
  tax
 
; Charger le tile dans TILES_ID
  lda DATA_MAP,x
  sta TILES_ID
  
  rts