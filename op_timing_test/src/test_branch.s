.include "snes.inc"
.include "global.inc"
.include "testmacros.inc"
.smart
.export main10

.segment "ZEROPAGE"

jmpAddr: .res 4

.segment "CODEB"

header:    .asciiz "BRANCH TIMING TEST"

; init.s sends us here
.proc main10
  testCount = 27
  
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


test1:    .asciiz  "BNE Y "
.proc runTest1
  testAXY16
  lda #1
  .repeat 100
  bne :+
:
  .endrepeat  
  rts
.endproc

test2:    .asciiz  "BNE N "
.proc runTest2
  testAXY16
  lda #0
  .repeat 100
  bne :+
:
  .endrepeat  
  rts
.endproc

test3:    .asciiz  "BEQ Y "
.proc runTest3
  testAXY16
  lda #0
  .repeat 100
  beq :+
:
  .endrepeat  
  rts
.endproc

test4:    .asciiz  "BEQ N "
.proc runTest4
  testAXY16
  lda #1
  .repeat 100
  beq :+
:
  .endrepeat  
  rts
.endproc

test5:    .asciiz  "BCC Y "
.proc runTest5
  clc
  .repeat 100
  bcc :+
:
  .endrepeat  
  rts
.endproc

test6:    .asciiz  "BCC N "
.proc runTest6
  sec
  .repeat 100
  bcc :+
:
  .endrepeat  
  rts
.endproc

test7:    .asciiz  "BCS Y "
.proc runTest7
  sec
  .repeat 100
  bcs :+
:
  .endrepeat  
  rts
.endproc

test8:    .asciiz  "BCS N "
.proc runTest8
  clc
  .repeat 100
  bcs :+
:
  .endrepeat  
  rts
.endproc

test9:    .asciiz  "BMI Y "
.proc runTest9
  testM
  lda #$FF
  .repeat 100
  bmi :+
:
  .endrepeat  
  rts
.endproc

test10:    .asciiz  "BMI N "
.proc runTest10
  testM
  lda #$00
  .repeat 100
  bmi :+
:
  .endrepeat  
  rts
.endproc

test11:    .asciiz  "BPL Y "
.proc runTest11
  testM
  lda #$00
  .repeat 100
  bpl :+
:
  .endrepeat  
  rts
.endproc

test12:    .asciiz  "BPL N "
.proc runTest12
  testM
  lda #$FF
  .repeat 100
  bpl :+
:
  .endrepeat  
  rts
.endproc

test13:    .asciiz  "BVC Y "
.proc runTest13
  clv
  .repeat 100
  bvc :+
:
  .endrepeat  
  rts
.endproc

test14:    .asciiz  "BVC N "
.proc runTest14
  SEP #$40
  .repeat 100
  bvc :+
:
  .endrepeat  
  rts
.endproc

test15:    .asciiz  "BVS Y "
.proc runTest15
  SEP #$40
  .repeat 100
  bvs :+
:
  .endrepeat  
  rts
.endproc

test16:    .asciiz  "BVS N "
.proc runTest16
  clv
  .repeat 100
  bvs :+
:
  .endrepeat  
  rts
.endproc

test17:    .asciiz  "BRA   "
.proc runTest17
  .repeat 100
  bra :+
:
  .endrepeat  
  rts
.endproc

test18:    .asciiz  "BRL   "
.proc runTest18
  .repeat 100
  brl :+
:
  .endrepeat  
  rts
.endproc

test19:    .asciiz  "JMP   "
.proc runTest19
  .repeat 100
  jmp :+
:
  .endrepeat  
  rts
.endproc

test20:    .asciiz  "JML   "
.proc runTest20
  .repeat 100
  jml :+
:
  .endrepeat  
  rts
.endproc

test21:    .asciiz  "(JML) "
.proc runTest21
  testAXY16
  
  .repeat 100
  pea :+
  pla
  sta jmpAddr
  phk
  phk
  pla
  sta jmpAddr+2
  jml (jmpAddr)
:
  .endrepeat  
  rts
.endproc

test22:    .asciiz  "(JMP) "
.proc runTest22
  testAXY16
  
  .repeat 100
  pea :+
  pla
  sta jmpAddr
  jmp (jmpAddr)
:
  .endrepeat  
  rts
.endproc

test23:    .asciiz  "(JMP,X) "
.proc runTest23
  testAXY16
  ldx #00
  .repeat 100
  pea :+
  pla
  sta jmpAddr
  jmp (jmpAddr,x)
:
  .endrepeat  
  rts
.endproc

.proc JsrTestTarget
  rts
.endproc

test24:    .asciiz  "JSR/RTS "
.proc runTest24
  .repeat 100
  jsr JsrTestTarget
  .endrepeat  
  rts
.endproc

.proc JslTestTarget
  rtl
.endproc

test25:    .asciiz  "JSL/RTL "
.proc runTest25
  .repeat 100
  jsl JslTestTarget
  .endrepeat  
  rts
.endproc

test26:    .asciiz  "BRK/RTI "
.proc runTest26
  .repeat 100
  brk
  .endrepeat  
  rts
.endproc

test27:    .asciiz  "COP/RTI "
.proc runTest27
  .repeat 100
  brk
  .endrepeat  
  rts
.endproc
