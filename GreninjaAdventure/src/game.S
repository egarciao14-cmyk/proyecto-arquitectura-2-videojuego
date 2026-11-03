#include "sam3x8e.inc"
.equ STATE_MENU, 0
.equ STATE_PLAY, 1
.equ STATE_OVER, 2

.section .text.game,"ax",%progbits
.global game_init, game_loop
.global player_x,player_y,player_vx,player_vy,player_grounded,score,lives
.thumb_func
game_init:
    push {lr}
    movs r0,#STATE_MENU
    ldr r1,=game_state
    str r0,[r1]
    bl draw_title
    pop {pc}

.thumb_func
reset_play:
    push {lr}
    movs r0,#20
    ldr r1,=player_x
    str r0,[r1]
    ldr r0,=190
    ldr r1,=player_y
    str r0,[r1]
    movs r0,#0
    ldr r1,=player_vx
    str r0,[r1]
    ldr r1,=player_vy
    str r0,[r1]
    ldr r1,=score
    str r0,[r1]
    movs r0,#3
    ldr r1,=lives
    str r0,[r1]
    /* Restore collectibles and enemies for a genuinely fresh run. */
    ldr r1,=coins
    ldr r2,=coin_count
    ldr r2,[r2]
    movs r3,#1
1:  strh r3,[r1,#4]
    add r1,r1,#8
    subs r2,r2,#1
    bne 1b
    ldr r1,=enemies
    movs r0,#92
    strh r0,[r1]
    strh r3,[r1,#8]
    strh r3,[r1,#10]
    movs r0,#224
    strh r0,[r1,#12]
    strh r3,[r1,#20]
    strh r3,[r1,#22]
    movs r0,#STATE_PLAY
    ldr r1,=game_state
    str r0,[r1]
    pop {pc}

.thumb_func
game_loop:
    push {r4-r7,lr}
    ldr r0,=tick_flag
    ldr r1,[r0]
    cmp r1,#0
    beq 9f
    movs r1,#0
    str r1,[r0]
    bl buttons_read
    mov r4,r0
    ldr r5,=game_state
    ldr r5,[r5]
    cmp r5,#STATE_MENU
    beq menu_tick
    cmp r5,#STATE_OVER
    beq over_tick
    bl play_tick
    b 9f
menu_tick:
    tst r4,#1
    beq 9f
    bl reset_play
    bl render_scene
    b 9f
over_tick:
    tst r4,#1
    beq 9f
    bl game_init
9:  pop {r4-r7,pc}

.thumb_func
play_tick:
    push {r4-r7,lr}
    mov r7,r4
    bl adc_read_xy
    movs r4,#0
    cmp r0,#350
    bhs 1f
    movs r4,#1
    rsbs r4,r4,#0
    b 2f
1:  cmp r0,#674
    blo 2f
    movs r4,#1
2:  and r5,r7,#2
    lsrs r5,r5,#1
    mov r0,r4
    mov r1,r5
    bl physics_step
    bl collect_coins
    bl update_enemies
    ldr r0,=player_y
    ldr r0,[r0]
    cmp r0,#240
    ble 3f
    bl lose_life
3:  bl render_scene
    pop {r4-r7,pc}

.thumb_func
collect_coins:
    push {r4-r7,lr}
    ldr r4,=coins
    ldr r5,=coin_count
    ldr r5,[r5]
1:  ldrh r0,[r4,#4]
    cmp r0,#0
    beq 3f
    ldr r0,=player_x
    ldr r0,[r0]
    ldrh r1,[r4]
    subs r0,r0,r1
    ldr r2,=-14
    cmp r0,r2
    blt 3f
    cmp r0,#7
    bgt 3f
    ldr r0,=player_y
    ldr r0,[r0]
    ldrh r1,[r4,#2]
    subs r0,r0,r1
    ldr r2,=-18
    cmp r0,r2
    blt 3f
    cmp r0,#10
    bgt 3f
    movs r0,#0
    strh r0,[r4,#4]
    ldr r1,=score
    ldr r0,[r1]
    adds r0,r0,#1
    str r0,[r1]
3:  add r4,r4,#8
    subs r5,r5,#1
    bne 1b
    pop {r4-r7,pc}

/* Patrol enemies and test a compact player/enemy AABB. */
.thumb_func
update_enemies:
    push {r4-r7,lr}
    ldr r4,=enemies
    ldr r5,=enemy_count
    ldr r5,[r5]
1:  ldrh r0,[r4,#10]
    cmp r0,#0
    beq 5f
    ldrsh r6,[r4,#8]
    ldrh r7,[r4]
    adds r7,r7,r6
    ldrh r0,[r4,#4]
    cmp r7,r0
    bgt 2f
    movs r6,#1
2:  ldrh r0,[r4,#6]
    cmp r7,r0
    blt 3f
    movs r6,#1
    rsbs r6,r6,#0
3:  strh r7,[r4]
    strh r6,[r4,#8]
    ldr r0,=player_x
    ldr r0,[r0]
    subs r0,r0,r7
    ldr r2,=-14
    cmp r0,r2
    blt 5f
    cmp r0,#14
    bgt 5f
    ldr r0,=player_y
    ldr r0,[r0]
    ldrh r1,[r4,#2]
    subs r0,r0,r1
    ldr r2,=-18
    cmp r0,r2
    blt 5f
    cmp r0,#14
    bgt 5f
    bl lose_life
    b 6f
5:  add r4,r4,#12
    subs r5,r5,#1
    bne 1b
6:  pop {r4-r7,pc}

.thumb_func
lose_life:
    push {lr}
    ldr r1,=lives
    ldr r0,[r1]
    subs r0,r0,#1
    str r0,[r1]
    cmp r0,#0
    bne 1f
    movs r0,#STATE_OVER
    ldr r1,=game_state
    str r0,[r1]
    bl draw_game_over
    b 2f
1:  movs r0,#190
    ldr r1,=player_y
    str r0,[r1]
    movs r0,#20
    ldr r1,=player_x
    str r0,[r1]
2:  pop {pc}

.thumb_func
render_scene:
    push {r4-r7,lr}
    ldr r0,=0x0433
    bl lcd_fill
    /* Platforms. */
    ldr r4,=platforms
    ldr r5,=platform_count
    ldr r5,[r5]
1:  ldrh r0,[r4]; ldrh r1,[r4,#2]; ldrh r2,[r4,#4]; ldrh r3,[r4,#6]
    sub sp,sp,#4
    ldr r6,=0x0600
    str r6,[sp]
    bl lcd_fill_rect
    add sp,sp,#4
    add r4,r4,#8
    subs r5,r5,#1
    bne 1b
    /* Coins (immutable table currently all rendered; collection still scores). */
    ldr r4,=coins
    ldr r5,=coin_count
    ldr r5,[r5]
2:  ldrh r6,[r4,#4]
    cmp r6,#0
    beq 3f
    ldrh r0,[r4]; ldrh r1,[r4,#2]
    bl draw_coin
3:  add r4,r4,#8
    subs r5,r5,#1
    bne 2b
    /* Enemies. */
    ldr r4,=enemies
    ldr r5,=enemy_count
    ldr r5,[r5]
4:  ldrh r6,[r4,#10]
    cmp r6,#0
    beq 5f
    ldrh r0,[r4]
    ldrh r1,[r4,#2]
    bl draw_enemy
5:  add r4,r4,#12
    subs r5,r5,#1
    bne 4b
    ldr r0,=player_x
    ldr r0,[r0]
    ldr r1,=player_y
    ldr r1,[r1]
    bl draw_player
    bl hud_draw
    pop {r4-r7,pc}

.section .bss,"aw",%nobits
.align 2
game_state: .space 4
player_x: .space 4
player_y: .space 4
player_vx: .space 4
player_vy: .space 4
player_grounded: .space 4
score: .space 4
lives: .space 4
