	.text
	.code	32

	.global	vectors_start
	.global	vectors_end

vectors_start:	
	LDR	PC,	reset_handler_addr
	LDR	PC,	undef_handler_addr
	LDR	PC,	swi_handler_addr
	LDR	PC,	prefetch_abort_handler_addr
	LDR	PC,	data_abort_handler_addr
	B	.
	LDR	PC,	irq_abort_handler_addr
	LDR	PC,	fiq_abort_handler_addr

reset_handler_addr:		.word	reset_handler
undef_handler_addr:		.word	halt
swi_handler_addr:		.word	halt
prefetch_abort_handler_addr:	.word	halt
data_abort_handler_addr:	.word	halt
irq_abort_handler_addr:		.word	irq_handler
fiq_abort_handler_addr:		.word	halt
vectors_end:

halt:	B	.

reset_handler:
	LDR	sp, =stack_top
/* Set Vector Tables */
	MOV	r0,	#0x00
	LDR	r1,	=vectors_start
	LDR	r3,	=vectors_end
keep_loading:
	LDR	r2,	[r1, #0x0]
	STR	r2,	[r0, #0x0]
	ADD	r0,	r0, #0x4
	ADD	r1,	r1, #0x4
	CMP	r1,	r3
	BNE	keep_loading

/*  Change to IRQ Mode */
	MRS	r0,	cpsr
	BIC	r1,	r0,	#0x1F
	ORR	r1,	r1,	#0x12
/*  Change to IRQ Mode */
	LDR	sp,	=irq_stack_top
	
/*  Change to Superviser Mode */
	MSR	cpsr,	r0

/* Jump to Main */
	BL	boot_main
	B	.


	.global	irq_handler
irq_handler:
	PUSH	{r0-r12,lr}
	BL	c_irq_handler
	POP	{r0-r12,lr}
	SUBS	pc,	lr,	#0x4

	.global	enable_irq
enable_irq:
	MRS	r0,	cpsr
	BIC	r0,	r0,	#0x80
	MSR	cpsr_c,	r0
	BX	lr

	.end
