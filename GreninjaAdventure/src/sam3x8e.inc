.syntax unified
.thumb

/* SAM3X8E register map and board pin assignments (Arduino Due). */
.equ WDT_MR,          0x400E1A54
.equ EFC0_FMR,        0x400E0A00
.equ EFC1_FMR,        0x400E0C00
.equ PMC_SCER,        0x400E0400
.equ PMC_PCER0,       0x400E0410
.equ CKGR_MOR,        0x400E0420
.equ CKGR_PLLAR,      0x400E0428
.equ PMC_MCKR,        0x400E0430
.equ PMC_SR,          0x400E0468
.equ PMC_PCER1,       0x400E0500

.equ PIOA,            0x400E0E00
.equ PIOB,            0x400E1000
.equ PIOC,            0x400E1200
.equ PIO_PER,         0x00
.equ PIO_PDR,         0x04
.equ PIO_OER,         0x10
.equ PIO_ODR,         0x14
.equ PIO_SODR,        0x30
.equ PIO_CODR,        0x34
.equ PIO_PDSR,        0x3C
.equ PIO_PUER,        0x64
.equ PIO_ABSR,        0x70

.equ SPI0,            0x40008000
.equ SPI_CR,          0x00
.equ SPI_MR,          0x04
.equ SPI_RDR,         0x08
.equ SPI_TDR,         0x0C
.equ SPI_SR,          0x10
.equ SPI_CSR0,        0x30

.equ ADC,             0x400C0000
.equ ADC_CR,          0x00
.equ ADC_MR,          0x04
.equ ADC_CHER,        0x10
.equ ADC_SR,          0x1C
.equ ADC_CDR6,        0x68
.equ ADC_CDR7,        0x6C

.equ TC0,             0x40080000
.equ TC_CCR0,         0x00
.equ TC_CMR0,         0x04
.equ TC_CV0,          0x10
.equ TC_RC0,          0x1C
.equ TC_IER0,         0x24
.equ TC_IDR0,         0x28
.equ TC_SR0,          0x20

.equ NVIC_ISER0,      0xE000E100

/* TFT: CS D10=PC29, DC D9=PC21, RST D8=PC22. */
.equ TFT_CS,          (1 << 29)
.equ TFT_DC,          (1 << 21)
.equ TFT_RST,         (1 << 22)
/* Inputs: Z D2=PB25, jump D3=PC28. */
.equ BTN_Z,           (1 << 25)
.equ BTN_JUMP,        (1 << 28)
/* SPI header: MISO PA25, MOSI PA26, SPCK PA27, peripheral A. */
.equ SPI_PINS,        ((1 << 25) | (1 << 26) | (1 << 27))

.equ LCD_W,           320
.equ LCD_H,           240

.macro LOAD reg, imm
    ldr \reg, =\imm
.endm
