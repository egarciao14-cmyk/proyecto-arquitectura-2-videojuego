#include "sam3x8e.inc"
.section .text.hud,"ax",%progbits
.global hud_draw, draw_title, draw_game_over
/* Minimal seven-segment digit: r0=x,r1=y,r2=digit,r3=color. */
.thumb_func
digit_draw:
    push {r4-r8,lr}
    mov r4,r0
    mov r5,r1
    mov r6,r2
    mov r7,r3
    ldr r8,=digit_masks
    ldrb r6,[r8,r6]
    /* Compact 5x7 bitmap-like digit using seven 2-pixel bars. */
    sub sp,sp,#4
    str r7,[sp]
    tst r6,#1
    beq 1f
    mov r0,r4; mov r1,r5; movs r2,#6; movs r3,#2; bl lcd_fill_rect
1:  tst r6,#2
    beq 2f
    add r0,r4,#4; add r1,r5,#1; movs r2,#2; movs r3,#6; bl lcd_fill_rect
2:  tst r6,#4
    beq 3f
    add r0,r4,#4; add r1,r5,#7; movs r2,#2; movs r3,#6; bl lcd_fill_rect
3:  tst r6,#8
    beq 4f
    mov r0,r4; add r1,r5,#12; movs r2,#6; movs r3,#2; bl lcd_fill_rect
4:  tst r6,#16
    beq 5f
    mov r0,r4; add r1,r5,#7; movs r2,#2; movs r3,#6; bl lcd_fill_rect
5:  tst r6,#32
    beq 6f
    mov r0,r4; add r1,r5,#1; movs r2,#2; movs r3,#6; bl lcd_fill_rect
6:  tst r6,#64
    beq 7f
    mov r0,r4; add r1,r5,#6; movs r2,#6; movs r3,#2; bl lcd_fill_rect
7:  add sp,sp,#4
    pop {r4-r8,pc}

.thumb_func
hud_draw:
    push {r4-r7,lr}
    sub sp,sp,#4
    ldr r0,=0x0010
    str r0,[sp]
    movs r0,#0; movs r1,#0; ldr r2,=320; movs r3,#22
    bl lcd_fill_rect
    add sp,sp,#4
    ldr r4,=score
    ldr r4,[r4]
    movs r5,#10
    udiv r6,r4,r5
    mls r7,r6,r5,r4
    movs r0,#10; movs r1,#4; mov r2,r6; ldr r3,=0xFFE0
    bl digit_draw
    movs r0,#20; movs r1,#4; mov r2,r7; ldr r3,=0xFFE0
    bl digit_draw
    ldr r2,=lives
    ldr r2,[r2]
    movs r0,#294; movs r1,#4; ldr r3,=0xFFFF
    bl digit_draw
    pop {r4-r7,pc}

.thumb_func
draw_title:
    push {lr}
    ldr r0,=0x0410
    bl lcd_fill
    /* Original emblem: water-blue bars and a pink scarf slash. */
    sub sp,sp,#4
    ldr r0,=0x07FF; str r0,[sp]
    movs r0,#55; movs r1,#62; ldr r2,=210; movs r3,#18; bl lcd_fill_rect
    movs r0,#80; movs r1,#98; ldr r2,=160; movs r3,#18; bl lcd_fill_rect
    ldr r0,=0xF81F; str r0,[sp]
    movs r0,#105; movs r1,#135; ldr r2,=110; movs r3,#8; bl lcd_fill_rect
    add sp,sp,#4
    pop {pc}

.thumb_func
draw_game_over:
    push {lr}
    ldr r0,=0x2000
    bl lcd_fill
    sub sp,sp,#4
    ldr r0,=0xF800; str r0,[sp]
    movs r0,#58; movs r1,#85; ldr r2,=204; movs r3,#18; bl lcd_fill_rect
    ldr r0,=0xFFFF; str r0,[sp]
    movs r0,#95; movs r1,#122; ldr r2,=130; movs r3,#8; bl lcd_fill_rect
    add sp,sp,#4
    pop {pc}

.section .rodata.hud,"a",%progbits
digit_masks: .byte 0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F
