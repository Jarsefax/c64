.import source "constants.asm"

BasicUpstart2(start)

*=$1000

start:
    lda #$C8 // 0xC8 => 200 (12800 / 64 = 200)
    sta SPRITE_ZERO_POINTER
    lda #COLOR_BLACK
    sta SPRITE_ZERO_COLOR
    lda #$2C
    sta SPRITE_ZERO_X
    lda #$78
    sta SPRITE_ZERO_Y
    lda #1
    sta SPRITES_ENABLE
    lda #COLOR_BLUE
    sta BORDER_COLOR
    sta SCREEN_COLOR
    jsr KERNAL_CLEAR_SCREEN_ROUTINE
    rts

*=$3200 // 0x3200 => 12800
sprite_0:
.byte $00,$00,$03,$00,$00,$27,$00,$00
.byte $3e,$00,$01,$fc,$00,$03,$f8,$00
.byte $07,$fc,$70,$cf,$fe,$ff,$ff,$ff
.byte $bf,$ff,$cf,$bf,$ff,$c6,$bf,$ff
.byte $c0,$9f,$ff,$c0,$9f,$ff,$e0,$9f
.byte $ff,$f0,$3f,$ff,$d8,$3c,$fc,$cc
.byte $76,$00,$e6,$66,$00,$63,$67,$00
.byte $61,$63,$80,$30,$c1,$80,$18,$04