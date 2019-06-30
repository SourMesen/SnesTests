.include "snes.inc"
.include "global.inc"
.include "testmacros.inc"
.smart
.export main


.segment "CODE1"

; init.s sends us here
.proc main

  .repeat 27, I
  .scope  
  funcName = .ident(.sprintf("main%s", .string(I+1)))
  jsl funcName
  .endscope
  .endrepeat
  
  ;Turn on fast rom
  lda #$01
  sta MEMSEL  
  
  .repeat 27, I
  .scope  
  funcName = .ident(.sprintf("main%s", .string(I+1)))
  jsl funcName
  .endscope
  .endrepeat
  
forever:
  jmp forever
  
.endproc
