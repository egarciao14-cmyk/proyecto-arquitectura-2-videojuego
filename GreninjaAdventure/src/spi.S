#include "sam3x8e.inc"
.section .text.spi,"ax",%progbits
.global spi_init, spi_write8, spi_write16
.thumb_func
spi_init:
    ldr r0, =PMC_PCER0
    ldr r1, =(1 << 24)
    str r1, [r0]
    ldr r0, =SPI0
    movs r1, #1
    str r1, [r0, #SPI_CR]
    movs r1, #(1 << 7)       /* master, fixed select */
    str r1, [r0, #SPI_MR]
    /* Mode 0, 14 MHz (SCBR=6), 8 bit. */
    ldr r1, =0x00000602
    str r1, [r0, #SPI_CSR0]
    movs r1, #1
    str r1, [r0, #SPI_CR]
    bx lr

.thumb_func
spi_write8:
    ldr r1, =SPI0
1:  ldr r2, [r1, #SPI_SR]
    tst r2, #(1 << 1)
    beq 1b
    str r0, [r1, #SPI_TDR]
2:  ldr r2, [r1, #SPI_SR]
    tst r2, #(1 << 0)
    beq 2b
    ldr r0, [r1, #SPI_RDR]
    bx lr

.thumb_func
spi_write16:
    push {r4,lr}
    mov r4, r0
    lsrs r0, r4, #8
    bl spi_write8
    uxtb r0, r4
    bl spi_write8
    pop {r4,pc}
