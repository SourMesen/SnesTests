.include "snes.inc"
.include "global.inc"
.include "testmacros.inc"
.smart
.export main23

.segment "ZEROPAGE"



.segment "CODE18"

header:    .asciiz "IMPLIED TIMING TEST"

; init.s sends us here
.proc main23
  testCount = 38
  
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


test1:    .asciiz  "CLC    "
.proc runTest1
  .repeat 100
  clc
  .endrepeat
  rts
.endproc

test2:    .asciiz  "CLD    "
.proc runTest2
  .repeat 100
  cld
  .endrepeat
  rts
.endproc

test3:    .asciiz  "CLI    "
.proc runTest3
  .repeat 100
  cli
  .endrepeat
  rts
.endproc

test4:    .asciiz  "CLV    "
.proc runTest4
  .repeat 100
  clv
  .endrepeat
  rts
.endproc

test5:    .asciiz  "DEX XM "
.proc runTest5
  testXM
  .repeat 100
  ldy #0
  .endrepeat
  rts
.endproc

test6:    .asciiz  "DEX -- "
.proc runTest6
  testAXY16
  .repeat 100
  dex
  .endrepeat
  rts
.endproc

test7:    .asciiz  "DEX X- "
.proc runTest7
  testX
  .repeat 100
  dex
  .endrepeat
  rts
.endproc

test8:    .asciiz  "DEX -M "
.proc runTest8
  testM
  .repeat 100
  dex
  .endrepeat
  rts
.endproc

test9:    .asciiz  "DEY XM "
.proc runTest9
  testXM 
  .repeat 100
  dey
  .endrepeat
  rts
.endproc

test10:    .asciiz  "DEY -- "
.proc runTest10
  testAXY16
  .repeat 100
  dey
  .endrepeat
  rts
.endproc

test11:    .asciiz  "DEY X- "
.proc runTest11
  testX 
  .repeat 100
  dey
  .endrepeat
  rts
.endproc

test12:    .asciiz  "DEY -M "
.proc runTest12
  testM
  .repeat 100
  dey
  .endrepeat
  rts
.endproc

test13:    .asciiz  "INX XM "
.proc runTest13
  testXM 
  .repeat 100
  inx
  .endrepeat
  rts
.endproc

test14:    .asciiz  "INX -- "
.proc runTest14
  testAXY16
  .repeat 100
  inx
  .endrepeat
  rts
.endproc

test15:    .asciiz  "INX X- "
.proc runTest15
  testX
  .repeat 100
  inx
  .endrepeat
  rts
.endproc

test16:    .asciiz  "INX -M "
.proc runTest16
  testM
  .repeat 100
  inx
  .endrepeat
  rts
.endproc

test17:    .asciiz  "INY XM "
.proc runTest17
  testXM 
  .repeat 100
  iny
  .endrepeat
  rts
.endproc

test18:    .asciiz  "INY -- "
.proc runTest18
  testAXY16
  .repeat 100
  iny
  .endrepeat
  rts
.endproc

test19:    .asciiz  "INY X- "
.proc runTest19
  testXM
  .repeat 100
  iny
  .endrepeat
  rts
.endproc

test20:    .asciiz  "INY -M "
.proc runTest20
  testM
  .repeat 100
  iny
  .endrepeat
  rts
.endproc

test21:    .asciiz  "NOP    "
.proc runTest21
  .repeat 100
  nop
  .endrepeat
  rts
.endproc

test22:    .asciiz  "SEC    "
.proc runTest22
  .repeat 100
  sec
  .endrepeat
  rts
.endproc

test23:    .asciiz  "SED    "
.proc runTest23
  .repeat 100
  sed
  .endrepeat
  cld
  rts
.endproc

test24:    .asciiz  "SEI    "
.proc runTest24
  .repeat 100
  sei
  .endrepeat
  rts
.endproc

test25:    .asciiz  "TAX    "
.proc runTest25
  .repeat 100
  tax
  .endrepeat
  rts
.endproc

test26:    .asciiz  "TAY    "
.proc runTest26
  .repeat 100
  tay
  .endrepeat
  rts
.endproc

test27:    .asciiz  "TCD    "
.proc runTest27
  phd
  .repeat 100
  tcd
  .endrepeat
  pld
  rts
.endproc

test28:    .asciiz  "TCS    "
.proc runTest28
  testAXY16
  tsx
  .repeat 100
  tcs
  .endrepeat
  txs
  rts
.endproc

test29:    .asciiz  "TDC    "
.proc runTest29
  .repeat 100
  tdc
  .endrepeat
  rts
.endproc

test30:    .asciiz  "TSC    "
.proc runTest30
  .repeat 100
  tsc
  .endrepeat
  rts
.endproc

test31:    .asciiz  "TSX    "
.proc runTest31
  .repeat 100
  tsx
  .endrepeat
  rts
.endproc

test32:    .asciiz  "TXA    "
.proc runTest32
  .repeat 100
  txa
  .endrepeat
  rts
.endproc

test33:    .asciiz  "TXS    "
.proc runTest33
  testAXY16
  tsc
  .repeat 100
  txs
  .endrepeat
  tcs
  rts
.endproc

test34:    .asciiz  "TXY    "
.proc runTest34
  .repeat 100
  txy
  .endrepeat
  rts
.endproc

test35:    .asciiz  "TYA    "
.proc runTest35
  .repeat 100
  tya
  .endrepeat
  rts
.endproc

test36:    .asciiz  "TYX    "
.proc runTest36
  .repeat 100
  tyx
  .endrepeat
  rts
.endproc

test37:    .asciiz  "XCE    "
.proc runTest37
  clc
  .repeat 100
  xce
  .endrepeat
  rts
.endproc

test38:    .asciiz  "XBA    "
.proc runTest38
  .repeat 100
  xba
  .endrepeat
  rts
.endproc
