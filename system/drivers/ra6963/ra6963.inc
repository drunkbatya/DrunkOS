; info
RA6963_DISPLAY_WIDTH = 240
RA6963_DISPLAY_HEIGHT = 64
RA6963_DISPLAY_WIDTH_BYTES = 240 / 8

; main
RA6963_SET_TEXT_HOME_ADDRESS = 0x40
RA6963_SET_TEXT_AREA = 0x41
RA6963_SET_GRAPHIC_HOME_ADDRESS = 0x42
RA6963_SET_GRAPHIC_AREA = 0x43
RA6963_SET_ADDRESS_POINTER = 0x24
RA6963_GRAPHIC_RAM_START_ADDR = 0x0000
RA6963_SET_BIT = 0xF8

; cursor
RA6963_SET_1_LINE_CURSOR = 0xA0
RA6963_SET_CURSOR_POSITION = 0x21

; modes
RA6963_SET_OR_MODE = 0x80
RA6963_SET_EXOR_MODE = 0x81
RA6963_SET_AND_MODE = 0x83

; display modes
RA6963_SET_DISPLAY_OFF = 0x90
RA6963_SET_CURSOR_ON_BLINK_OFF = 0x92
RA6963_SET_CURSOR_ON_BLINK_ON = 0x93
RA6963_SET_TEXT_ON_GRAPHIC_OFF = 0x94
RA6963_SET_TEXT_OFF_GRAPHIC_ON = 0x98
RA6963_SET_TEXT_ON_GRAPHIC_ON = 0x9C
RA6963_SET_TEXT_ON_GRAPHIC_OFF_CURSOR_ON_BLINK_ON = 0x97
RA6963_SET_TEXT_OFF_GRAPHIC_ON_CURSOR_ON_BLINK_ON = 0x9B

; read/write
RA6963_SET_AUTO_WRITE = 0xB0
RA6963_RESET_AUTO_WRITE = 0xB2
RA6963_DATA_WRITE_AND_INC_ADDR = 0xC0
RA6963_DATA_READ_AND_INC_ADDR = 0xC1
RA6963_DATA_WRITE = 0xC4
RA6963_DATA_READ = 0xC5

; font
RA6963_FONT_OFFSET = 32

; functions
.global ra6963_init
.global ra6963_await_cmd_or_data
.global ra6963_await_data_auto_mode_read
.global ra6963_await_data_auto_mode_write
.global ra6963_clear
.global ra6963_set_auto_write
.global ra6963_reset_auto_write
.global ra6963_set_address_pointer
.global ra6963_set_pixel
.global ra6963_modify_byte
.global ra6963_draw_xbm
.global ra6963_set_graphic_home_address
.global ra6963_set_text_home_address
.global ra6963_add_to_zero_offset
.global ra6963_apply_zero_offset
.global ra6963_memset
.global ra6963_set_cursor_pointer

; variables
.global ra6963_zero_offset

; vim: set ft=asm:
