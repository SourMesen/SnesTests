.include "snes.inc"
.include "global.inc"
.include "testmacros.inc"
.smart
.export main5

.segment "ZEROPAGE"



.segment "CODE6"

header:    .asciiz "ABSOLUTE (RMW) TIMING TEST"

; init.s sends us here
.proc main5
  testCount = 32
  
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
  ASL a:$8000
  .endrepeat
  rts
.endproc

test2:    .asciiz  "ASL -- "
.proc runTest2
  testAXY16
  .repeat 100
  ASL a:$8000
  .endrepeat
  rts
.endproc

test3:    .asciiz  "DEC XM "
.proc runTest3
  testXM
  .repeat 100
  DEC a:$8000
  .endrepeat
  rts
.endproc

test4:    .asciiz  "DEC -- "
.proc runTest4
  testAXY16
  .repeat 100
  DEC a:$8000
  .endrepeat
  rts
.endproc

test5:    .asciiz  "INC XM "
.proc runTest5
  testXM
  .repeat 100
  INC a:$8000
  .endrepeat
  rts
.endproc

test6:    .asciiz  "INC -- "
.proc runTest6
  testAXY16
  .repeat 100
  INC a:$8000
  .endrepeat
  rts
.endproc

test7:    .asciiz  "LSR -M "
.proc runTest7
  testM
  .repeat 100
  LSR a:$8000
  .endrepeat
  rts
.endproc

test8:    .asciiz  "ROL X- "
.proc runTest8
  testX
  .repeat 100
  ROL a:$8000
  .endrepeat
  rts
.endproc

test9:    .asciiz  "ROR XM "
.proc runTest9
  testXM 
  .repeat 100
  ROR a:$8000
  .endrepeat
  rts
.endproc

test10:    .asciiz  "ROR -- "
.proc runTest10
  testAXY16
  .repeat 100
  ROR a:$8000
  .endrepeat
  rts
.endproc

test11:    .asciiz  "TRB XM "
.proc runTest11
  testXM 
  .repeat 100
  TRB a:$8000
  .endrepeat
  rts
.endproc

test12:    .asciiz  "TRB -- "
.proc runTest12
  testAXY16
  .repeat 100
  TRB a:$8000
  .endrepeat
  rts
.endproc

test13:    .asciiz  "TSB XM "
.proc runTest13
  testXM 
  .repeat 100
  TSB a:$8000
  .endrepeat
  rts
.endproc

test14:    .asciiz  "TSB -- "
.proc runTest14
  testAXY16
  .repeat 100
  TSB a:$8000
  .endrepeat
  rts
.endproc

test15:    .asciiz  "ROR X- "
.proc runTest15
  testX
  .repeat 100
  ROR a:$8000
  .endrepeat
  rts
.endproc

test16:    .asciiz  "ROR -M "
.proc runTest16
  testM
  .repeat 100
  ROR a:$8000
  .endrepeat
  rts
.endproc

test17:    .asciiz  "TRB X- "
.proc runTest17
  testX 
  .repeat 100
  TRB a:$8000
  .endrepeat
  rts
.endproc

test18:    .asciiz  "TSB X- "
.proc runTest18
  testX 
  .repeat 100
  TSB a:$8000
  .endrepeat
  rts
.endproc

test19:    .asciiz  "TSB -M "
.proc runTest19
  testM
  .repeat 100
  TSB a:$8000
  .endrepeat
  rts
.endproc

test20:    .asciiz  "LSR X- "
.proc runTest20
  testX 
  .repeat 100
  LSR a:$8000
  .endrepeat
  rts
.endproc

test21:    .asciiz  "INC X- "
.proc runTest21
  testX
  .repeat 100
  INC a:$8000
  .endrepeat
  rts
.endproc

test22:    .asciiz  "INC -M "
.proc runTest22
  testM
  .repeat 100
  INC a:$8000
  .endrepeat
  rts
.endproc

test23:    .asciiz  "LSR XM "
.proc runTest23
  testXM 
  .repeat 100
  LSR a:$8000
  .endrepeat
  rts
.endproc

test24:    .asciiz  "LSR -- "
.proc runTest24
  testAXY16
  .repeat 100
  LSR a:$8000
  .endrepeat
  rts
.endproc

test25:    .asciiz  "ROL XM "
.proc runTest25
  testXM 
  .repeat 100
  ROL a:$8000
  .endrepeat
  rts
.endproc

test26:    .asciiz  "ROL -- "
.proc runTest26
  testAXY16
  .repeat 100
  ROL a:$8000
  .endrepeat
  rts
.endproc

test27:    .asciiz  "ROL -M "
.proc runTest27
  testM
  .repeat 100
  ROL a:$8000
  .endrepeat
  rts
.endproc

test28:    .asciiz  "ASL X- "
.proc runTest28
  testX
  .repeat 100
  ASL a:$8000
  .endrepeat
  rts
.endproc

test29:    .asciiz  "ASL -M "
.proc runTest29
  testM
  .repeat 100
  ASL a:$8000
  .endrepeat
  rts
.endproc

test30:    .asciiz  "DEC X- "
.proc runTest30
  testX
  .repeat 100
  DEC a:$8000
  .endrepeat
  rts
.endproc

test31:    .asciiz  "DEC -M "
.proc runTest31
  testM
  .repeat 100
  DEC a:$8000
  .endrepeat
  rts
.endproc

test32:    .asciiz  "TRB -M "
.proc runTest32
  testM
  .repeat 100
  TRB a:$8000
  .endrepeat
  rts
.endproc

