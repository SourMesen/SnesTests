.include "snes.inc"
.include "global.inc"
.include "testmacros.inc"
.smart
.export main26

.segment "ZEROPAGE"

dirPtr: .res 3
spBackup: .res 2


.segment "CODE1B"

header:    .asciiz "STACK RELATIVE TIMING TEST"

; init.s sends us here
.proc main26
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

.macro saveSP
  setaxy16
  tsc
  sta spBackup  
  lda #00
  tcs
.endmacro

.macro loadSP
  setaxy16
  lda spBackup
  tcs
.endmacro

test1:    .asciiz  "LDA XM "
.proc runTest1
  saveSP
  testXM
  .repeat 100
  lda dirPtr,s
  .endrepeat
  loadSP
  rts
.endproc

test2:    .asciiz  "LDA -- "
.proc runTest2
  saveSP
  testAXY16
  .repeat 100
  lda dirPtr,s
  .endrepeat
  loadSP
  rts
.endproc

test3:    .asciiz  "AND -M "
.proc runTest3 
  saveSP
  testM
  .repeat 100
  and dirPtr,s
  .endrepeat
  loadSP
  rts
.endproc

test4:    .asciiz  "CMP X- "
.proc runTest4
  saveSP
  testX 
  .repeat 100
  cmp dirPtr,s
  .endrepeat
  loadSP
  rts
.endproc

test5:    .asciiz  "CMP -M "
.proc runTest5
  saveSP
  testM
  .repeat 100
  cmp dirPtr,s
  .endrepeat
  loadSP
  rts
.endproc

test6:    .asciiz  "EOR X- "
.proc runTest6
  saveSP
  testX 
  .repeat 100
  eor dirPtr,s
  .endrepeat
  loadSP
  rts
.endproc

test7:    .asciiz  "EOR -M "
.proc runTest7
  saveSP
  testM
  .repeat 100
  eor dirPtr,s
  .endrepeat
  loadSP
  rts
.endproc

test8:    .asciiz  "ORA X- "
.proc runTest8
  saveSP
  testX
  .repeat 100
  ora dirPtr,s
  .endrepeat
  loadSP
  rts
.endproc

test9:    .asciiz  "ADC XM "
.proc runTest9
  saveSP
  testXM 
  .repeat 100
  adc dirPtr,s
  .endrepeat
  loadSP
  rts
.endproc

test10:    .asciiz  "ADC -- "
.proc runTest10
  saveSP
  testAXY16
  .repeat 100
  adc dirPtr,s
  .endrepeat
  loadSP
  rts
.endproc

test11:    .asciiz  "SBC XM "
.proc runTest11
  saveSP
  testXM 
  .repeat 100
  sbc dirPtr,s
  .endrepeat
  loadSP
  rts
.endproc

test12:    .asciiz  "SBC -- "
.proc runTest12
  saveSP
  testAXY16
  .repeat 100
  sbc dirPtr,s
  .endrepeat
  loadSP
  rts
.endproc

test13:    .asciiz  "AND XM "
.proc runTest13
  saveSP
  testXM 
  .repeat 100
  and dirPtr,s
  .endrepeat
  loadSP
  rts
.endproc

test14:    .asciiz  "AND -- "
.proc runTest14
  saveSP
  testAXY16
  .repeat 100
  and dirPtr,s
  .endrepeat
  loadSP
  rts
.endproc

test15:    .asciiz  "SBC -M "
.proc runTest15
  saveSP
  testM
  .repeat 100
  sbc dirPtr,s
  .endrepeat
  loadSP
  rts
.endproc

test16:    .asciiz  "AND X- "
.proc runTest16
  saveSP
  testX 
  .repeat 100
  and dirPtr,s
  .endrepeat
  loadSP
  rts
.endproc

test17:    .asciiz  "CMP XM "
.proc runTest17
  saveSP
  testXM 
  .repeat 100
  cmp dirPtr,s
  .endrepeat
  loadSP
  rts
.endproc

test18:    .asciiz  "CMP -- "
.proc runTest18
  saveSP
  testAXY16
  .repeat 100
  cmp dirPtr,s
  .endrepeat
  loadSP
  rts
.endproc

test19:    .asciiz  "LDA -M "
.proc runTest19
  saveSP
  testM
  .repeat 100
  lda dirPtr,s
  .endrepeat
  loadSP
  rts
.endproc

test20:    .asciiz  "ADC X- "
.proc runTest20
  saveSP
  testX
  .repeat 100
  adc dirPtr,s
  .endrepeat
  loadSP
  rts
.endproc

test21:    .asciiz  "ADC -M "
.proc runTest21
  saveSP
  testM
  .repeat 100
  adc dirPtr,s
  .endrepeat
  loadSP
  rts
.endproc

test22:    .asciiz  "SBC X- "
.proc runTest22
  saveSP
  testX 
  .repeat 100
  sbc dirPtr,s
  .endrepeat
  loadSP
  rts
.endproc

test23:    .asciiz  "EOR XM "
.proc runTest23
  saveSP
  testXM 
  .repeat 100
  eor dirPtr,s
  .endrepeat
  loadSP
  rts
.endproc

test24:    .asciiz  "EOR -- "
.proc runTest24
  saveSP
  testAXY16
  .repeat 100
  eor dirPtr,s
  .endrepeat
  loadSP
  rts
.endproc

test25:    .asciiz  "ORA XM "
.proc runTest25
  saveSP
  testXM 
  .repeat 100
  ora dirPtr,s
  .endrepeat
  loadSP
  rts
.endproc

test26:    .asciiz  "ORA -- "
.proc runTest26
  saveSP
  testAXY16
  .repeat 100
  ora dirPtr,s
  .endrepeat
  loadSP
  rts
.endproc

test27:    .asciiz  "ORA -M "
.proc runTest27
  saveSP
  testM
  .repeat 100
  ora dirPtr,s
  .endrepeat
  loadSP
  rts
.endproc

test28:    .asciiz  "LDA X- "
.proc runTest28
  saveSP
  testX
  .repeat 100
  lda dirPtr,s
  .endrepeat
  loadSP
  rts
.endproc

test29:    .asciiz  "STA XM "
.proc runTest29
  saveSP
  testXM
  .repeat 100
  sta dirPtr,s
  .endrepeat
  loadSP
  rts
.endproc

test30:    .asciiz  "STA -- "
.proc runTest30
  saveSP
  testAXY16
  .repeat 100
  sta dirPtr,s
  .endrepeat
  loadSP
  rts
.endproc

test31:    .asciiz  "STA X- "
.proc runTest31
  saveSP
  testX
  .repeat 100
  sta dirPtr,s
  .endrepeat
  loadSP
  rts
.endproc

test32:    .asciiz  "STA -M "
.proc runTest32
  saveSP
  testM 
  .repeat 100
  sta dirPtr,s
  .endrepeat
  loadSP
  rts
.endproc
