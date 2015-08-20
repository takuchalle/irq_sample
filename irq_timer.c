#include <stdint.h>

#define UART0 ((volatile unsigned int*)0x101F1000)
#define UARTFR 0x06
#define UARTFR_TXFF 0x20

#define TIMER0 ((volatile unsigned int*)0x101E2000)
#define TIMER1 ((volatile unsigned int*)0x101E2020)
#define TIMER2 ((volatile unsigned int*)0x101E3000)
#define TIMER3 ((volatile unsigned int*)0x101E3020)
#define TIMER_VALUE (0x1)
#define TIMER_CONTROL (0x2)
#define TIMER_INTCLR (0x3)
#define TIMER_MIS (0x5)


#define TIMER_EN 0x80
#define TIMER_PERIODIC 0x40
#define TIMER_INTEN 0x20
#define TIMER_32BIT 0x02
#define TIMER_ONESHOT 0x01

#define PIC ((volatile unsigned int*)0x10140000)
#define PIC_TIMER01 (0x10)
#define PIC_INTENABLE (0x4) /* 0x10 bytes */

void uart_puts(char *s)
{
	while(*s) {
		while(*(UART0 + UARTFR) & UARTFR_TXFF);
		*UART0 = *s;
		s++;
	}
}

void c_irq_handler()
{
	if(*(TIMER0 + TIMER_MIS)) {
		uart_puts("timer0 interrupt!\n");
		*(TIMER0 + TIMER_INTCLR) = 1;
	}
}

void boot_main(void)
{
	int i;
	*(PIC + PIC_INTENABLE) = PIC_TIMER01;
	*TIMER0 = 1000000;

	*(TIMER0 + TIMER_CONTROL) =
		TIMER_EN | TIMER_PERIODIC | TIMER_32BIT | TIMER_INTEN;

	enable_irq();
	
	for(i = 0; i < 10; ++i);
}
