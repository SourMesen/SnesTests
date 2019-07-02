.include "snes.inc"
.include "global.inc"
.include "testmacros.inc"
.smart
.export main, nmi_handler, irq_handler

.segment "ZEROPAGE"
valueOnIrq: .res 2
testResults: .res 200


.segment "BSS"

.segment "CODE1"
; init.s sends us here
.proc main
  jsl initTest
  
  runTest runTest1, 1
  runTest runTest2, 2
  runTest runTest3, 3
  runTest runTest4, 4
  runTest runTest5, 5
  runTest runTest6, 6
  runTest runTest7, 7
  runTest runTest8, 8
  runTest runTest9, 9
  runTest runTest10, 10
 
  jsl beforeDisplayResult

  displayMessage header, 2, 3

  displayResult 1
  displayResult 2
  displayResult 3
  displayResult 4
  displayResult 5
  displayResult 6
  displayResult 7
  displayResult 8
  displayResult 9
  displayResult 10
  
  jsl finishTest

forever:
  jmp forever
  
.endproc

header: .asciiz "IRQ/NMI DELAY AFTER W:$420B"

test1: .asciiz "IRQ - INC A       "
.proc runTest1
  ;Wait for the start of the frame
  jsl ppu_start_frame
  
  ;Set IRQ to fire at scanline 2, cycle 2
  setaxy16
  lda #2
  sta HTIME
  sta VTIME
  seta8
  lda #HVTIME_IRQ
  sta PPUNMI  
  
  cli
  
  ;Start DMA
  setWorkRamAddress $01, $0000
  runDma $01, $8000, $100, $80, $01
  
  INC A ;This should run before the IRQ
  INC A ;This shouldn't
  INC A
  INC A
  
  sei  
  LDA #0
  stz PPUNMI
  rtl
.endproc

test2: .asciiz "IRQ - LDA IMM16   "
.proc runTest2
  ;Wait for the start of the frame
  jsl ppu_start_frame
  
  ;Set IRQ to fire at scanline 2, cycle 2
  setaxy16
  lda #2
  sta HTIME
  sta VTIME
  seta8
  lda #HVTIME_IRQ
  sta PPUNMI  
  
  cli
  
  ;Start DMA
  setWorkRamAddress $01, $0000
  runDma $01, $8000, $100, $80, $01
  
  ;Try running some instructions after DMA, IRQ should occur before these are done
  LDA #0002 ;This should run before the IRQ
  LDA #0003 ;This shouldn't
  LDA #0004
  LDA #0005
  
  sei  
  LDA #0
  stz PPUNMI
  rtl
.endproc

test3: .asciiz "IRQ - LDA16+INC   "
.proc runTest3
  ;Wait for the start of the frame
  jsl ppu_start_frame
  
  ;Set IRQ to fire at scanline 2, cycle 2
  setaxy16
  lda #2
  sta HTIME
  sta VTIME
  seta8
  lda #HVTIME_IRQ
  sta PPUNMI  
  
  cli
  
  ;Start DMA
  setWorkRamAddress $01, $0000
  runDma $01, $8000, $100, $80, $01
  
  ;Try running some instructions after DMA, IRQ should occur before these are done
  LDA #0002 ;This should run before the IRQ
  INC A     ;This shouldn't
  INC A
  INC A
  
  sei  
  LDA #0
  stz PPUNMI
  rtl
.endproc

test4: .asciiz "IRQ - INC+LDA16   "
.proc runTest4
  ;Wait for the start of the frame
  jsl ppu_start_frame
  
  ;Set IRQ to fire at scanline 2, cycle 2
  setaxy16
  lda #2
  sta HTIME
  sta VTIME
  seta8
  lda #HVTIME_IRQ
  sta PPUNMI  
  
  cli
  
  ;Start DMA
  setWorkRamAddress $01, $0000
  runDma $01, $8000, $100, $80, $01
  
  ;Try running some instructions after DMA, IRQ should occur before these are done
  INC A     ;This should run before the IRQ
  LDA #0003 ;This shouldn't
  LDA #0004
  LDA #0005
  
  sei  
  LDA #0
  stz PPUNMI
  rtl
.endproc

test5: .asciiz "IRQ - CLI+INC     "
.proc runTest5
  ;Wait for the start of the frame
  jsl ppu_start_frame
  
  ;Set IRQ to fire at scanline 2, cycle 2
  setaxy16
  lda #2
  sta HTIME
  sta VTIME
  seta8
  lda #HVTIME_IRQ
  sta PPUNMI  
  
  sei
  
  ;Start DMA
  setWorkRamAddress $01, $0000
  runDma $01, $8000, $100, $80, $01
  
  ;Try running some instructions after DMA, IRQ should occur before these are done
  cli   ;This should run before the IRQ
  INC A ;This should run before the IRQ
  INC A ;This shouldn't
  INC A
  
  sei  
  LDA #0
  stz PPUNMI
  rtl
