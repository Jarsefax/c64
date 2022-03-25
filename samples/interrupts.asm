.import source "constants.asm"

.const music = LoadSid("Always.sid")

BasicUpstart2(irq_init)

*=3000 "asm"
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

    _start:
        lda #music.startSong-1
        jsr music.init

    rts

irq1:
    pha
    txa
    pha
    tya
    pha
    jsr music.play
    lda #COLOR_GREEN
    sta BORDER_COLOR
    lda #$95 // 0x95 => 150
    sta RASTER_LINE
    lda #<irq2
    sta INTERRUPT_LOCATION_LOW
    lda #>irq2
    sta INTERRUPT_LOCATION_HIGH
    jmp acknowledge

irq2:
    pha
    txa
    pha
    tya
    pha
    lda #COLOR_YELLOW
    sta BORDER_COLOR
    lda #0
    sta RASTER_LINE
    lda #<irq1
    sta INTERRUPT_LOCATION_LOW
    lda #>irq1
    sta INTERRUPT_LOCATION_HIGH
    jmp acknowledge

acknowledge:
    dec INTERRUPT_STATUS_REGISTER // Clear bit zero to acknowledge irq 
    pla
    tya
    pla
    txa
    pla
    jmp KERNAL_STANDARD_INTERRUPT_ROUTINE

*=music.location "Music"
.fill music.size, music.getData(i)