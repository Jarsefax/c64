// Commodore 64 Memory Map: https://sta.c64.org/cbm64mem.html
// Sprite editor: https://www.spritemate.com
// Music collection: https://www.hvsc.c64.org

/*
 * Sprites
 */
.const SPRITE_ZERO_POINTER = $07F8
.const SPRITE_ZERO_COLOR = $D027
.const SPRITE_ZERO_X = $D000
.const SPRITE_ZERO_Y = $D001

.const SPRITES_ENABLE = $D015

/*
 * Colors
 */
.const BORDER_COLOR = $D020
.const SCREEN_COLOR = $D021

.const COLOR_BLACK = $0
.const COLOR_WHITE = $1
.const COLOR_RED = $2
.const COLOR_CYAN = $3
.const COLOR_PURPLE  = $4
.const COLOR_GREEN = $5
.const COLOR_BLUE = $6
.const COLOR_YELLOW = $7
.const COLOR_ORANGE = $8
.const COLOR_BROWN = $9
.const COLOR_LIGHT_RED = $A
.const COLOR_DARK_GREY = $B
.const COLOR_GREY = $C
.const COLOR_LIGHT_GREEN = $E
.const COLOR_LIGHT_BLUE = $E
.const COLOR_LIGHT_GREY = $F

/*
 * Interrupts (IRQ)
  */
.const INTERRUPT_CONTROL_REGISTER = $DC0D
.const INTERRUPT_STATUS_REGISTER = $D019
.const RASTER_SPRITE_INTERRUPT_REGISTER = $D01A
.const RASTER_LINE_MSB = $D011
.const RASTER_LINE = $D012
.const INTERRUPT_LOCATION_LOW = $0314
.const INTERRUPT_LOCATION_HIGH = $0315

/*
 * Kernal routines
 */
.const KERNAL_CLEAR_SCREEN_ROUTINE = $E544
.const KERNAL_STANDARD_INTERRUPT_ROUTINE = $EA31