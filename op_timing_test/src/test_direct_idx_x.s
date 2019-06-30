.include "snes.inc"
.include "global.inc"
.include "testmacros.inc"
.smart
.export main12

.segment "ZEROPAGE"

dirPtr: .res 3


.segment "CODED"

header:    .asciiz "DIRECT,X TIMING TEST"

; init.s sends us here
.proc main12
  testCount = 48
  
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


test1:    .asciiz  "LDA XM "
.proc runTest1
  testXM
  .repeat 100
  lda dirPtr, x
  .endrepeat
  rts
.endproc

test2:    .asciiz  "LDA -- "
.proc runTest2
  testAXY16
  .repeat 100
  lda dirPtr, x
  .endrepeat
  rts
.endproc

test3:    .asciiz  "AND -M "
.proc runTest3
  testM
  .repeat 100
  and dirPtr, x
  .endrepeat
  rts
.endproc

test4:    .asciiz  "BIT X- "
.proc runTest4
  testX
  .repeat 100
  bit dirPtr, x
  .endrepeat
  rts
.endproc

test5:    .asciiz  "LDY XM "
.proc runTest5
  testXM
  .repeat 100
  ldy dirPtr, x
  .endrepeat
  rts
.endproc

test6:    .asciiz  "LDY -- "
.proc runTest6
  testAXY16
  .repeat 100
  ldy dirPtr, x
  .endrepeat
  rts
.endproc

test7:    .asciiz  "EOR -M "
.proc runTest7
  testM
  .repeat 100
  eor dirPtr, x
  .endrepeat
  rts
.endproc

test8:    .asciiz  "ORA X- "
.proc runTest8
  testX
  .repeat 100
  ora dirPtr, x
  .endrepeat
  rts
.endproc

test9:    .asciiz  "ADC XM "
.proc runTest9
  testXM 
  .repeat 100
  adc dirPtr, x
  .endrepeat
  rts
.endproc

test10:    .asciiz  "ADC -- "
.proc runTest10
  testAXY16
  .repeat 100
  adc dirPtr, x
  .endrepeat
  rts
.endproc

test11:    .asciiz  "SBC XM "
.proc runTest11
  testXM 
  .repeat 100
  sbc dirPtr, x
  .endrepeat
  rts
.endproc

test12:    .asciiz  "SBC -- "
.proc runTest12
  testAXY16
  .repeat 100
  sbc dirPtr, x
  .endrepeat
  rts
.endproc

test13:    .asciiz  "AND XM "
.proc runTest13
  testXM 
  .repeat 100
  and dirPtr, x
  .endrepeat
  rts
.endproc

test14:    .asciiz  "AND -- "
.proc runTest14
  testAXY16
  .repeat 100
  and dirPtr, x
  .endrepeat
  rts
.endproc

test15:    .asciiz  "BIT XM "
.proc runTest15
  testXM 
  .repeat 100
  bit dirPtr, x
  .endrepeat
  rts
.endproc

test16:    .asciiz  "BIT -- "
.proc runTest16
  testAXY16
  .repeat 100
  bit dirPtr, x
  .endrepeat
  rts
.endproc

test17:    .asciiz  "CMP XM "
.proc runTest17
  testXM 
  .repeat 100
  cmp dirPtr, x
  .endrepeat
  rts
.endproc

test18:    .asciiz  "CMP -- "
.proc runTest18
  testAXY16
  .repeat 100
  cmp dirPtr, x
  .endrepeat
  rts
.endproc

test19:    .asciiz  "BIT -M "
.proc runTest19
  testM
  .repeat 100
  bit dirPtr, x
  .endrepeat
  rts
.endproc

test20:    .asciiz  "CMP X- "
.proc runTest20
  testX 
  .repeat 100
  cmp dirPtr, x
  .endrepeat
  rts
.endproc

test21:    .asciiz  "CMP -M "
.proc runTest21
  testM
  .repeat 100
  cmp dirPtr, x
  .endrepeat
  rts
.endproc

test22:    .asciiz  "EOR X- "
.proc runTest22
  testX 
  .repeat 100
  eor dirPtr, x
  .endrepeat
  rts
.endproc

test23:    .asciiz  "EOR XM "
.proc runTest23
  testXM 
  .repeat 100
  eor dirPtr, x
  .endrepeat
  rts
