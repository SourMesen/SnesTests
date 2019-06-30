.include "snes.inc"
.include "global.inc"
.include "testmacros.inc"
.smart
.export main21

.segment "ZEROPAGE"

dirPtr: .res 3


.segment "CODE16"

header:    .asciiz "DIRECT STORE TIMING TEST"

; init.s sends us here
.proc main21
  testCount = 16
  
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

test1:    .asciiz  "STA XM "
.proc runTest1
  testXM
  .repeat 100
  sta dirPtr
  .endrepeat
  rts
.endproc

test2:    .asciiz  "STA -- "
.proc runTest2
  testAXY16
  .repeat 100
  sta dirPtr
  .endrepeat
  rts
.endproc

test3:    .asciiz  "STA X- "
.proc runTest3
  testX
  .repeat 100
  sta dirPtr
  .endrepeat
  rts
.endproc

test4:    .asciiz  "STA -M "
.proc runTest4
  testM 
  .repeat 100
  sta dirPtr
  .endrepeat
  rts
.endproc

test5:    .asciiz  "STY XM "
.proc runTest5
  testXM
  .repeat 100
  STY dirPtr
  .endrepeat
  rts
.endproc

test6:    .asciiz  "STY -- "
.proc runTest6
  testAXY16
  .repeat 100
  STY dirPtr
  .endrepeat
  rts
.endproc

test7:    .asciiz  "STY X- "
.proc runTest7
  testX
  .repeat 100
  STY dirPtr
  .endrepeat
  rts
.endproc

test8:    .asciiz  "STY -M "
.proc runTest8
  testM 
  .repeat 100
  STY dirPtr
  .endrepeat
  rts
.endproc

test9:    .asciiz  "STX XM "
.proc runTest9
  testXM
  .repeat 100
  STX dirPtr
  .endrepeat
  rts
.endproc

test10:    .asciiz  "STX -- "
.proc runTest10
  testAXY16
  .repeat 100
  STX dirPtr
  .endrepeat
  rts
.endproc

test11:    .asciiz  "STX X- "
.proc runTest11
  testX
  .repeat 100
  STX dirPtr
  .endrepeat
  rts
.endproc

test12:    .asciiz  "STX -M "
.proc runTest12
  testM 
  .repeat 100
  STX dirPtr
  .endrepeat
  rts
.endproc

test13:    .asciiz  "STZ XM "
.proc runTest13
  testXM
  .repeat 100
  STZ dirPtr
  .endrepeat
  rts
.endproc

test14:    .asciiz  "STZ -- "
.proc runTest14
  testAXY16
  .repeat 100
  STZ dirPtr
  .endrepeat
  rts
.endproc

test15:    .asciiz  "STZ X- "
.proc runTest15
  testX
  .repeat 100
  STZ dirPtr
  .endrepeat
  rts
.endproc

test16:    .asciiz  "STZ -M "
.proc runTest16
  testM 
  .repeat 100
  STZ dirPtr
  .endrepeat
  rts
.endproc
