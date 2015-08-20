CC = arm-linux-gnueabi-gcc
OBJCOPY = arm-linux-gnueabi-objcopy
RM = rm

CSRC = irq_timer.c
SSRC = vectors.S
CFLAGS = -O2

#
# Command and Option for QEMU
#
QEMU = qemu-system-arm
QEMU_MACHINE = versatilepb
QEMU_CPU = arm1176
QEMU_MEMORY = 256
QEMU_SERIAL = stdio
QEMU_OPT = -nographic -m $(QEMU_MEMORY) -M $(QEMU_MACHINE) -cpu $(QEMU_CPU) -serial $(QEMU_SERIAL)

#
# Output files
#
PRJ_NAME = irq_timer
ELF = $(PRJ_NAME).elf
DMP = $(PRJ_NAME).dmp
BIN = $(PRJ_NAME).bin

LINKER = irq_timer.ld

.SUFFIXES: .c .o .S

all: irq_timer.bin

run: $(BIN)
	export QEMU_AUDIO_DRV=none; $(QEMU) $(QEMU_OPT) -kernel $^

$(BIN): $(ELF)
	$(OBJCOPY) -O binary $^ $@

$(ELF): vectors.o irq_timer.o
	$(CC) -T $(LINKER) -nostdlib -Xlinker --build-id=none $^ -o $@

.c.o:
	$(CC) $(CFLAGS) -mcpu=arm926ej-s -c -marm -o $@ irq_timer.c

.S.o:
	$(CC) -mcpu=arm926ej-s -c -marm -o $@ vectors.S

.PHONY: clean

clean:
	$(RM) -fr irq_timer.bin irq_timer irq_timer.o vectors.o
