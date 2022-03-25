.import source "constants.asm"

BasicUpstart2(irq_init)

*=$1000

spr0_direction:
.byte 0

irq_init:
    sei
    lda #%01111111 // Disables "Timer A underflow occured" interrupt 
    sta INTERRUPT_CONTROL_REGISTER

    lda RASTER_SPRITE_INTERRUPT_REGISTER
    ora #%00000001 // Set LSB on
    sta RASTER_SPRITE_INTERRUPT_REGISTER // Enable raster interrupt
    
    lda RASTER_LINE_MSB
    and #%01111111 // Trigger IRQ on raster line 0 
    sta RASTER_LINE_MSB
    lda #0
    sta RASTER_LINE

    lda #<irq1 // LSB of address of label
    sta INTERRUPT_LOCATION_LOW
    lda #>irq1 // MSB of address of label
    sta INTERRUPT_LOCATION_HIGH
    cli

start:
    lda #$C8 // 0xC8 => 200 (12800 / 64 = 200)
    sta SPRITE_ZERO_POINTER
    lda #COLOR_YELLOW
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

irq1:
    pha
    txa
    pha
    tya
    pha
    jsr sprite_0_animation
    jmp acknowledge

acknowledge:
    dec INTERRUPT_STATUS_REGISTER // Clear bit zero to acknowledge irq 
    pla
    tya
    pla
    txa
    pla
    jmp KERNAL_STANDARD_INTERRUPT_ROUTINE

sprite_0_animation:
    inc spr0_animation_delay_counter
    lda spr0_animation_delay_counter
    cmp #6
    bne spr0_no_action
    lda #0
    sta spr0_animation_delay_counter
    ldx spr0_frame_counter
    cpx #4
    bne spr0_continue
    ldx #0
    stx spr0_frame_counter

spr0_continue:
    clc
    txa
    adc spr0_direction
    tax
    lda spr0_anim_frames, x
    sta SPRITE_ZERO_POINTER
    inc spr0_frame_counter
    rts

spr0_no_action:
    rts

spr0_anim_frames:
// right (default)
.byte 200,201,202,201 // 200 x 64 = 12800
// left
.byte 203,204,205,204
spr0_frame_counter:
.byte 0
spr0_animation_delay_counter:
.byte 0

*=$3200 // 0x3200 => 12800
sprite_0_1:
.byte $0f,$00,$00,$1f,$80,$00,$3f,$c0
.byte $00,$7b,$e0,$00,$f0,$f0,$00,$fb
.byte $fe,$00,$ff,$ff,$80,$ff,$ff,$e0
.byte $ff,$ff,$f8,$3f,$7f,$fc,$0e,$1f
.byte $ff,$3f,$7f,$fc,$ff,$ff,$f8,$ff
.byte $ff,$e0,$ff,$ff,$80,$fb,$fe,$00
.byte $f0,$f0,$00,$7b,$e0,$00,$3f,$c0
.byte $00,$1f,$80,$00,$0f,$00,$00,$07

// sprite 1 / singlecolor / color: $07
sprite_0_2:
.byte $0f,$00,$00,$1f,$80,$00,$3f,$c0
.byte $00,$7b,$e0,$00,$f0,$f1,$e0,$fb
.byte $fb,$fc,$ff,$ff,$fe,$ff,$ff,$fc
.byte $ff,$ff,$e0,$3f,$7f,$00,$0e,$18
.byte $00,$3f,$7f,$00,$ff,$ff,$e0,$ff
.byte $ff,$fc,$ff,$ff,$fe,$fb,$fb,$fc
.byte $f0,$f1,$e0,$7b,$e0,$00,$3f,$c0
.byte $00,$1f,$80,$00,$0f,$00,$00,$07

// sprite 2 / singlecolor / color: $07
sprite_0_3:
.byte $0f,$00,$00,$1f,$80,$70,$3f,$c0
.byte $f8,$7b,$e1,$f0,$f0,$f3,$e0,$fb
.byte $ff,$c0,$ff,$ff,$80,$ff,$ff,$00
.byte $ff,$fe,$00,$3f,$7c,$00,$0e,$18
.byte $00,$3f,$7c,$00,$ff,$fe,$00,$ff
.byte $ff,$00,$ff,$ff,$80,$fb,$ff,$c0
.byte $f0,$f3,$e0,$7b,$e1,$f0,$3f,$c0
.byte $f8,$1f,$80,$70,$0f,$00,$00,$07

// sprite 3 / singlecolor / color: $07
sprite_1_1:
.byte $00,$00,$f0,$00,$01,$f8,$00,$03
.byte $fc,$00,$07,$de,$00,$0f,$0f,$00
.byte $7f,$df,$01,$ff,$ff,$07,$ff,$ff
.byte $1f,$ff,$ff,$3f,$fe,$fc,$ff,$f8
.byte $70,$3f,$fe,$fc,$1f,$ff,$ff,$07
.byte $ff,$ff,$01,$ff,$ff,$00,$7f,$df
.byte $00,$0f,$0f,$00,$07,$de,$00,$03
.byte $fc,$00,$01,$f8,$00,$00,$f0,$07

// sprite 4 / singlecolor / color: $07
sprite_1_2:
.byte $00,$00,$f0,$00,$01,$f8,$00,$03
.byte $fc,$00,$07,$de,$07,$8f,$0f,$3f
.byte $df,$df,$7f,$ff,$ff,$3f,$ff,$ff
.byte $07,$ff,$ff,$00,$fe,$fc,$00,$18
.byte $70,$00,$fe,$fc,$07,$ff,$ff,$3f
.byte $ff,$ff,$7f,$ff,$ff,$3f,$df,$df
.byte $07,$8f,$0f,$00,$07,$de,$00,$03
.byte $fc,$00,$01,$f8,$00,$00,$f0,$07

// sprite 5 / singlecolor / color: $07
sprite_1_3:
.byte $00,$00,$f0,$0e,$01,$f8,$1f,$03
.byte $fc,$0f,$87,$de,$07,$cf,$0f,$03
.byte $ff,$df,$01,$ff,$ff,$00,$ff,$ff
.byte $00,$7f,$ff,$00,$3e,$fc,$00,$18
.byte $70,$00,$3e,$fc,$00,$7f,$ff,$00
.byte $ff,$ff,$01,$ff,$ff,$03,$ff,$df
.byte $07,$cf,$0f,$0f,$87,$de,$1f,$03
.byte $fc,$0e,$01,$f8,$00,$00,$f0,$07