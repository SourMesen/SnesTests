.include "snes.inc"
.include "global.inc"
.include "testmacros.inc"
.smart
.export main1

.segment "ZEROPAGE"



.segment "CODE2"

header:    .asciiz "ABSOLUTE TIMING TEST"

; init.s sends us here
.proc main1
  testCount = 48
  
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
  lda a:$8000
  .endrepeat
  rts
.endproc

test2:    .asciiz  "LDA -- "
.proc runTest2
  testAXY16
  .repeat 100
  lda a:$8000
  .endrepeat
  rts
.endproc

test3:    .asciiz  "LDX XM "
.proc runTest3
  testXM
  .repeat 100
  ldx a:$8000
  .endrepeat
  rts
.endproc

test4:    .asciiz  "LDX -- "
.proc runTest4
  testAXY16
  .repeat 100
  ldx a:$8000
  .endrepeat
  rts
.endproc

test5:    .asciiz  "LDY XM "
.proc runTest5
  testXM
  .repeat 100
  ldy a:$8000
  .endrepeat
  rts
.endproc

test6:    .asciiz  "LDY -- "
.proc runTest6
  testAXY16
  .repeat 100
  ldy a:$8000
  .endrepeat
  rts
.endproc

test7:    .asciiz  "EOR -M "
.proc runTest7
  testM
  .repeat 100
  eor a:$8000
  .endrepeat
  rts
.endproc

test8:    .asciiz  "ORA X- "
.proc runTest8
  testX
  .repeat 100
  ora a:$8000
  .endrepeat
  rts
.endproc

test9:    .asciiz  "ADC XM "
.proc runTest9
  testXM 
  .repeat 100
  adc a:$8000
  .endrepeat
  rts
.endproc

test10:    .asciiz  "ADC -- "
.proc runTest10
  testAXY16
  .repeat 100
  adc a:$8000
  .endrepeat
  rts
.endproc

test11:    .asciiz  "SBC XM "
.proc runTest11
  testXM 
  .repeat 100
  sbc a:$8000
  .endrepeat
  rts
.endproc

test12:    .asciiz  "SBC -- "
.proc runTest12
  testAXY16
  .repeat 100
  sbc a:$8000
  .endrepeat
  rts
.endproc

test13:    .asciiz  "AND XM "
.proc runTest13
  testXM 
  .repeat 100
  and a:$8000
  .endrepeat
  rts
.endproc

test14:    .asciiz  "AND -- "
.proc runTest14
  testAXY16
  .repeat 100
  and a:$8000
  .endrepeat
  rts
.endproc

test15:    .asciiz  "BIT XM "
.proc runTest15
  testXM 
  .repeat 100
  bit a:$8000
  .endrepeat
  rts
.endproc

test16:    .asciiz  "BIT -- "
.proc runTest16
  testAXY16
  .repeat 100
  bit a:$8000
  .endrepeat
  rts
.endproc

test17:    .asciiz  "CMP XM "
.proc runTest17
  testXM 
  .repeat 100
  cmp a:$8000
  .endrepeat
  rts
.endproc

test18:    .asciiz  "CMP -- "
.proc runTest18
  testAXY16
  .repeat 100
  cmp a:$8000
  .endrepeat
  rts
.endproc

test19:    .asciiz  "CPX XM "
.proc runTest19
  testXM 
  .repeat 100
  cpx a:$8000
  .endrepeat
  rts
.endproc

test20:    .asciiz  "CPX -- "
.proc runTest20
  testAXY16
  .repeat 100
  cpx a:$8000
  .endrepeat
  rts
.endproc

test21:    .asciiz  "CPY XM "
.proc runTest21
  testXM 
  .repeat 100
  cpy a:$8000
  .endrepeat
  rts
.endproc

test22:    .asciiz  "CPY -- "
.proc runTest22
  testAXY16
  .repeat 100
  cpy a:$8000
  .endrepeat
  rts
.endproc

test23:    .asciiz  "EOR XM "
.proc runTest23
  testXM 
  .repeat 100
  eor a:$8000
  .endrepeat
  rts
.endproc

