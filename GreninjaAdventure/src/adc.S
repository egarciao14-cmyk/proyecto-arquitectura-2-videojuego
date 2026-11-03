#include "sam3x8e.inc"
.section .text.adc,"ax",%progbits
.global adc_init, adc_read_xy
.thumb_func
adc_init:
    /* ADC peripheral ID 37 => PCER1 bit 5. */
    ldr r0, =PMC_PCER1
    movs r1, #(1 << 5)
    str r1, [r0]
    ldr r0, =ADC
    movs r1, #1
    str r1, [r0, #ADC_CR]
    /* 10-bit, prescaler 10, startup 16, tracking 3. */
    ldr r1, =0x030A0A00
    str r1, [r0, #ADC_MR]
    movs r1, #((1 << 6) | (1 << 7))
    str r1, [r0, #ADC_CHER]
    bx lr

/* Returns r0=A0/AD7 (X), r1=A1/AD6 (Y). */
.thumb_func
adc_read_xy:
    ldr r2, =ADC
    movs r3, #2
    str r3, [r2, #ADC_CR]
1:  ldr r3, [r2, #ADC_SR]
    and r3, r3, #((1 << 6) | (1 << 7))
    cmp r3, #((1 << 6) | (1 << 7))
    bne 1b
    ldr r1, [r2, #ADC_CDR6]
    ldr r0, [r2, #ADC_CDR7]
    bx lr
