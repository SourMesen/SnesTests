.include "snes.inc"
.include "global.inc"
.include "testmacros.inc"
.smart
.export main20

.segment "ZEROPAGE"

dirPtr: .res 3


.segment "CODE15"

header:    .asciiz "DIRECT (RMW) STORE TIMING TEST"

; init.s sends us here
.proc main20
  testCount = 32
  
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

test1:    .asciiz  "ASL XM "
.proc runTest1
  testXM
  .repeat 100
  ASL dirPtr
  .endrepeat
  rts
.endproc

test2:    .asciiz  "ASL -- "
.proc runTest2
  testAXY16
  .repeat 100
  ASL dirPtr
  .endrepeat
  rts
.endproc

test3:    .asciiz  "ASL X- "
.proc runTest3
  testX
  .repeat 100
  ASL dirPtr
  .endrepeat
  rts
.endproc

test4:    .asciiz  "ASL -M "
.proc runTest4
  testM 
  .repeat 100
  ASL dirPtr
  .endrepeat
  rts
.endproc

test5:    .asciiz  "DEC XM "
.proc runTest5
  testXM
  .repeat 100
  DEC dirPtr
  .endrepeat
  rts
.endproc

test6:    .asciiz  "DEC -- "
.proc runTest6
  testAXY16
  .repeat 100
  DEC dirPtr
  .endrepeat
  rts
.endproc

test7:    .asciiz  "DEC X- "
.proc runTest7
  testX
  .repeat 100
  DEC dirPtr
  .endrepeat
  rts
.endproc

test8:    .asciiz  "DEC -M "
.proc runTest8
  testM 
  .repeat 100
  DEC dirPtr
  .endrepeat
  rts
.endproc

test9:    .asciiz  "INC XM "
.proc runTest9
  testXM
  .repeat 100
  INC dirPtr
  .endrepeat
  rts
.endproc

test10:    .asciiz  "INC -- "
.proc runTest10
  testAXY16
  .repeat 100
  INC dirPtr
  .endrepeat
  rts
.endproc

test11:    .asciiz  "INC X- "
.proc runTest11
  testX
  .repeat 100
  INC dirPtr
  .endrepeat
  rts
.endproc

test12:    .asciiz  "INC -M "
.proc runTest12
  testM 
  .repeat 100
  INC dirPtr
  .endrepeat
  rts
.endproc

test13:    .asciiz  "LSR XM "
.proc runTest13
  testXM
  .repeat 100
  LSR dirPtr
  .endrepeat
  rts
.endproc

test14:    .asciiz  "LSR -- "
.proc runTest14
  testAXY16
  .repeat 100
  LSR dirPtr
  .endrepeat
  rts
.endproc

test15:    .asciiz  "LSR X- "
.proc runTest15
  testX
  .repeat 100
  LSR dirPtr
  .endrepeat
  rts
.endproc

test16:    .asciiz  "LSR -M "
.proc runTest16
  testM 
  .repeat 100
  LSR dirPtr
  .endrepeat
  rts
.endproc

test17:    .asciiz  "ROL XM "
.proc runTest17
  testXM
  .repeat 100
  ROL dirPtr
  .endrepeat
  rts
.endproc

test18:    .asciiz  "ROL -- "
.proc runTest18
  testAXY16
  .repeat 100
  ROL dirPtr
  .endrepeat
  rts
.endproc

test19:    .asciiz  "ROL X- "
.proc runTest19
  testX
  .repeat 100
  ROL dirPtr
  .endrepeat
  rts
.endproc

test20:    .asciiz  "ROL -M "
.proc runTest20
  testM 
  .repeat 100
  ROL dirPtr
  .endrepeat
  rts
.endproc

test21:    .asciiz  "ROR XM "
.proc runTest21
  testXM
  .repeat 100
  ROR dirPtr
  .endrepeat
  rts
.endproc

test22:    .asciiz  "ROR -- "
.proc runTest22
  testAXY16
  .repeat 100
  ROR dirPtr
  .endrepeat
  rts
.endproc

test23:    .asciiz  "ROR X- "
.proc runTest23
  testX
  .repeat 100
  ROR dirPtr
  .endrepeat
  rts
.endproc

test24:    .asciiz  "ROR -M "
.proc runTest24
  testM 
  .repeat 100
  ROR dirPtr
  .endrepeat
  rts
.endproc

test25:    .asciiz  "TRB XM "
.proc runTest25
  testXM
  .repeat 100
  TRB dirPtr
  .endrepeat
  rts
.endproc

test26:    .asciiz  "TRB -- "
.proc runTest26
  testAXY16
  .repeat 100
  TRB dirPtr
  .endrepeat
  rts
.endproc

test27:    .asciiz  "TRB X- "
.proc runTest27
  testX
  .repeat 100
  TRB dirPtr
  .endrepeat
  rts
.endproc

test28:    .asciiz  "TRB -M "
.proc runTest28
  testM 
  .repeat 100
  TRB dirPtr
  .endrepeat
  rts
.endproc

test29:    .asciiz  "TSB XM "
.proc runTest29
  testXM
  .repeat 100
  TSB dirPtr
  .endrepeat
  rts
.endproc

test30:    .asciiz  "TSB -- "
.proc runTest30
  testAXY16
  .repeat 100
  TSB dirPtr
  .endrepeat
  rts
.endproc

test31:    .asciiz  "TSB X- "
.proc runTest31
  testX
  .repeat 100
  TSB dirPtr
  .endrepeat
  rts
.endproc

test32:    .asciiz  "TSB -M "
.proc runTest32
  testM 
  .repeat 100
  TSB dirPtr
  .endrepeat
  rts
.endproc
