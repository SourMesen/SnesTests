.setcpu "none"
.include "spc-65c02.inc"

.macro stya addr
.local addr1
addr1 = addr
  movw addr, ya
.endmacro

TIMEREN     = $F1  ; 0-2: enable timer; 7: enable ROM in $FFC0-$FFFF
DSPADDR     = $F2
DSPDATA     = $F3
TIMERPERIOD = $FA  ; Divisors for timers (0, 1: 8 kHz base; 2: 64 kHz base)
TIMERVAL    = $FD  ; Number of times timer incremented (bits 3-0; cleared on read)

DSP_CLVOL    = $00
DSP_CRVOL    = $01
DSP_CFREQLO  = $02  ; Playback frequency in 7.8125 Hz units
DSP_CFREQHI  = $03  ; (ignored 
DSP_CSAMPNUM = $04  
DSP_CATTACK  = $05  ; 7: set; 6-4: decay rate; 3-0: attack rate
DSP_CSUSTAIN = $06  ; 7-5: sustain level; 4-0: sustain decay rate
DSP_CGAIN    = $07  ; Used only when attack is disabled

DSP_LVOL     = $0C
DSP_RVOL     = $1C
DSP_LECHOVOL = $2C
DSP_RECHOVOL = $3C
DSP_KEYON    = $4C
DSP_KEYOFF   = $5C
DSP_FLAGS    = $6C  ; 5: disable echo; 4-0: set LFSR rate
DSP_NOISECH  = $3D  ; Replace these channels with LFSR noise
DSP_ECHOCH   = $4D  ; Echo comes from these channels
DSP_SAMPDIR  = $5D  ; High byte of base address of sample table

.export sample_dir, spc_entry

.segment "RODATA"

.segment "SPCIMAGE"
.align 256
sample_dir:
  ; each directory entry is 4 bytes:
  ; a start address then a loop address
  .addr pulse_2, pulse_2
  .addr pulse_8, pulse_8
  .addr testsample, testsample

pulse_2:
    .byte $B0,$9C,$CC,$CC,$CC,$CC,$CC,$CC,$C9
    .byte $B3,$74,$44,$44,$44,$44,$44,$44,$47
pulse_8:
    .byte $B0,$9C,$C9,$74,$44,$44,$44,$44,$44
    .byte $B3,$44,$44,$44,$44,$44,$44,$44,$47
testsample:
    .incbin "obj/snes/selnow.brr"

  nop  ; resync debugger's disassembly
spc_entry:
  ldy #$7F
  lda #DSP_LVOL  ; master volume left
  stya DSPADDR
  lda #DSP_RVOL  ; master volume right
  stya DSPADDR
  ; Disable the APU features we're not using
  ldy #%00100000  ; mute off, echo write off, LFSR noise stop
  lda #DSP_FLAGS
  stya DSPADDR
  ldy #$00
  lda #DSP_KEYON  ; Clear key on
  stya DSPADDR
  dey
  lda #DSP_KEYOFF  ; Key off everything
  stya DSPADDR
  iny
  lda #DSP_NOISECH  ; LFSR noise on no channels
  stya DSPADDR
  lda #DSP_ECHOCH  ; Echo on no channels
  stya DSPADDR
  lda #DSP_LECHOVOL  ; Left echo volume = 0
  stya DSPADDR
  lda #DSP_RECHOVOL  ; Right echo volume = 0
  stya DSPADDR
  
  
  ; The DSP acts on KON and KOFF only once every two samples (1/16000
  ; seconds or 64 cycles).  A key on or key off request must remain
  ; set for at least 64 cycles, but key off must be cleared before
  ; key on can be set again.  If key on is set while key off is set,
  ; it'll immediately cut the note and possibly cause a pop.
konwait1:
  dey
  bne konwait1
  lda #DSP_KEYOFF  ; Now clear key off request (must not happen within
  stya DSPADDR
  
  lda #DSP_SAMPDIR  ; set sample directory start address
  ldy #>sample_dir
  stya DSPADDR

  ; Set up instrument in channel 0
  lda #DSP_CLVOL|$00
  ldy #127
  stya DSPADDR
  lda #DSP_CRVOL|$00
  ldy #31
  stya DSPADDR
  lda #DSP_CFREQLO|$00
  ldy #$00
  stya DSPADDR
  lda #DSP_CFREQHI|$00
  ldy #$08
  stya DSPADDR
  lda #DSP_CSAMPNUM|$00
  ldy #$01
  stya DSPADDR
  lda #DSP_CATTACK|$00
  ldy #$AD
  stya DSPADDR
  lda #DSP_CSUSTAIN|$00
  ldy #$4F
  stya DSPADDR

  lda #DSP_CLVOL|$10
  ldy #31
  stya DSPADDR
  lda #DSP_CRVOL|$10
  ldy #127
  stya DSPADDR
  lda #DSP_CFREQLO|$10
  ldy #$33
  stya DSPADDR
  lda #DSP_CFREQHI|$10
  ldy #$03
  stya DSPADDR
  lda #DSP_CSAMPNUM|$10
  ldy #$00
  stya DSPADDR
  lda #DSP_CATTACK|$10
  ldy #$AD
  stya DSPADDR
  lda #DSP_CSUSTAIN|$10
  ldy #$4F
  stya DSPADDR

  lda #160  ; 8000 Hz base / 160 = 50 Hz
  sta TIMERPERIOD
  lda #%10000001
  sta TIMEREN
  lda TIMERVAL

  ; play the chord
  lda #DSP_KEYON
  ldy #%00000010  ; channels 1 and 0
  stya DSPADDR

  ldx #5
:
  lda TIMERVAL
  beq :-
  dex
  bne :-
  lda #DSP_KEYON
  ldy #%00000001  ; channels 1 and 0
  stya DSPADDR

  ; make your selection now
  lda #DSP_CLVOL|$20
  ldy #127
  stya DSPADDR
  lda #DSP_CRVOL|$20
  ldy #127
  stya DSPADDR
  lda #DSP_CFREQLO|$20
  ldy #$00
  stya DSPADDR
  lda #DSP_CFREQHI|$20
  ldy #$08
  stya DSPADDR
  lda #DSP_CSAMPNUM|$20
  ldy #$02
  stya DSPADDR
  lda #DSP_CATTACK|$20
  ldy #$00
  stya DSPADDR
  lda #DSP_CGAIN|$20
  ldy #$4F
  stya DSPADDR

  ldx #45  ; 5 + 45 = 1 second
:
  lda TIMERVAL
  beq :-
  dex
  bne :-
  lda #DSP_KEYON
  ldy #%00000100  ; channels 1 and 0
  stya DSPADDR

forever:
  jmp forever
  

