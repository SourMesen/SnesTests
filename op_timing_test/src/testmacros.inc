.macro storeCounters offset
.scope
  php
  seta8
  lda $2137
  lda $213D
  sta vPos+offset*2
  lda $213D
  and #$01
  sta vPos+offset*2+1  

  lda $213C
  sta hPos+offset*2
  lda $213C
  and #$01
  sta hPos+offset*2+1  
  plp
.endscope
.endmacro

.macro displayTimer testNumber
.scope
  php
  setxy16
  ldx testResult+testNumber*2
  jsl writeNumber
  plp
.endscope
.endmacro

.macro displayMessage msg, xPos, yPos
.scope
  phb
  phk
  plb
  php
  setxy16
  ldx #$6000 | NTXY(xPos, yPos)
  stx $2116

  seta8
  ldx #$00
nextchar:  
  lda msg,x
  cmp #$00
  beq endofstring
  sta $2118
  stz $2119
  inx
  bra nextchar
endofstring:
  plp
  plb
.endscope
.endmacro

.macro displayResult testNumber
.scope
  label = .ident(.sprintf("test%s", .string(testNumber)))
  .if testNumber > 25
	displayMessage label, 18, testNumber + 1 - 25
  .else
    displayMessage label, 2, testNumber + 1
  .endif  
  displayTimer testNumber
.endscope
.endmacro

.macro runTest procName, number
  jsl ppu_start_frame
  storeCounters 0
  setaxy16  
  ldx #0
  ldy #0
  lda #0
  jsr procName
  storeCounters 1
  
  setaxy16  
  ldx #number*2
  jsl storeTime
.endmacro

.macro testXM
  setaxy8
.endmacro 

.macro testM
  seta8
  setxy16
.endmacro 

.macro testX
  setxy8
  seta16
.endmacro 

.macro testAXY16
  setaxy16
.endmacro 