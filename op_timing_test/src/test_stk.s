.include "snes.inc"
.include "global.inc"
.include "testmacros.inc"
.smart
.export main25

.segment "ZEROPAGE"



.segment "CODE1A"

header:    .asciiz "STACK TIMING TEST"

; init.s sends us here
.proc main25
  testCount = 28
  
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


test1:    .asciiz  "PHA/PLA XM "
.proc runTest1
  testXM  
  .repeat 100
  pha
  pla
  .endrepeat  
  rts
.endproc

test2:    .asciiz  "PHA/PLA -- "
.proc runTest2
  testAXY16  
  .repeat 100
  pha
  pla
  .endrepeat  
  rts
.endproc

test3:    .asciiz  "PHA/PLA X- "
.proc runTest3
  testX  
  .repeat 100
  pha
  pla
  .endrepeat  
  rts
.endproc

test4:    .asciiz  "PHA/PLA -M "
.proc runTest4
  testM
  .repeat 100
  pha
  pla
  .endrepeat  
  rts
.endproc

test5:    .asciiz  "PHB/PLB XM "
.proc runTest5
  testXM  
  .repeat 100
  phb
  plb
  .endrepeat  
  rts
.endproc

test6:    .asciiz  "PHB/PLB -- "
.proc runTest6
  testAXY16  
  .repeat 100
  phb
  plb
  .endrepeat  
  rts
.endproc

test7:    .asciiz  "PHB/PLB X- "
.proc runTest7
  testX  
  .repeat 100
  phb
  plb
  .endrepeat  
  rts
.endproc

test8:    .asciiz  "PHB/PLB -M "
.proc runTest8
  testM
  .repeat 100
  phb
  plb
  .endrepeat  
  rts
.endproc

test9:    .asciiz  "PHP/PLP XM "
.proc runTest9
  testXM  
  .repeat 100
  php
  plp
  .endrepeat  
  rts
.endproc

test10:    .asciiz  "PHP/PLP -- "
.proc runTest10
  testAXY16  
  .repeat 100
  php
  plp
  .endrepeat  
  rts
.endproc

test11:    .asciiz  "PHP/PLP X- "
.proc runTest11
  testX  
  .repeat 100
  php
  plp
  .endrepeat  
  rts
.endproc

test12:    .asciiz  "PHP/PLP -M "
.proc runTest12
  testM
  .repeat 100
  php
  plp
  .endrepeat  
  rts
.endproc

test13:    .asciiz  "PHD/PLD XM "
.proc runTest13
  testXM  
  .repeat 100
  PHD
  PLD
  .endrepeat  
  rts
.endproc

test14:    .asciiz  "PHD/PLD -- "
.proc runTest14
  testAXY16  
  .repeat 100
  PHD
  PLD
  .endrepeat  
  rts
.endproc

test15:    .asciiz  "PHD/PLD X- "
.proc runTest15
  testX  
  .repeat 100
  PHD
  PLD
  .endrepeat  
  rts
.endproc

test16:    .asciiz  "PHD/PLD -M "
.proc runTest16
  testM
  .repeat 100
  PHD
  PLD
  .endrepeat  
  rts
.endproc

test17:    .asciiz  "PHX/PLX XM "
.proc runTest17
  testXM  
  .repeat 100
  PHX
  PLX
  .endrepeat  
  rts
.endproc

test18:    .asciiz  "PHX/PLX -- "
.proc runTest18
  testAXY16  
  .repeat 100
  PHX
  PLX
  .endrepeat  
  rts
.endproc

test19:    .asciiz  "PHX/PLX X- "
.proc runTest19
  testX  
  .repeat 100
  PHX
  PLX
  .endrepeat  
  rts
.endproc

test20:    .asciiz  "PHX/PLX -M "
.proc runTest20
  testM
  .repeat 100
  PHX
  PLX
  .endrepeat  
  rts
.endproc

test21:    .asciiz  "PHY/PLY XM "
.proc runTest21
  testXM  
  .repeat 100
  PHY
  PLY
  .endrepeat  
  rts
.endproc

test22:    .asciiz  "PHY/PLY -- "
.proc runTest22
  testAXY16  
  .repeat 100
  PHY
  PLY
  .endrepeat  
  rts
.endproc

test23:    .asciiz  "PHY/PLY X- "
.proc runTest23
  testX  
  .repeat 100
  PHY
  PLY
  .endrepeat  
  rts
.endproc

test24:    .asciiz  "PHY/PLY -M "
.proc runTest24
  testM
  .repeat 100
  PHY
  PLY
  .endrepeat  
  rts
.endproc

test25:    .asciiz  "PHK        "
.proc runTest25
  testM
  .repeat 100
  phk
  pla
  .endrepeat
  rts
.endproc

test26:    .asciiz  "PEA -- "
.proc runTest26
  testAXY16
  .repeat 100
  pea $0000
  pla
  .endrepeat
  rts
.endproc

test27:    .asciiz  "PEI XM "
.proc runTest27
  testAXY16
  .repeat 100
  pei ($00)
  pla
  .endrepeat
  rts
.endproc

test28:    .asciiz  "PER XM "
.proc runTest28
  testAXY16
  .repeat 100
  per test28
  pla
  .endrepeat
  rts
.endproc