.endproc

test24:    .asciiz  "EOR -- "
.proc runTest24
  testAXY16
  .repeat 100
  eor dirPtr, x
  .endrepeat
  rts
.endproc

test25:    .asciiz  "ORA XM "
.proc runTest25
  testXM 
  .repeat 100
  ora dirPtr, x
  .endrepeat
  rts
.endproc

test26:    .asciiz  "ORA -- "
.proc runTest26
  testAXY16
  .repeat 100
  ora dirPtr, x
  .endrepeat
  rts
.endproc

test27:    .asciiz  "ORA -M "
.proc runTest27
  testM
  .repeat 100
  ora dirPtr, x
  .endrepeat
  rts
.endproc

test28:    .asciiz  "LDA X- "
.proc runTest28
  testX
  .repeat 100
  lda dirPtr, x
  .endrepeat
  rts
.endproc

test29:    .asciiz  "LDA -M "
.proc runTest29
  testM
  .repeat 100
  lda dirPtr, x
  .endrepeat
  rts
.endproc

test30:    .asciiz  "SBC -M "
.proc runTest30
  testM
  .repeat 100
  sbc dirPtr, x
  .endrepeat
  rts
.endproc

test31:    .asciiz  "AND X- "
.proc runTest31
  testX 
  .repeat 100
  and dirPtr, x
  .endrepeat
  rts
.endproc

test32:    .asciiz  "LDY X- "
.proc runTest32
  testX
  .repeat 100
  ldy dirPtr, x
  .endrepeat
  rts
.endproc

test33:    .asciiz  "LDY -M "
.proc runTest33
  testM
  .repeat 100
  ldy dirPtr, x
  .endrepeat
  rts
.endproc

test34:    .asciiz  "ADC X- "
.proc runTest34
  testX
  .repeat 100
  adc dirPtr, x
  .endrepeat
  rts
.endproc

test35:    .asciiz  "ADC -M "
.proc runTest35
  testM
  .repeat 100
  adc dirPtr, x
  .endrepeat
  rts
.endproc

test36:    .asciiz  "SBC X- "
.proc runTest36
  testX 
  .repeat 100
  sbc dirPtr, x
  .endrepeat
  rts
.endproc

test37:    .asciiz  "STA XM "
.proc runTest37
  testXM
  .repeat 100
  sta dirPtr, x
  .endrepeat
  rts
.endproc

test38:    .asciiz  "STA -- "
.proc runTest38
  testAXY16
  .repeat 100
  sta dirPtr, x
  .endrepeat
  rts
.endproc

test39:    .asciiz  "STA X- "
.proc runTest39
  testX
  .repeat 100
  sta dirPtr, x
  .endrepeat
  rts
.endproc

test40:    .asciiz  "STA -M "
.proc runTest40
  testM 
  .repeat 100
  sta dirPtr, x
  .endrepeat
  rts
.endproc

test41:    .asciiz  "STY XM "
.proc runTest41
  testXM
  .repeat 100
  sty dirPtr, x
  .endrepeat
  rts
.endproc

test42:    .asciiz  "STY -- "
.proc runTest42
  testAXY16
  .repeat 100
  sty dirPtr, x
  .endrepeat
  rts
.endproc

test43:    .asciiz  "STY X- "
.proc runTest43
  testX
  .repeat 100
  sty dirPtr, x
  .endrepeat
  rts
.endproc

test44:    .asciiz  "STY -M "
.proc runTest44
  testM 
  .repeat 100
  sty dirPtr, x
  .endrepeat
  rts
.endproc

test45:    .asciiz  "STZ XM "
.proc runTest45
  testXM
  .repeat 100
  stz dirPtr, x
  .endrepeat
  rts
.endproc

test46:    .asciiz  "STZ -- "
.proc runTest46
  testAXY16
  .repeat 100
  stz dirPtr, x
  .endrepeat
  rts
.endproc

test47:    .asciiz  "STZ X- "
.proc runTest47
  testX
  .repeat 100
  stz dirPtr, x
  .endrepeat
  rts
.endproc

test48:    .asciiz  "STZ -M "
.proc runTest48
  testM 
  .repeat 100
  stz dirPtr, x
  .endrepeat
  rts
.endproc

