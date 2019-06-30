.include "snes.inc"
.include "global.inc"
.include "testmacros.inc"
.smart
.export main15

.segment "ZEROPAGE"

dirPtr: .res 3


.segment "CODE10"

header:    .asciiz "DIRECT,Y TIMING TEST"

; init.s sends us here
.proc main15
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


test1:    .asciiz  "STX XM "
.proc runTest1
  testXM
  .repeat 100
  stx dirPtr,y
  .endrepeat
  rts
.endproc

test2:    .asciiz  "STX -- "
.proc runTest2
  testAXY16
  .repeat 100
  stx dirPtr,y
  .endrepeat
  rts
.endproc

test3:    .asciiz  "STX X- "
.proc runTest3
  testX
  .repeat 100
  stx dirPtr,y
  .endrepeat
  rts
.endproc

test4:    .asciiz  "STX -M "
.proc runTest4
  testM 
  .repeat 100
  stx dirPtr,y
  .endrepeat
  rts
.endproc

test5:    .asciiz  "LDX XM "
.proc runTest5
  testXM
  .repeat 100
  LDX dirPtr,y
  .endrepeat
  rts
.endproc

test6:    .asciiz  "LDX -- "
.proc runTest6
  testAXY16
  .repeat 100
  LDX dirPtr,y
  .endrepeat
  rts
.endproc

test7:    .asciiz  "LDX X- "
.proc runTest7
  testX
  .repeat 100
  LDX dirPtr,y
  .endrepeat
  rts
.endproc

test8:    .asciiz  "LDX -M "
.proc runTest8
  testM 
  .repeat 100
  LDX dirPtr,y
  .endrepeat
  rts
.endproc
