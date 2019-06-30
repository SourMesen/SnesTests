.include "snes.inc"
.include "global.inc"
.include "testmacros.inc"
.smart
.export main3

.segment "ZEROPAGE"



.segment "CODE4"

header:    .asciiz "ABSOLUTE, X (RMW) TIMING TEST"

; init.s sends us here
.proc main3
  testCount = 24
  
  jsl initTest
	
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
  ASL a:$8000,x
  .endrepeat
  rts
.endproc

test2:    .asciiz  "ASL -- "
.proc runTest2
  testAXY16
  .repeat 100
  ASL a:$8000,x
  .endrepeat
  rts
.endproc

test3:    .asciiz  "DEC XM "
.proc runTest3
  testXM
  .repeat 100
  DEC a:$8000,x
  .endrepeat
  rts
.endproc

test4:    .asciiz  "DEC -- "
.proc runTest4
  testAXY16
  .repeat 100
  DEC a:$8000,x
  .endrepeat
  rts
.endproc

test5:    .asciiz  "INC XM "
.proc runTest5
  testXM
  .repeat 100
  INC a:$8000,x
  .endrepeat
  rts
.endproc

test6:    .asciiz  "INC -- "
.proc runTest6
  testAXY16
  .repeat 100
  INC a:$8000,x
  .endrepeat
  rts
.endproc

test7:    .asciiz  "LSR -M "
.proc runTest7
  testM
  .repeat 100
  LSR a:$8000,x
  .endrepeat
  rts
.endproc

test8:    .asciiz  "ROL X- "
.proc runTest8
  testX
  .repeat 100
  ROL a:$8000,x
  .endrepeat
  rts
.endproc

test9:    .asciiz  "ROR XM "
.proc runTest9
  testXM 
  .repeat 100
  ROR a:$8000,x
  .endrepeat
  rts
.endproc

test10:    .asciiz  "ROR -- "
.proc runTest10
  testAXY16
  .repeat 100
  ROR a:$8000,x
  .endrepeat
  rts
.endproc

test11:    .asciiz  "ASL X- "
.proc runTest11
  testX
  .repeat 100
  ASL a:$8000,x
  .endrepeat
  rts
.endproc

test12:    .asciiz  "ASL -M "
.proc runTest12
  testM
  .repeat 100
  ASL a:$8000,x
  .endrepeat
  rts
.endproc

test13:    .asciiz  "DEC X- "
.proc runTest13
  testX
  .repeat 100
  DEC a:$8000,x
  .endrepeat
  rts
.endproc

test14:    .asciiz  "DEC -M "
.proc runTest14
  testM
  .repeat 100
  DEC a:$8000,x
  .endrepeat
  rts
.endproc

test15:    .asciiz  "ROR X- "
.proc runTest15
  testX
  .repeat 100
  ROR a:$8000,x
  .endrepeat
  rts
.endproc

test16:    .asciiz  "ROR -M "
.proc runTest16
  testM
  .repeat 100
  ROR a:$8000,x
  .endrepeat
  rts
.endproc

test17:    .asciiz  "ROL XM "
.proc runTest17
  testXM 
  .repeat 100
  ROL a:$8000,x
  .endrepeat
  rts
.endproc

test18:    .asciiz  "ROL -- "
.proc runTest18
  testAXY16
  .repeat 100
  ROL a:$8000,x
  .endrepeat
  rts
.endproc

test19:    .asciiz  "ROL -M "
.proc runTest19
  testM
  .repeat 100
  ROL a:$8000,x
  .endrepeat
  rts
.endproc

test20:    .asciiz  "LSR X- "
.proc runTest20
  testX 
  .repeat 100
  LSR a:$8000,x
  .endrepeat
  rts
.endproc

test21:    .asciiz  "INC X- "
.proc runTest21
  testX
  .repeat 100
  INC a:$8000,x
  .endrepeat
  rts
.endproc

test22:    .asciiz  "INC -M "
.proc runTest22
  testM
  .repeat 100
  INC a:$8000,x
  .endrepeat
  rts
.endproc

test23:    .asciiz  "LSR XM "
.proc runTest23
  testXM 
  .repeat 100
  LSR a:$8000,x
  .endrepeat
  rts
.endproc

test24:    .asciiz  "LSR -- "
.proc runTest24
  testAXY16
  .repeat 100
  LSR a:$8000,x
  .endrepeat
  rts
.endproc
