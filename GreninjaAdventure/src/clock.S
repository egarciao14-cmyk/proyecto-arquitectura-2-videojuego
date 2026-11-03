#include "sam3x8e.inc"
.section .text.clock,"ax",%progbits
.global clock_init
.thumb_func
clock_init:
    /* Disable watchdog and set five flash wait states before 84 MHz. */
    ldr r0, =WDT_MR
    ldr r1, =0x00008000
    str r1, [r0]
    ldr r0, =EFC0_FMR
    ldr r1, =0x00000500
    str r1, [r0]
    ldr r0, =EFC1_FMR
    str r1, [r0]
    /* Enable 12 MHz crystal: KEY, MOSCXTEN, startup=0xFF. */
    ldr r0, =CKGR_MOR
    ldr r1, =0x0037FF01
    str r1, [r0]
    ldr r2, =PMC_SR
1:  ldr r3, [r2]
    tst r3, #(1 << 0)
    beq 1b
    /* Select crystal. */
    ldr r1, =0x0137FF01
    str r1, [r0]
2:  ldr r3, [r2]
    tst r3, #(1 << 16)
    beq 2b
    /* PLLA: 12 MHz / 1 * 14 = 168 MHz. */
    ldr r0, =CKGR_PLLAR
    ldr r1, =0x200D3F01
    str r1, [r0]
3:  ldr r3, [r2]
    tst r3, #(1 << 1)
    beq 3b
    /* PRES=/2 first, then CSS=PLLA => 84 MHz MCK. */
    ldr r0, =PMC_MCKR
    movs r1, #(1 << 4)
    str r1, [r0]
4:  ldr r3, [r2]
    tst r3, #(1 << 3)
    beq 4b
    movs r1, #((1 << 4) | 2)
    str r1, [r0]
5:  ldr r3, [r2]
    tst r3, #(1 << 3)
    beq 5b
    bx lr
