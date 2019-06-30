.include "snes.inc"
.include "global.inc"
.include "testmacros.inc"
.smart
.export main24

.segment "ZEROPAGE"

dirPtr: .res 3


.segment "CODE19"

header:    .asciiz "MOVE TIMING TEST"

; init.s sends us here
.proc main24
  testCount = 8
  
  jsl initTest

  setaxy16
  lda #$8000
  sta dirPtr
  seta8
  lda #$00
  sta dirPtr+2  
  
  .repeat testCount, I
  .scope
    funcName = .ident(.sprintf("runTest%s", .string(I+1)))
    runTest funcName, (I+1)
  .endscope
  .endrep
  
  jsl beforeDisplayResult
  
  setaxy16
  displayMessage header, 2, 1

  .repeat testCount, I
    displayResult (I+1)
  .endrep
  
  jsl finishTest
  rtl
.endproc


test1:    .asciiz  "MVN XM "
.proc runTest1
  phb
  .repeat 100
  testAXY16
  lda #$04
  testXM
  ldx #$00
  ldy #$00
  mvn $FF, $FF
  .endrepeat
  plb
  rts
.endproc

test2:    .asciiz  "MVN -- "
.proc runTest2
  phb
  testAXY16
  .repeat 100
  lda #$04
  ldx #$00
  ldy #$00
  mvn $FF, $FF
  .endrepeat
  plb
  rts
.endproc

test3:    .asciiz  "MVN X- "
.proc runTest3 
  phb
  .repeat 100
  testAXY16
  lda #$04
  testX
  
  ldx #$00
  ldy #$00
  mvn $FF, $FF
  .endrepeat
  plb
  rts
.endproc

test4:    .asciiz  "MVN -M "
.proc runTest4
  phb
  .repeat 100
  testAXY16
  lda #$04
  testM

  ldx #$00
  ldy #$00
  mvn $FF, $FF
  .endrepeat
  plb
  rts
.endproc

test5:    .asciiz  "MVP XM "
.proc runTest5
  phb
  .repeat 100
  testAXY16
  lda #$04
  testXM
  
  ldx #$00
  ldy #$00
  mvp $FF, $FF
  .endrepeat
  plb
  rts
.endproc

test6:    .asciiz  "MVP -- "
.proc runTest6
  phb
  testAXY16
  .repeat 100
  lda #$04
  ldx #$00
  ldy #$00
  mvp $FF, $FF
  .endrepeat
  plb
  rts
.endproc

test7:    .asciiz  "MVP X- "
.proc runTest7
  phb
  .repeat 100
  testAXY16
  lda #$04
  testX

  ldx #$00
  ldy #$00
  mvp $FF, $FF
  .endrepeat
  plb
  rts
.endproc

test8:    .asciiz  "MVP -M "
.proc runTest8
  phb
  .repeat 100
  testAXY16
  lda #$04
  testM

  ldx #$00
  ldy #$00
  mvp $FF, $FF
  .endrepeat
  plb
  rts
.endproc
