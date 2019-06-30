.include "snes.inc"
.include "global.inc"
.smart

.segment "BSS"
vPos: .res 4
hPos: .res 4
testResult: .res 200

.segment "CODE1"

.proc storeTime
  setaxy16
  lda vPos+2
  sec
  sbc vPos+0
  tay
  beq noMul

  lda #0
  clc
mulLoop:
  adc #341
  dey
  bne mulLoop
  bra mulEnd

noMul:
  lda #0
  
mulEnd:
  adc hPos+2
  sec
  sbc hPos+0
  sec
  sbc #$78
  sta testResult, x  
  rtl
.endproc

.proc writeNumber
  php
  seta8
  lda #36
  sta $2118
  stz $2119
  
  setaxy16

  ldy #4
digitstart:
  txa
  xba
  lsr
  lsr
  lsr
  lsr
  and #$0F
  cmp #$0A
  bcc notaletter
  clc
  adc #$7
  
notaletter:
  clc
  adc #48
  seta8
  sta $2118
  stz $2119
  seta16
  
  txa
  asl
  asl
  asl
  asl
  tax
  
  dey
  bne digitstart 
  
  stz $2118
  
  plp
  rtl
.endproc

.proc initTest
  phk
  plb
  setaxy16
  ;stz a:irqs
  ;stz a:nmis
  
  ; Program the PPU for the display mode
  seta8
  stz BGMODE     ; mode 0 (four 2-bit BGs) with 8x8 tiles
  stz BGCHRADDR  ; bg planes 0-1 CHR at $0000
  lda #$4000 >> 13
  sta OBSEL      ; sprite CHR at $4000, sprites are 8x8 and 16x16
  lda #>$6000
  sta NTADDR+0   ; plane 0 nametable at $6000
  sta NTADDR+1   ; plane 1 nametable also at $6000
  ; set up plane 0's scroll
  stz BGSCROLLX+0
  stz BGSCROLLX+0
  lda #$FF
  sta BGSCROLLY+0  ; The PPU displays lines 1-224, so set scroll to
  sta BGSCROLLY+0  ; $FF so that the first displayed line is line 0
    
  rtl 
.endproc

.proc beforeDisplayResult
  seta8
  lda #0
  sta PPURES
  lda #%00010001  ; enable sprites and plane 0
  sta BLENDMAIN
  
  setaxy16
  ldx #$6000
  ldy #$0020
  jsl ppu_clear_nt  
  jsl load_bg_tiles  ; fill pattern table
  rtl
.endproc

.proc finishTest
  ; Draw the player to a display list in main memory
  setaxy16

  ldx #0
  jsl ppu_clear_oam
  jsl ppu_pack_oamhi

  ; Wait for vertical blanking and copy prepared data to OAM.
  jsl ppu_vsync
  jsl ppu_copy_oam
  seta8
  lda #$0F
  sta PPUBRIGHT  ; turn on rendering
  
  .repeat 100
    jsl ppu_vsync
  .endrepeat

  seta8
  lda #$80
  sta PPUBRIGHT  ; turn off rendering

  rtl  
.endproc