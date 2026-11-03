PROJECT := greninja_adventure
BUILD := build
PREFIX ?= arm-none-eabi-
AS := $(PREFIX)gcc
LD := $(PREFIX)gcc
OBJCOPY := $(PREFIX)objcopy
OBJDUMP := $(PREFIX)objdump
SIZE := $(PREFIX)size

SOURCES := src/startup.S src/clock.S src/gpio.S src/adc.S src/spi.S \
           src/ili9341.S src/timer.S src/level.S src/sprites.S src/physics.S \
           src/hud.S src/game.S
OBJECTS := $(SOURCES:src/%.S=$(BUILD)/%.o)
ASFLAGS := -mcpu=cortex-m3 -mthumb -x assembler-with-cpp -DBARE_METAL_BUILD -Isrc -Wall -Wextra
LDFLAGS := -mcpu=cortex-m3 -mthumb -nostdlib -Wl,--gc-sections \
           -Wl,-Map=$(BUILD)/$(PROJECT).map -T linker.ld

.PHONY: all clean flash size disasm
all: $(BUILD)/$(PROJECT).bin $(BUILD)/$(PROJECT).hex size

$(BUILD):
	mkdir -p $(BUILD)

$(BUILD)/%.o: src/%.S | $(BUILD)
	$(AS) $(ASFLAGS) -c $< -o $@

$(BUILD)/$(PROJECT).elf: $(OBJECTS) linker.ld
	$(LD) $(LDFLAGS) $(OBJECTS) -o $@

$(BUILD)/$(PROJECT).bin: $(BUILD)/$(PROJECT).elf
	$(OBJCOPY) -O binary $< $@

$(BUILD)/$(PROJECT).hex: $(BUILD)/$(PROJECT).elf
	$(OBJCOPY) -O ihex $< $@

size: $(BUILD)/$(PROJECT).elf
	$(SIZE) $<

disasm: $(BUILD)/$(PROJECT).elf
	$(OBJDUMP) -d -S $< > $(BUILD)/$(PROJECT).lst

flash: $(BUILD)/$(PROJECT).bin
	bossac -e -w -v -b $< -R

clean:
	rm -rf $(BUILD)
