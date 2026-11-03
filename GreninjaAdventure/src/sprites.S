#include "sam3x8e.inc"
.section .text.sprites,"ax",%progbits
.global draw_player, draw_coin, draw_enemy
/* Pixel-art-like block sprites made from original geometric silhouettes. */
.thumb_func
draw_player:
    push {r4-r7,lr}
    mov r4,r0
    mov r5,r1
    /* Deep blue body 14x18. */
    sub sp,sp,#4
    ldr r6,=0x001F
    str r6,[sp]
    mov r0,r4
    mov r1,r5
    movs r2,#14
    movs r3,#18
    bl lcd_fill_rect
    /* Cyan face stripe. */
    ldr r6,=0x07FF
    str r6,[sp]
    add r0,r4,#2
    add r1,r5,#4
    movs r2,#10
    movs r3,#3
    bl lcd_fill_rect
    /* Red scarf/tongue, original simplified accent. */
    ldr r6,=0xF81F
    str r6,[sp]
    sub r0,r4,#4
    add r1,r5,#9
    movs r2,#7
    movs r3,#3
    bl lcd_fill_rect
    add sp,sp,#4
    pop {r4-r7,pc}

.thumb_func
draw_coin:
    push {lr}
    sub sp,sp,#4
    ldr r2,=0xFFE0
    str r2,[sp]
    movs r2,#7
    movs r3,#10
    bl lcd_fill_rect
    add sp,sp,#4
    pop {pc}

.thumb_func
draw_enemy:
    push {lr}
    sub sp,sp,#4
    ldr r2,=0xF800
    str r2,[sp]
    movs r2,#14
    movs r3,#14
    bl lcd_fill_rect
    add sp,sp,#4
    pop {pc}
