.include "snes.inc"
.include "global.inc"
.include "testmacros.inc"
.smart
.export main, nmi_handler, irq_handler

.segment "ZEROPAGE"
valueOnIrq: .res 1
testResults: .res 200


.segment "BSS"

.segment "CODE1"
; init.s sends us here
.proc main
  jsl initTest
  
  .repeat 19, I
  .scope  
  funcName = .ident(.sprintf("runTest%s", .string(I+1)))
  runTest funcName, (I+1)
  .endscope
  .endrepeat
  
  jsl beforeDisplayResult

  displayMessage header, 2, 3

  .repeat 19, I
  displayResult (I+1)
  .endrepeat
  
  jsl finishTest

forever:
  jmp forever
  
.endproc

header: .asciiz "IRQ/NMI DELAY AFTER W:$420B"

test1: .asciiz "IRQ - INC A           "
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
  lda #00  
  runDma $01, $8000, $100, $80, $01
  
  INC A ;This should run before the IRQ
  INC A ;This should run before the IRQ
  INC A ;This shouldn't   => Result (A) = $02
  INC A
  
  sei  
  LDA #0
  stz PPUNMI
  rtl
.endproc

test2: .asciiz "IRQ - LDA IMM8        "
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
  lda #00
  runDma $01, $8000, $100, $80, $01
  
  ;Try running some instructions after DMA, IRQ should occur before these are done
  LDA #01 ;This should run before the IRQ
  LDA #02 ;This should run before the IRQ
  LDA #03 ;This shouldn't   => Result (A) = $03
  LDA #04
  
  sei  
  LDA #0
  stz PPUNMI
  rtl
.endproc

test3: .asciiz "IRQ - LDA16+INC       "
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
  seta16
  lda #00
  runDma $01, $8000, $100, $80, $01
  
  ;Try running some instructions after DMA, IRQ should occur before these are done
  LDA #0001 ;This should run before the IRQ
  INC A     ;This shouldn't  => Result (A) = $01
  INC A     
  INC A
  
  seta8
  sei  
  LDA #0
  stz PPUNMI
  rtl
.endproc

test4: .asciiz "IRQ - INC+LDA16       "
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
  seta16
  lda #00
  runDma $01, $8000, $100, $80, $01
  
  ;Try running some instructions after DMA, IRQ should occur before these are done
  INC A     ;This should run before the IRQ
  LDA #0002 ;This should run before the IRQ
  LDA #0003 ;This shouldn't   => Result (A) = $02
  LDA #0003
  
  seta8
  sei  
  LDA #0
  stz PPUNMI
  rtl
.endproc

test5: .asciiz "IRQ - CLI+INC         "
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
  lda #00
  runDma $01, $8000, $100, $80, $01
  
  ;Try running some instructions after DMA, IRQ should occur before these are done
  cli   ;This should run before the IRQ
  INC A ;This should run before the IRQ
  INC A ;This shouldn't   => Result (A) = $01
  INC A
  
  sei  
  LDA #0
  stz PPUNMI
  rtl
.endproc

test6: .asciiz "IRQ - SEI+INC         "
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
  lda #00
  runDma $01, $8000, $100, $80, $01
  
  ;Try running some instructions after DMA, IRQ should never occur because of SEI call
  sei     ;This should prevent the IRQ from occurring 
  inc A   
  lda #$FF ;   => Result (A) = $FF
  sta valueOnIrq  
  
  LDA #0
  stz PPUNMI
  rtl
.endproc

test7: .asciiz "IRQ - SEI+CLI+INC     "
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
  lda #00
  runDma $01, $8000, $100, $80, $01
  
  ;Try running some instructions after DMA
  sei            ;This should prevent the IRQ from running
  cli            ;This should allow the IRQ to fire, after running 'inc a' below
  inc A			 ;   => Result (A) = $01 
  lda #$FF       ;This shouldn't run before the IRQ
  
  sei  
  LDA #0
  stz PPUNMI
  rtl
.endproc

test8: .asciiz "NMI - INC A           "
.proc runTest8
  ;Wait for the start of the frame
  jsl ppu_start_frame
  
  ;Wait till scanline 224
  jsl ppu_end_frame

  seta8
  LDA #VBLANK_NMI
  sta PPUNMI
  
  sei
  
  ;Start DMA
  setWorkRamAddress $01, $0000
  lda #00
  runDma $01, $8000, $100, $80, $01
  
  ;Try running some instructions after DMA
  inc A
  inc A  ;This should run before NMI 
  inc A  ;This shouldn't run     => Result (A) = $02
  inc A
  
  sei  
  LDA #0
  stz PPUNMI
  rtl
.endproc


test9: .asciiz "NMI - LDA IMM16       "
.proc runTest9
  ;Wait for the start of the frame
  jsl ppu_start_frame
  
  ;Wait till scanline 224
  jsl ppu_end_frame

  seta8
  LDA #VBLANK_NMI
  sta PPUNMI
  
  sei
  
  ;Start DMA
  setWorkRamAddress $01, $0000
  seta16
  lda #00
  runDma $01, $8000, $100, $80, $01
  
  ;Try running some instructions after DMA
  lda #$0001  
  lda #$0002 ;This shouldn't run before NMI => Result (A) = $01
  lda #$0003 
  lda #$0004
  
  seta8
  sei  
  LDA #0
  stz PPUNMI
  rtl
.endproc

