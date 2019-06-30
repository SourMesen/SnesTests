.include "snes.inc"
.include "global.inc"
.include "testmacros.inc"
.smart
.export main7

.segment "ZEROPAGE"



.segment "CODE8"

header:    .asciiz "ABSOLUTE LONG TIMING TEST"

; init.s sends us here
.proc main7
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


test1:    .asciiz  "LDA XM "
.proc runTest1
  testXM
  .repeat 100
  lda f:$8000
  .endrepeat
  rts
.endproc

test2:    .asciiz  "LDA -- "
.proc runTest2
  testAXY16
  .repeat 100
  lda f:$8000
  .endrepeat
  rts
.endproc

test3:    .asciiz  "STA -M "
.proc runTest3
  testM
  .repeat 100
  STA f:$8000
  .endrepeat
  rts
.endproc

test4:    .asciiz  "ADC -M "
.proc runTest4
  testM
  .repeat 100
  adc f:$8000
  .endrepeat
  rts
.endproc

test5:    .asciiz  "SBC X- "
.proc runTest5
  testX 
  .repeat 100
  sbc f:$8000
  .endrepeat
  rts
.endproc

test6:    .asciiz  "EOR X- "
.proc runTest6
  testX 
  .repeat 100
  eor f:$8000
  .endrepeat
  rts
.endproc

test7:    .asciiz  "EOR -M "
.proc runTest7
  testM
  .repeat 100
  eor f:$8000
  .endrepeat
  rts
.endproc

test8:    .asciiz  "ORA X- "
.proc runTest8
  testX
  .repeat 100
  ora f:$8000
  .endrepeat
  rts
.endproc

test9:    .asciiz  "ADC XM "
.proc runTest9
  testXM 
  .repeat 100
  adc f:$8000
  .endrepeat
  rts
.endproc

test10:    .asciiz  "ADC -- "
.proc runTest10
  testAXY16
  .repeat 100
  adc f:$8000
  .endrepeat
  rts
.endproc

test11:    .asciiz  "SBC XM "
.proc runTest11
  testXM 
  .repeat 100
  sbc f:$8000
  .endrepeat
  rts
.endproc

test12:    .asciiz  "SBC -- "
.proc runTest12
  testAXY16
  .repeat 100
  sbc f:$8000
  .endrepeat
  rts
.endproc

test13:    .asciiz  "AND XM "
.proc runTest13
  testXM 
  .repeat 100
  and f:$8000
  .endrepeat
  rts
.endproc

test14:    .asciiz  "AND -- "
.proc runTest14
  testAXY16
  .repeat 100
  and f:$8000
  .endrepeat
  rts
.endproc

test15:    .asciiz  "AND X- "
.proc runTest15
  testX 
  .repeat 100
  and f:$8000
  .endrepeat
  rts
.endproc

test16:    .asciiz  "AND -M "
.proc runTest16
  testM
  .repeat 100
  and f:$8000
  .endrepeat
  rts
.endproc


test17:    .asciiz  "CMP XM "
.proc runTest17
  testXM 
  .repeat 100
  cmp f:$8000
  .endrepeat
  rts
.endproc

test18:    .asciiz  "CMP -- "
.proc runTest18
  testAXY16
  .repeat 100
  cmp f:$8000
  .endrepeat
  rts
.endproc

test19:    .asciiz  "STA XM "
.proc runTest19
  testXM 
  .repeat 100
  STA f:$8000
  .endrepeat
  rts
.endproc

test20:    .asciiz  "STA -- "
.proc runTest20
  testAXY16
  .repeat 100
  STA f:$8000
  .endrepeat
  rts
.endproc

test21:    .asciiz  "STA X- "
.proc runTest21
  testX
  .repeat 100
  STA f:$8000
  .endrepeat
  rts
.endproc

test22:    .asciiz  "ADC X- "
.proc runTest22
  testX
  .repeat 100
  adc f:$8000
  .endrepeat
  rts
.endproc

test23:    .asciiz  "EOR XM "
.proc runTest23
  testXM 
  .repeat 100
  eor f:$8000
  .endrepeat
  rts
.endproc

test24:    .asciiz  "EOR -- "
.proc runTest24
  testAXY16
  .repeat 100
  eor f:$8000
  .endrepeat
  rts
.endproc

test25:    .asciiz  "ORA XM "
.proc runTest25
  testXM 
  .repeat 100
  ora f:$8000
  .endrepeat
  rts
.endproc

test26:    .asciiz  "ORA -- "
.proc runTest26
  testAXY16
  .repeat 100
  ora f:$8000
  .endrepeat
  rts
.endproc

test27:    .asciiz  "ORA -M "
.proc runTest27
  testM
  .repeat 100
  ora f:$8000
  .endrepeat
  rts
.endproc

test28:    .asciiz  "LDA X- "
.proc runTest28
  testX
  .repeat 100
  lda f:$8000
  .endrepeat
  rts
.endproc

test29:    .asciiz  "LDA -M "
.proc runTest29
  testM
  .repeat 100
  lda f:$8000
  .endrepeat
  rts
.endproc

test30:    .asciiz  "SBC -M "
.proc runTest30
  testM
  .repeat 100
  sbc f:$8000
  .endrepeat
  rts
.endproc

test31:    .asciiz  "CMP X- "
.proc runTest31
  testX 
  .repeat 100
  cmp f:$8000
  .endrepeat
  rts
.endproc

test32:    .asciiz  "CMP -M "
.proc runTest32
  testM
  .repeat 100
  cmp f:$8000
  .endrepeat
  rts
.endproc
