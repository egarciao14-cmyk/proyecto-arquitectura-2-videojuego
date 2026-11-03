#include "sam3x8e.inc"
.section .data.level,"aw",%progbits
.global platforms, platform_count, coins, coin_count, enemies, enemy_count
/* Original level. Entries: x,y,w,h. Ground is also collision geometry. */
platforms:
 .hword 0,218,320,22
 .hword 24,184,62,8
 .hword 112,158,58,8
 .hword 198,190,45,8
 .hword 260,147,48,8
 .hword 160,112,54,8
platform_count: .word 6
/* x,y,active,padding. */
coins:
 .hword 48,169,1,0
 .hword 137,143,1,0
 .hword 219,175,1,0
 .hword 282,132,1,0
 .hword 186,97,1,0
coin_count: .word 5
/* x,y,min_x,max_x,direction,alive. Mutable RAM data. */
enemies:
 .hword 92,204,75,145,1,1
 .hword 224,176,200,246,1,1
enemy_count: .word 2
