#include "sam3x8e.inc"
#ifdef BARE_METAL_BUILD
.section .isr_vector,"a",%progbits
.word _estack
.word Reset_Handler
.word Default_Handler /* NMI */
.word Default_Handler /* HardFault */
.word Default_Handler /* MemManage */
.word Default_Handler /* BusFault */
.word Default_Handler /* UsageFault */
.word 0,0,0,0
.word Default_Handler /* SVC */
.word Default_Handler /* DebugMon */
.word 0
.word Default_Handler /* PendSV */
.word Default_Handler /* SysTick */
/* External IRQ 0..26. */
.rept 27
.word Default_Handler
.endr
.word TC0_Handler      /* IRQ 27: TC0 channel 0 */
.rept 18
.word Default_Handler
.endr

.section .text.Reset_Handler,"ax",%progbits
.global Reset_Handler
.type Reset_Handler,%function
.thumb_func
Reset_Handler:
    cpsid i
    ldr r0, =_sidata
    ldr r1, =_sdata
    ldr r2, =_edata
1:  cmp r1, r2
    bcs 2f
    ldr r3, [r0], #4
    str r3, [r1], #4
    b 1b
2:  ldr r1, =_sbss
    ldr r2, =_ebss
    movs r3, #0
3:  cmp r1, r2
    bcs 4f
    str r3, [r1], #4
    b 3b
4:  bl clock_init
    bl gpio_init
    bl adc_init
    bl spi_init
    bl ili9341_init
    bl timer_init
    bl game_init
    cpsie i
5:  bl game_loop
    b 5b

.thumb_func
Default_Handler:
    b Default_Handler
#endif
