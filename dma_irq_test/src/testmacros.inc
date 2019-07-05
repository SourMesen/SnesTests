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
	displayMessage label, 18, testNumber + 4 - 25
  .else
    displayMessage label, 2, testNumber + 4
  .endif  
  setaxy16
  ldx testResults+testNumber*2
  jsl writeNumber
.endscope
.endmacro

.macro runTest procName, number
  jsl ppu_start_frame
  setaxy16  
  jsl procName

  setaxy8
  lda valueOnIrq
  ldx #(number*2)
  sta testResults, x
  inx
  stz testResults, x  
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

.macro setWorkRamAddress bank, addr
  seta16
  lda #addr
  sta $2181
  seta8
  lda #bank  
  sta $2183
.endmacro

.macro runDma mode, addr, length, dest, channels
  setxy8
  ldx #mode
  stx DMAMODE
  ldx #dest
  stx DMAPPUREG
  setxy16
  ldx #addr
  stx DMAADDR
  ldx #length
  stx DMALEN
  stx DMAADDRBANK
  setxy8
  ldx #channels
  stx COPYSTART
.endmacro

;Same as runDma8, but writes to $420B with the M flag off (so it writes to 402B and then 402C)
.macro runDma16 mode, addr, length, dest, channels
  setxy8
  ldx #mode
  stx DMAMODE
  ldx #dest
  stx DMAPPUREG
  setxy16
  ldx #addr
  stx DMAADDR
  ldx #length

  stx DMALEN
  stx DMAADDRBANK
  setxy16
  ldx #channels
  stx COPYSTART
.endmacro