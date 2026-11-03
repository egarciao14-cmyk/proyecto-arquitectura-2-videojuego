#include "sam3x8e.inc"
.section .text.arduino_entry,"ax",%progbits
.global _Z5setupv
.global _Z4loopv
.type _Z5setupv,%function
.type _Z4loopv,%function

/* Símbolos C++ esperados por el núcleo SAM, implementados en Thumb-2. */
.thumb_func
_Z5setupv:
    push {lr}
    bl gpio_init
    bl adc_init
    bl spi_init
    bl ili9341_init
    bl timer_init
    bl game_init
    pop {pc}

.thumb_func
_Z4loopv:
    b game_loop
