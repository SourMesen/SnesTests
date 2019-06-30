; main.s
.global main, main1, main2, main3, main4, main5, main6, main7, main8, main9, main10, main11, main12, main13, main14, main15, main16, main17, main18, main19, main20, main21, main22, main23, main24, main25, main26, main27
.globalzp oam_used

; ppuclear.s
.global ppu_copy_oam, ppu_pack_oamhi, ppu_clear_oam
.global ppu_copy, ppu_clear_nt, ppu_vsync, ppu_start_frame
.global OAM, OAMHI

.global writeNumber, storeTime, finishTest, initTest, beforeDisplayResult

; bg.s
.global load_bg_tiles, draw_bg

; player.s
.global load_player_tiles, move_player, draw_player_sprite
.globalzp player_xlo, player_xhi, player_dxlo, player_yhi
.globalzp player_frame_sub, player_frame, player_facing

; blarggapu.s
.global spc_boot_apu

.segment "BSS"
.global hPos, vPos, testResult
.global OAM, OAMHI