cc65\ca65 -g src\bg.s
cc65\ca65 -g src\blarggapu.s
cc65\ca65 -g src\init.s
cc65\ca65 -g src\main.s
cc65\ca65 -g src\player.s
cc65\ca65 -g src\ppuclear.s
cc65\ca65 -g src\snesheader.s
cc65\ca65 -g src\global.inc
cc65\ca65 -g src\snes.inc
cc65\ca65 -g src\spcimage.s

cc65\ld65 -m map.txt -C lorom256k.cfg --dbgfile timing_test.dbg src\global.o src\snes.o src\bg.o src\blarggapu.o src\init.o src\main.o src\player.o src\ppuclear.o src\snesheader.o src\spcimage.o -o timing_test.sfc