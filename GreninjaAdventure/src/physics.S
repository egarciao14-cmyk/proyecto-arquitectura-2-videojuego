#include "sam3x8e.inc"
.section .text.physics,"ax",%progbits
.global physics_step, collision_aabb
.extern player_x,player_y,player_vx,player_vy,player_grounded

/* Fixed integer physics. X input in r0: -1,0,+1. r1: jump edge. */
.thumb_func
physics_step:
    push {r4-r7,lr}
    ldr r2,=player_vx
    lsls r0,r0,#1
    str r0,[r2]
    ldr r2,=player_grounded
    ldr r3,[r2]
    cmp r1,#0
    beq 1f
    cmp r3,#0
    beq 1f
    ldr r4,=player_vy
    movs r5,#9
    rsbs r5,r5,#0
    str r5,[r4]
    movs r3,#0
    str r3,[r2]
1:  ldr r4,=player_vy
    ldr r5,[r4]
    adds r5,r5,#1          /* gravity */
    cmp r5,#8
    ble 2f
    movs r5,#8
2:  str r5,[r4]
    ldr r4,=player_x
    ldr r6,[r4]
    ldr r7,=player_vx
    ldr r7,[r7]
    adds r6,r6,r7
    cmp r6,#0
    bge 3f
    movs r6,#0
3:  cmp r6,#306
    ble 4f
    ldr r6,=306
4:  str r6,[r4]
    /* Vertical movement and landing on top of any platform. */
    ldr r4,=player_y
    ldr r6,[r4]
    mov r7,r6               /* old y */
    adds r6,r6,r5
    movs r3,#0
    ldr r2,=player_grounded
    str r3,[r2]
    cmp r5,#0
    blt 8f
    ldr r0,=platforms
    ldr r1,=platform_count
    ldr r1,[r1]
5:  ldrh r2,[r0,#0]        /* px */
    ldrh r3,[r0,#2]        /* py */
    ldrh r12,[r0,#4]       /* pw */
    ldr r4,=player_x
    ldr r4,[r4]
    add r12,r12,r2
    cmp r4,r12
    bge 7f
    add r4,r4,#14
    cmp r4,r2
    ble 7f
    add r2,r7,#18
    cmp r2,r3
    bgt 7f
    add r2,r6,#18
    cmp r2,r3
    blt 7f
    sub r6,r3,#18
    movs r5,#0
    ldr r4,=player_vy
    str r5,[r4]
    movs r2,#1
    ldr r4,=player_grounded
    str r2,[r4]
    b 8f
7:  add r0,r0,#8
    subs r1,r1,#1
    bne 5b
8:  ldr r4,=player_y
    str r6,[r4]
    pop {r4-r7,pc}

/* AABB: r0=x1,r1=y1,r2=w1,r3=h1; second box pointer at [sp]. r0=1 hit. */
.thumb_func
collision_aabb:
    push {r4-r7,lr}
    ldr r4,[sp,#20]
    ldrh r5,[r4]
    ldrh r6,[r4,#2]
    ldrh r7,[r4,#4]
    add r7,r7,r5
    cmp r0,r7
    bge 9f
    add r0,r0,r2
    cmp r0,r5
    ble 9f
    ldrh r7,[r4,#6]
    add r7,r7,r6
    cmp r1,r7
    bge 9f
    add r1,r1,r3
    cmp r1,r6
    ble 9f
    movs r0,#1
    pop {r4-r7,pc}
9:  movs r0,#0
    pop {r4-r7,pc}