.endproc

test6: .asciiz "IRQ - SEI+INC     "
.proc runTest6
  ;Wait for the start of the frame
  jsl ppu_start_frame
  
  ;Set IRQ to fire at scanline 2, cycle 2
  setaxy16
  lda #2
  sta HTIME
  sta VTIME
  seta8
  lda #HVTIME_IRQ
  sta PPUNMI  
  
  cli
  
  ;Start DMA
  setWorkRamAddress $01, $0000
  runDma $01, $8000, $100, $80, $01
  
  ;Try running some instructions after DMA, IRQ should never occur because of SEI call
  sei     ;This should prevent the IRQ from occurring
  inc A
  lda #$FFFF
  sta valueOnIrq  
  
  LDA #0
  stz PPUNMI
  rtl
.endproc

test7: .asciiz "IRQ - SEI+CLI+INC "
.proc runTest7
  ;Wait for the start of the frame
  jsl ppu_start_frame
  
  ;Set IRQ to fire at scanline 2, cycle 2
  setaxy16
  lda #2
  sta HTIME
  sta VTIME
  seta8
  lda #HVTIME_IRQ
  sta PPUNMI  
  
  cli
  
  ;Start DMA
  setWorkRamAddress $01, $0000
  runDma $01, $8000, $100, $80, $01
  
  ;Try running some instructions after DMA
  sei            ;This should prevent the IRQ from running
  cli            ;This should allow the IRQ to fire, after running 'inc a' below
  inc A
  lda #$FFFF     ;This shouldn't run before the IRQ
  
  sei  
  LDA #0
  stz PPUNMI
  rtl
.endproc

test8: .asciiz "NMI - INC A       "
.proc runTest8
  ;Wait for the start of the frame
  jsl ppu_start_frame
  
  ;Wait till scanline 224
  seta8
  lda #$80
  sta $4201
waitendoframe:
  lda $2137
  lda $213D
  cmp #224
  bne waitendoframe

  seta8
  LDA #VBLANK_NMI
  sta PPUNMI
  
  sei
  
  ;Start DMA
  setWorkRamAddress $01, $0000
  runDma $01, $8000, $100, $80, $01
  
  ;Try running some instructions after DMA
  inc A
  inc A
  inc A
  inc A
  
  sei  
  LDA #0
  stz PPUNMI
  rtl
.endproc


test9: .asciiz "NMI - LDA IMM16   "
.proc runTest9
  ;Wait for the start of the frame
  jsl ppu_start_frame
  
  ;Wait till scanline 224
  seta8
  lda #$80
  sta $4201
waitendoframe:
  lda $2137
  lda $213D
  cmp #224
  bne waitendoframe

  seta8
  LDA #VBLANK_NMI
  sta PPUNMI
  
  sei
  
  ;Start DMA
  setWorkRamAddress $01, $0000
  runDma $01, $8000, $100, $80, $01
  
  ;Try running some instructions after DMA
  lda #$0002
  lda #$0003
  lda #$0004
  lda #$0005
  
  sei  
  LDA #0
  stz PPUNMI
  rtl
.endproc

test10: .asciiz "NMI - CLI+INC     "
.proc runTest10
  ;Wait for the start of the frame
  jsl ppu_start_frame
  
  ;Wait till scanline 224
  seta8
  lda #$80
  sta $4201
waitendoframe:
  lda $2137
  lda $213D
  cmp #224
  bne waitendoframe

  seta8
  LDA #VBLANK_NMI
  sta PPUNMI
  
  sei
  
  ;Start DMA
  setWorkRamAddress $01, $0000
  runDma $01, $8000, $100, $80, $01
  
  ;Try running some instructions after DMA
  cli
  inc a
  inc a
  inc a
  
  sei  
  LDA #0
  stz PPUNMI
  rtl
.endproc

.segment "CODE"
;;
; Minimalist NMI handler that only acknowledges NMI and signals
; to the main thread that NMI has occurred.
.proc nmi_handler
  setaxy16
  sta valueOnIrq
  seta8
  bit a:NMISTATUS
  rti
.endproc

;;
; This program doesn't use IRQs either.
.proc irq_handler
  setaxy16
  sta valueOnIrq
  seta8
  lda TIMESTATUS
  rti
.endproc