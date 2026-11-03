#include "sam3x8e.inc"
.section .text.timer,"ax",%progbits
.global timer_init, TC0_Handler, tick_flag, frame_counter
.thumb_func
timer_init:
    ldr r0, =PMC_PCER0
    ldr r1, =(1 << 27)
    str r1, [r0]
    ldr r0, =TC0
    movs r1, #2
    str r1, [r0, #TC_CCR0]
    ldr r1, =0x00004003    /* TIMER_CLOCK4=MCK/128, stop at RC */
    str r1, [r0, #TC_CMR0]
    ldr r1, =10938        /* ~60.00 Hz */
    str r1, [r0, #TC_RC0]
    movs r1, #0x10
    str r1, [r0, #TC_IER0]
    ldr r0, =NVIC_ISER0
    ldr r1, =(1 << 27)
    str r1, [r0]
    ldr r0, =TC0
    movs r1, #5
    str r1, [r0, #TC_CCR0]
    bx lr

.thumb_func
TC0_Handler:
    ldr r0, =TC0
    ldr r1, [r0, #TC_SR0]
    ldr r0, =tick_flag
    movs r1, #1
    str r1, [r0]
    ldr r0, =frame_counter
    ldr r1, [r0]
    adds r1, r1, #1
    str r1, [r0]
    bx lr

.section .bss,"aw",%nobits
.align 2
tick_flag: .space 4
frame_counter: .space 4
