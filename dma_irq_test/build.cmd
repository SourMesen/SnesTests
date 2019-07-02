cc65\ca65 -g src\bg.s
cc65\ca65 -g src\init.s
cc65\ca65 -g src\main.s
cc65\ca65 -g src\player.s
cc65\ca65 -g src\ppuclear.s
cc65\ca65 -g src\snesheader.s
cc65\ca65 -g src\global.inc
cc65\ca65 -g src\snes.inc
cc65\ca65 -g src\testhelper.s

cc65\ld65 -m map.txt -C lorom256k.cfg --dbgfile dma_irq_test.dbg src\global.o src\snes.o src\bg.o src\init.o src\main.o src\player.o src\ppuclear.o src\snesheader.o src\testhelper.o -o dma_irq_test.sfc