test10: .asciiz "NMI - CLI+INC         "
.proc runTest10
  ;Wait for the start of the frame
  jsl ppu_start_frame
  
  ;Wait till scanline 224
  jsl ppu_end_frame

  seta8
  LDA #VBLANK_NMI
  sta PPUNMI
  
  sei
  
  ;Start DMA
  setWorkRamAddress $01, $0000
  lda #00
  runDma $01, $8000, $100, $80, $01
  
  ;Try running some instructions after DMA
  cli
  inc a   ;This should run before NMI
  inc a   ;This shouldn't run before NMI  => Result (A) = $01
  inc a
  
  sei  
  LDA #0
  stz PPUNMI
  rtl
.endproc

test11: .asciiz "W16:IRQ - INC A       "
.proc runTest11
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
  lda #00
  runDma16 $01, $8000, $100, $80, $01
  
  INC A ;This should run before the IRQ
  INC A ;This shouldn't => Result = $01
  INC A
  INC A
  
  sei  
  LDA #0
  stz PPUNMI
  rtl
.endproc

test12: .asciiz "W16:IRQ - LDA IMM8    "
.proc runTest12
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
  lda #00
  runDma16 $01, $8000, $100, $80, $01
  
  ;Try running some instructions after DMA, IRQ should occur before these are done
  LDA #01 ;This should run before the IRQ
  LDA #02 ;This shouldn't => Result = $01
  LDA #03
  LDA #04
  
  sei  
  LDA #0
  stz PPUNMI
  rtl
.endproc

test13: .asciiz "W16:IRQ - LDA16+INC   "
.proc runTest13
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
  lda #00
  seta16
  runDma16 $01, $8000, $100, $80, $01
  ;Try running some instructions after DMA, IRQ should occur before these are done
  LDA #0001 ;This should run before the IRQ
  INC A     ;This shouldn't => Result = $01
  INC A
  INC A
  
  seta8
  sei  
  LDA #0
  stz PPUNMI
  rtl
.endproc

test14: .asciiz "W16:IRQ - INC+LDA16   "
.proc runTest14
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
  lda #00
  seta16
  runDma16 $01, $8000, $100, $80, $01
  ;Try running some instructions after DMA, IRQ should occur before these are done
  INC A     ;This should run before the IRQ
  LDA #0002 ;This shouldn't => Result = $01
  LDA #0003
  LDA #0004
  
  seta8
  sei  
  LDA #0
  stz PPUNMI
  rtl
.endproc

test15: .asciiz "W16:IRQ - CLI+INC     "
.proc runTest15
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
  lda #00
  runDma16 $01, $8000, $100, $80, $01
  
  ;Try running some instructions after DMA, IRQ should occur before these are done
  cli   ;This should run before the IRQ
  INC A ;This should run before the IRQ
  INC A ;This shouldn't => Result = $01
  INC A
  
  sei  
  LDA #0
  stz PPUNMI
  rtl
.endproc

test16: .asciiz "W16:IRQ - SEI+INC     "
.proc runTest16
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
  lda #00
  runDma16 $01, $8000, $100, $80, $01
  
  ;Try running some instructions after DMA, IRQ should never occur because of SEI call
  sei     ;This should prevent the IRQ from occurring
  inc A
  lda #$FF  ; => Result = $FF
  sta valueOnIrq  
  
  LDA #0
  stz PPUNMI
  rtl
.endproc

test17: .asciiz "W16:NMI - INC A       "
.proc runTest17
  ;Wait for the start of the frame
  jsl ppu_start_frame
  
  ;Wait till scanline 224
  jsl ppu_end_frame

  seta8
  LDA #VBLANK_NMI
  sta PPUNMI
  
  sei
  
  ;Start DMA
  setWorkRamAddress $01, $0000
  lda #00
  runDma16 $01, $8000, $100, $80, $01
  
  ;Try running some instructions after DMA
  inc A
  inc A ; This shouldn't run before NMI => Result = $01
  inc A
  inc A
  
  sei  
  LDA #0
  stz PPUNMI
  rtl
.endproc


test18: .asciiz "W16:NMI - LDA IMM16   "
.proc runTest18
  ;Wait for the start of the frame
  jsl ppu_start_frame
  
  ;Wait till scanline 224
  jsl ppu_end_frame

  seta8
  LDA #VBLANK_NMI
  sta PPUNMI
  
  sei
  
  ;Start DMA
  setWorkRamAddress $01, $0000
  seta16
  lda #00
  runDma16 $01, $8000, $100, $80, $01
  
  ;Try running some instructions after DMA
  lda #$0001 
  lda #$0002 ;This shouldn't run before NMI => Result = $01
  lda #$0003
  lda #$0004
  
  sei  
  LDA #0
  stz PPUNMI
  rtl
.endproc

test19: .asciiz "W16:NMI - CLI+INC     "
.proc runTest19
  ;Wait for the start of the frame
  jsl ppu_start_frame
  
  ;Wait till scanline 224
  jsl ppu_end_frame

  seta8
  LDA #VBLANK_NMI
  sta PPUNMI
  
  sei
  
  ;Start DMA
  setWorkRamAddress $01, $0000
  lda #00
  runDma16 $01, $8000, $100, $80, $01
  
  ;Try running some instructions after DMA
  cli
  inc a ;This shouldn't run before NMI => Result = $01
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
  setaxy8
  sta valueOnIrq
  
  bit a:NMISTATUS
  rti
.endproc

;;
; This program doesn't use IRQs either.
.proc irq_handler
  setaxy8
  sta valueOnIrq
  lda TIMESTATUS
  rti
.endproc