MEMORY
{
	RAM	(rwx)	: ORIGIN = 0x00010000, LENGTH = 128M
}

ENTRY(vectors_start)

SECTIONS
{
	.text : {
	      vectors.o
	      *(.text .rodata)
	} > RAM
	.data : { *(.data) } > RAM
	.bss : { *(.bss) } > RAM
	.stack : {
	       . = . + 0x1000;
	       . = ALIGN(4);
	       stack_top = .;
	       . = . + 0x1000;
	       . = ALIGN(4);
	       irq_stack_top = .;
	} > RAM
}

