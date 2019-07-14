.include "snes.inc"
.include "global.inc"
.smart
.export main, nmi_handler

.segment "ZEROPAGE"
nmis: .res 2
oam_used: .res 2
irqs: .res 2
vPos: .res 100
hPos: .res 100

.segment "BSS"

OAM:   .res 512
OAMHI: .res 512
; OAMHI contains bit 8 of X and the size bit for each sprite.
; It's a bit wasteful of memory, as the 512-byte OAMHI needs to be
; packed by software into 32 bytes before being sent to the PPU, but
; it makes sprite drawing code much simpler.  The OBC1 used in the
; game Metal Combat: Falcon's Revenge performs the same packing
; function in hardware, possibly as a copy protection method.

.segment "CODE"
;;
; Minimalist NMI handler that only acknowledges NMI and signals
; to the main thread that NMI has occurred.
.proc nmi_handler
  seta16
  phb
  phk         ; set data bank to bank 0 (because banks $40-$7D
  plb         ; and $C0-$FF can't reach low memory)
  inc a:nmis
  seta8
  bit a:NMISTATUS
  plb
  rti
.endproc

;;
; This program doesn't use IRQs either.
.proc irq_handler
  phb
  phk         ; set data bank to bank 0 (because banks $40-$7D
  plb         ; and $C0-$FF can't reach low memory)

  seta16
  inc a:irqs
  seta8
  bit a:TIMESTATUS
  plb
  rti
.endproc

.macro storeCounters testNumber
.scope
  php
  seta8
  lda $2137
  lda $213D
  sta vPos+testNumber*2
  lda $213D
  and #$01
  sta vPos+testNumber*2+1  

  lda $213C
  sta hPos+testNumber*2
  lda $213C
  and #$01
  sta hPos+testNumber*2+1  
  plp
.endscope
.endmacro

.macro displayCounters testNumber
.scope
  php
  setxy16
  ldx hPos+testNumber*2
  jsr writeNumber  
  ldx vPos+testNumber*2
  jsr writeNumber
  plp
.endscope
.endmacro

.macro displayMessage msg, xPos, yPos
.scope
  php
  setxy16
  ldx #$6000 | NTXY(xPos, yPos)
  stx $2116

  seta8
  ldx #$00
nextchar:  
  lda msg,x
  cmp #$00
  beq endofstring
  sta $2118
  stz $2119
  inx
  bra nextchar
endofstring:
  plp
.endscope
.endmacro

.macro displayResult testNumber
.scope
  label = .ident(.sprintf("test%s", .string(testNumber)))
  displayMessage label, 2, 9+testNumber  
  displayCounters testNumber
.endscope
.endmacro

.macro runDma mode, addr, length, dest, channels
  php
  seta8
  lda #mode
  sta DMAMODE
  lda #dest
  sta DMAPPUREG
  setaxy16
  lda #addr
  sta DMAADDR
.ifnblank length  
  lda #length
.else
  txa
.endif
  sta DMALEN
  seta8
  phb
  pla
  sta DMAADDRBANK
  lda #channels
  sta COPYSTART
  plp
.endmacro


.macro setupHdma mode, addr, length, dest, channel
  php
  seta8
  lda #mode
  sta DMAMODE | (channel << 4)
  lda #dest
  sta DMAPPUREG | (channel << 4)
  setaxy16
  lda #(<addr | (>addr << 8))
  sta DMAADDR | (channel << 4)
.ifnblank length  
  lda #length
.else
  txa
.endif
  sta DMALEN | (channel << 4)
  seta8
    
  lda #^hdmaData
  sta HDMAINDBANK | (channel << 4)
  stz HDMATABLELO | (channel << 4)
  stz HDMATABLEHI | (channel << 4)
  stz HDMALINE | (channel << 4)

  phb
  pla
  sta DMAADDRBANK | (channel << 4)
  plp
.endmacro

.macro runTest procName, number
  jsr procName
  storeCounters number
.endmacro

.segment "CODE1"
; init.s sends us here
.proc main
  storeCounters 1

  phk
  plb
  
  setaxy16
  stz a:irqs
  stz a:nmis
  
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
  
  lda #0
  sta PPURES
  lda #%00010001  ; enable sprites and plane 0
  sta BLENDMAIN
    
  storeCounters 2

  ;Test: Run DMA and check counters  
  runTest runSingleDma, 3

  ;Test: Run DMA 1000 times and check counters
  runTest runMultipleDmas, 4

  ;Test: Turn on 1 HDMA channel and run it for a long time, then check counters
  runTest runSingleHdmaChannel, 5

  ;Test: Turn on 2 HDMA channels and run them for a long time, then check counters
  runTest runMultipleHdmaChannels, 6

  ;Test: Turn on 1 HDMA channel in indirect mode and run it for a long time, then check counters
  runTest runSingleIndirectHdmaChannel, 7

  ;Test: Turn on H-IRQs and NMI, run for a while, and check counters
  runTest runIrqNmiTest, 8

  ;Test: Turn on Fast ROM, run DMA 1000 times and check counters
  runTest runMultipleDmasFastRom, 9

  setaxy16
  ldx #$6000
  ldy #$0020
  jsl ppu_clear_nt  
  jsl load_bg_tiles  ; fill pattern table
  
  setaxy16
  displayMessage header, 2, 9
  displayResult 1
  displayResult 2
  displayResult 3
  displayResult 4
  displayResult 5
  displayResult 6
  displayResult 7
  displayResult 8
  displayResult 9
  
  displayMessage irqCount, 2, 25
  setxy16
  ldx a:irqs
  jsr writeNumber

  displayMessage nmiCount, 2, 26
  setxy16
  ldx a:nmis
  jsr writeNumber  
  
  
  ; Draw the player to a display list in main memory
  setaxy16
  stz oam_used

  ldx oam_used
  jsl ppu_clear_oam
  jsl ppu_pack_oamhi

  ; Wait for vertical blanking and copy prepared data to OAM.
  jsl ppu_vsync
  jsl ppu_copy_oam
  seta8
  lda #$0F
  sta PPUBRIGHT  ; turn on rendering

forever:
  jmp forever
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
  rts
.endproc

.proc runSingleDma
  seta16
  lda #0000
  sta $2181
  seta8
  lda #$01  
  sta $2183
  runDma $08, $8000, $100, $80, $01
  rts
.endproc

.proc runMultipleDmas
  ldx #1000
:
  seta16
  lda #0000
  sta $2181
  seta8
  lda #$01  
  sta $2183
  runDma $08, $8000, $100, $80, $01
  dex
  bne :-
  rts
.endproc

.proc runMultipleDmasFastRom
  lda #$01
  sta MEMSEL
  ldx #1000
:
  seta16
  lda #0000
  sta $2181
  seta8
  lda #$01  
  sta $2183
  runDma $08, $8000, $100, $80, $01
  dex
  bne :-
  stz MEMSEL  
  rts
.endproc

.proc runSingleHdmaChannel
  seta16
  lda #0000
  sta $2181
  seta8
  lda #$01  
  sta $2183
  setupHdma $00, hdmaData, $100, $80, $00
  lda #1
  sta HDMASTART
  
  
  ;Wait for a long time while HDMA runs
  ldx #$FFFF
:  
  seta16
  lda #0000
  sta $2181
  seta8
  lda #$01  
  sta $2183
  dex
  bne :-
  
  lda #0
  sta HDMASTART
  rts
.endproc

.proc runMultipleHdmaChannels
  seta16
  lda #0000
  sta $2181
  seta8
  lda #$01  
  sta $2183
  setupHdma $00, hdmaData, $100, $80, $00
  setupHdma $00, hdmaData, $100, $80, $01
  lda #3
  sta HDMASTART  
  
  ;Wait for a long time while HDMA runs
  ldx #$FFFF
:  
  seta16
  lda #0000
  sta $2181
  seta8
  lda #$01  
  sta $2183
  dex
  bne :-
  
  lda #0
  sta HDMASTART
  rts
.endproc

.proc runSingleIndirectHdmaChannel
  seta16
  lda #0000
  sta $2181
  seta8
  lda #$01  
  sta $2183
  setupHdma $40, indirectHdmaData, $100, $80, $00
  lda #1
  sta HDMASTART
  
  
  ;Wait for a long time while HDMA runs
  ldx #$FFFF
:  
  seta16
  lda #0000
  sta $2181
  seta8
  lda #$01  
  sta $2183
  dex
  bne :-
  
  lda #0
  sta HDMASTART
  rts
.endproc


.proc runIrqNmiTest
  ;Enable H-IRQs and NMI
  lda #30
  sta HTIME
  stz HTIMEHI
  
  lda a:TIMESTATUS  
  lda #VBLANK_NMI|HTIME_IRQ|AUTOREAD
  ;lda #HTIME_IRQ|AUTOREAD  ; but disable htime/vtime IRQ
  sta PPUNMI
  cli
  
  ldx #$FFFF
:
  dex
  nop
  nop
  bne :-
  
  sei
  stz PPUNMI
  rts
.endproc

header:    .asciiz "                 H-POS V-POS"
test1:    .asciiz  "STARTUP VALUES   "
test2:    .asciiz  "AFTER INIT       "
test3:    .asciiz  "WRAM DMA         "
test4:    .asciiz  "WRAM DMA 1K      "
test5:    .asciiz  "HDMA             "
test6:    .asciiz  "HDMA 2 CHANNELS  "
test7:    .asciiz  "HDMA INDIRECT    "
test8:    .asciiz  "IRQ+NMI          "
test9:    .asciiz  "WRAM DMA 1K+FR   "

irqCount: .asciiz  "IRQ COUNT        "
nmiCount: .asciiz  "NMI COUNT        "

hdmaData: 
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

indirectHdmaData:
.byte $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData
.byte $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData
.byte $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData
.byte $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData
.byte $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData
.byte $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData
.byte $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData
.byte $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData
.byte $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData
.byte $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData
.byte $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData
.byte $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData
.byte $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData
.byte $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData
.byte $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData
.byte $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData
.byte $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData
.byte $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData
.byte $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData
.byte $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData
.byte $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData
.byte $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData
.byte $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData
.byte $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData
.byte $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData
.byte $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData, $81, <hdmaData, >hdmaData