test24:    .asciiz  "EOR -- "
.proc runTest24
  testAXY16
  .repeat 100
  eor a:$8000
  .endrepeat
  rts
.endproc

test25:    .asciiz  "ORA XM "
.proc runTest25
  testXM 
  .repeat 100
  ora a:$8000
  .endrepeat
  rts
.endproc

test26:    .asciiz  "ORA -- "
.proc runTest26
  testAXY16
  .repeat 100
  ora a:$8000
  .endrepeat
  rts
.endproc

test27:    .asciiz  "ORA -M "
.proc runTest27
  testM
  .repeat 100
  ora a:$8000
  .endrepeat
  rts
.endproc

test28:    .asciiz  "LDA X- "
.proc runTest28
  testX
  .repeat 100
  lda a:$8000
  .endrepeat
  rts
.endproc

test29:    .asciiz  "LDA -M "
.proc runTest29
  testM
  .repeat 100
  lda a:$8000
  .endrepeat
  rts
.endproc

test30:    .asciiz  "LDX X- "
.proc runTest30
  testX
  .repeat 100
  ldx a:$8000
  .endrepeat
  rts
.endproc

test31:    .asciiz  "LDX -M "
.proc runTest31
  testM
  .repeat 100
  ldx a:$8000
  .endrepeat
  rts
.endproc

test32:    .asciiz  "LDY X- "
.proc runTest32
  testX
  .repeat 100
  ldy a:$8000
  .endrepeat
  rts
.endproc

test33:    .asciiz  "LDY -M "
.proc runTest33
  testM
  .repeat 100
  ldy a:$8000
  .endrepeat
  rts
.endproc

test34:    .asciiz  "ADC X- "
.proc runTest34
  testX
  .repeat 100
  adc a:$8000
  .endrepeat
  rts
.endproc

test35:    .asciiz  "ADC -M "
.proc runTest35
  testM
  .repeat 100
  adc a:$8000
  .endrepeat
  rts
.endproc

test36:    .asciiz  "SBC X- "
.proc runTest36
  testX 
  .repeat 100
  sbc a:$8000
  .endrepeat
  rts
.endproc

test37:    .asciiz  "SBC -M "
.proc runTest37
  testM
  .repeat 100
  sbc a:$8000
  .endrepeat
  rts
.endproc

test38:    .asciiz  "AND X- "
.proc runTest38
  testX 
  .repeat 100
  and a:$8000
  .endrepeat
  rts
.endproc

test39:    .asciiz  "AND -M "
.proc runTest39
  testM
  .repeat 100
  and a:$8000
  .endrepeat
  rts
.endproc

test40:    .asciiz  "BIT X- "
.proc runTest40
  testX
  .repeat 100
  bit a:$8000
  .endrepeat
  rts
.endproc

test41:    .asciiz  "BIT -M "
.proc runTest41
  testM
  .repeat 100
  bit a:$8000
  .endrepeat
  rts
.endproc

test42:    .asciiz  "CMP X- "
.proc runTest42
  testX 
  .repeat 100
  cmp a:$8000
  .endrepeat
  rts
.endproc

test43:    .asciiz  "CMP -M "
.proc runTest43
  testM
  .repeat 100
  cmp a:$8000
  .endrepeat
  rts
.endproc

test44:    .asciiz  "CPX X- "
.proc runTest44
  testX
  .repeat 100
  cpx a:$8000
  .endrepeat
  rts
.endproc

test45:    .asciiz  "CPX -M "
.proc runTest45
  testM
  .repeat 100
  cpx a:$8000
  .endrepeat
  rts
.endproc

test46:    .asciiz  "CPY X- "
.proc runTest46
  testX
  .repeat 100
  cpy a:$8000
  .endrepeat
  rts
.endproc

test47:    .asciiz  "CPY -M "
.proc runTest47
  testM
  .repeat 100
  cpy a:$8000
  .endrepeat
  rts
.endproc

test48:    .asciiz  "EOR X- "
.proc runTest48
  testX 
  .repeat 100
  eor a:$8000
  .endrepeat
  rts
.endproc
