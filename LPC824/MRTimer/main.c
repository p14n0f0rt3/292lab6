#include "lpc824.h"

// LPC824 pinout:
//                             --------
//     PIO0_23/ADC_3/ACMP_I4 -|1     20|- PIO0_14/ADC_2/ACMP_I3
//             PIO0_17/ADC_9 -|2     19|- PIO0_0/ACMP_I1/TDO
//            PIO0_13/ADC_10 -|3     18|- VREFP
//                   PIO0_12 -|4     17|- VREFN
//              RESET/PIO0_5 -|5     16|- VSS
// PIO0_4/ADC_11/WAKEUP/TRST -|6     15|- VDD
//          SWCLK/PIO0_3/TCK -|7     14|- PIO0_8/XTALIN
//          SWDIO/PIO0_2/TMS -|8     13|- PIO0_9/XTALOUT
//          PIO0_11/I2C0_SDA -|9     12|- PIO0_1/ACMP_I2/CLKIN/TDI
//          PIO0_10/I2C0_SCL -|10    11|- PIO0_15
//                             --------
// WARNING pins 9 and 10 are OPEN DRAIN.  They need external pull-up resistors to VDD if used
// as outputs. 1kohm seems to work.
//
// Reserved pins:
// Pin 4:  BOOT button
// Pin 5:  Reset
// Pin 6:  TXD
// Pin 19: RXD

void ConfigPins()
{
	GPIO_DIR0 |= BIT14; 
	GPIO_DIR0 |= BIT15; 
}

void InitMRTimers(void)
{
	SYSCON_SYSAHBCLKCTRL |= BIT10; // Enables clock for multi-rate timer. (Table 35) 
	SYSCON_PRESETCTRL |=  BIT7; // Multi-rate timer (MRT) reset control. 1: Clear the MRT reset. (Table 23)

	MRT_INTVAL0=BIT31|(60000000/2); // load inmediatly; 2 Hz interrupt
	MRT_CTRL0=BIT0; // Set timer 0 in repeat interrupt mode and enable interrupt

	MRT_INTVAL1=BIT31|(60000000/1); // load inmediatly; 1 Hz interrupt
	MRT_CTRL1=BIT0; // Set timer 1 in repeat interrupt mode and enable interrupt
		
	NVIC_ISER0|=BIT10; // Enable MRT interrupts in NVIC. (Table 7, page 19)
}

void delay(int len)
{
	while(len--);
}

// This IRQ handler is shared by the four timers in the MRT
void MRT_IRQ_Handler(void)
{
	if(MRT_IRQ_FLAG & BIT0)
	{
		MRT_STAT0 = BIT0; // Clear interrupt flag for timer 0
		GPIO_B14 = GPIO_B14?0:1;
	}
	if(MRT_IRQ_FLAG & BIT1)
	{
		MRT_STAT1 = BIT0; // Clear interrupt flag for timer 1
		GPIO_B15=GPIO_B15?0:1;
	}
	if(MRT_IRQ_FLAG & BIT2)
	{
		MRT_STAT2 = BIT0; // Clear interrupt flag for timer 2
	}
	if(MRT_IRQ_FLAG & BIT3)
	{
		MRT_STAT3 = BIT0; // Clear interrupt flag for timer 3
	}
}

void main(void)
{
	ConfigPins();
	InitMRTimers();
	enable_interrupts();
	
	while(1)	
	{
	}
}
