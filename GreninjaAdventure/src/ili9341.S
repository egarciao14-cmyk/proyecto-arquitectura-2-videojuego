#include "sam3x8e.inc"
.section .text.lcd,"ax",%progbits
.global ili9341_init, lcd_fill, lcd_fill_rect, lcd_pixel
.thumb_func
lcd_delay:
    subs r0, r0, #1
    bne lcd_delay
    bx lr
.thumb_func
lcd_cmd:
    push {r4,lr}
    mov r4, r0
    ldr r1, =PIOC
    ldr r2, =TFT_DC
    str r2, [r1, #PIO_CODR]
    ldr r2, =TFT_CS
    str r2, [r1, #PIO_CODR]
    mov r0, r4
    bl spi_write8
    ldr r1, =PIOC
    ldr r2, =TFT_CS
    str r2, [r1, #PIO_SODR]
    pop {r4,pc}
.thumb_func
lcd_data8:
    push {r4,lr}
    mov r4, r0
    ldr r1, =PIOC
    ldr r2, =TFT_DC
    str r2, [r1, #PIO_SODR]
    ldr r2, =TFT_CS
    str r2, [r1, #PIO_CODR]
    mov r0, r4
    bl spi_write8
    ldr r1, =PIOC
    ldr r2, =TFT_CS
    str r2, [r1, #PIO_SODR]
    pop {r4,pc}

.thumb_func
ili9341_init:
    push {lr}
    ldr r1, =PIOC
    ldr r2, =TFT_RST
    str r2, [r1, #PIO_CODR]
    ldr r0, =100000
    bl lcd_delay
    str r2, [r1, #PIO_SODR]
    ldr r0, =800000
    bl lcd_delay
    movs r0, #0x01
    bl lcd_cmd
    ldr r0, =800000
    bl lcd_delay
    movs r0, #0x28
    bl lcd_cmd
    movs r0, #0x3A
    bl lcd_cmd
    movs r0, #0x55          /* RGB565 */
    bl lcd_data8
    movs r0, #0x36
    bl lcd_cmd
    movs r0, #0x28          /* landscape, BGR */
    bl lcd_data8
    movs r0, #0x11
    bl lcd_cmd
    ldr r0, =800000
    bl lcd_delay
    movs r0, #0x29
    bl lcd_cmd
    pop {pc}

/* r0=x, r1=y, r2=w, r3=h; establishes write window. */
.thumb_func
lcd_window:
    push {r4-r7,lr}
    mov r4,r0
    mov r5,r1
    add r6,r0,r2
    subs r6,r6,#1
    add r7,r1,r3
    subs r7,r7,#1
    movs r0,#0x2A
    bl lcd_cmd
    lsrs r0,r4,#8
    bl lcd_data8
    uxtb r0,r4
    bl lcd_data8
    lsrs r0,r6,#8
    bl lcd_data8
    uxtb r0,r6
    bl lcd_data8
    movs r0,#0x2B
    bl lcd_cmd
    lsrs r0,r5,#8
    bl lcd_data8
    uxtb r0,r5
    bl lcd_data8
    lsrs r0,r7,#8
    bl lcd_data8
    uxtb r0,r7
    bl lcd_data8
    movs r0,#0x2C
    bl lcd_cmd
    pop {r4-r7,pc}

/* r0=x,r1=y,r2=w,r3=h, [sp]=RGB565 color (AAPCS fifth argument). */
.thumb_func
lcd_fill_rect:
    push {r4-r8,lr}
    ldr r8,[sp,#24]
    mul r4,r2,r3
    bl lcd_window
    ldr r5,=PIOC
    ldr r6,=TFT_DC
    str r6,[r5,#PIO_SODR]
    ldr r6,=TFT_CS
    str r6,[r5,#PIO_CODR]
1:  mov r0,r8
    bl spi_write16
    subs r4,r4,#1
    bne 1b
    str r6,[r5,#PIO_SODR]
    pop {r4-r8,pc}

.thumb_func
lcd_fill:
    push {r4,lr}
    mov r4,r0
    sub sp,sp,#4
    str r4,[sp]
    movs r0,#0
    movs r1,#0
    ldr r2,=LCD_W
    movs r3,#LCD_H
    bl lcd_fill_rect
    add sp,sp,#4
    pop {r4,pc}

/* r0=x,r1=y,r2=color. */
.thumb_func
lcd_pixel:
    push {lr}
    sub sp,sp,#4
    str r2,[sp]
    movs r2,#1
    movs r3,#1
    bl lcd_fill_rect
    add sp,sp,#4
    pop {pc}
