#include "sam3x8e.inc"
.section .text.gpio,"ax",%progbits
.global gpio_init, buttons_read
.thumb_func
gpio_init:
    /* Clocks for PIOA/B/C: peripheral IDs 11,12,13. */
    ldr r0, =PMC_PCER0
    ldr r1, =((1 << 11) | (1 << 12) | (1 << 13))
    str r1, [r0]
    /* SPI pins under peripheral A. */
    ldr r0, =PIOA
    ldr r1, =SPI_PINS
    str r1, [r0, #PIO_PDR]
    ldr r2, [r0, #PIO_ABSR]
    bic r2, r2, r1
    str r2, [r0, #PIO_ABSR]
    /* D2 input with pull-up. */
    ldr r0, =PIOB
    ldr r1, =BTN_Z
    str r1, [r0, #PIO_PER]
    str r1, [r0, #PIO_ODR]
    str r1, [r0, #PIO_PUER]
    /* TFT outputs and D3 input with pull-up. */
    ldr r0, =PIOC
    ldr r1, =(TFT_CS | TFT_DC | TFT_RST | BTN_JUMP)
    str r1, [r0, #PIO_PER]
    ldr r1, =(TFT_CS | TFT_DC | TFT_RST)
    str r1, [r0, #PIO_OER]
    str r1, [r0, #PIO_SODR]
    ldr r1, =BTN_JUMP
    str r1, [r0, #PIO_ODR]
    str r1, [r0, #PIO_PUER]
    bx lr

/* r0 bit0=Z pressed, bit1=jump pressed. */
.thumb_func
buttons_read:
    ldr r1, =PIOB
    ldr r2, [r1, #PIO_PDSR]
    mvn r2, r2
    lsrs r2, r2, #25
    and r2, r2, #1
    ldr r1, =PIOC
    ldr r3, [r1, #PIO_PDSR]
    mvn r3, r3
    lsrs r3, r3, #28
    and r3, r3, #1
    orr r0, r2, r3, lsl #1
    bx lr
