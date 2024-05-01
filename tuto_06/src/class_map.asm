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
  
  sta INDEX_MAP
  sta MAP_PY
  
DRAW_MAP_BC
  lda MAP_PY ; A = La ligne à afficher
  asl a 
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
  bne  DRAW_LIGNE_BC 
  
  stx INDEX_MAP
  ldy #0
  inc MAP_PY 
  ldx MAP_PY
  cpx #16
  bne DRAW_MAP_BC
  
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
; (BUFFER_PY * 16) + BUFFER_PX
; x << 1 : * 2   :         % 00000000
; 2
; 2
; 2
; 2

;  lda DATA_MAP,x
;  sta TILES_ID
;  DATA_MAP => TILES_ID 
F_GET_TILES
  lda BUFFER_PY 
  
  ; A = A*16
  asl a 
  asl a
  asl a
  asl a
  
; A + BUFFER_PX
  clc 
  adc BUFFER_PX
  
  tax 
  
  lda DATA_MAP,x
  sta TILES_ID
  
  rts 