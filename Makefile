CC = arm-linux-gnueabi-gcc
OBJCOPY = arm-linux-gnueabi-objcopy
RM = rm

CSRC = irq_timer.c
SSRC = vectors.S

LINKER = irq_timer.ld

all: irq_timer.bin

irq_timer.bin: irq_timer
	$(OBJCOPY) -O binary irq_timer $@

irq_timer: vectors.o irq_timer.o
	$(CC) -T $(LINKER) -nostdlib -Xlinker --build-id=none $^ -o $@

irq_timer.o: irq_timer.c Makefile
	$(CC) -mcpu=arm926ej-s -c -marm -o $@ irq_timer.c

vectors.o: vectors.S Makefile
	$(CC) -mcpu=arm926ej-s -c -marm -o $@ vectors.S

.PHONY: clean

clean:
	$(RM) -fr irq_timer.bin irq_timer irq_timer.o vectors.o
