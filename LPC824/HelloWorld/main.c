#include "lpc824.h"
#include "serial.h"
#include <stdlib.h>
#include <stdio.h>

#define F_CPU 60000000L

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
}

void wait_1ms(void)
{
	// For SysTick info check the LPC824 manual page 317 in chapter 20.
	SYST_RVR = (F_CPU/1000L) - 1;  // set reload register, counter rolls over from zero, hence -1
	SYST_CVR = 0; // load the SysTick counter
	SYST_CSR = 0x05; // Bit 0: ENABLE, BIT 1: TICKINT, BIT 2:CLKSOURCE
	while((SYST_CSR & BIT16)==0); // Bit 16 is the COUNTFLAG.  True when counter rolls over from zero.
	SYST_CSR = 0x00; // Disable Systick counter
}

void delayms(int len)
{
	while(len--) wait_1ms();
}

void main(void)
{
	ConfigPins();	
	initUART(115200);
	enable_interrupts();
	
	delayms(500); // Wait for putty to start.
	printf("Hello, World!\r\n");
	
	while(1)	
	{
		GPIO_B14 = 1;
		delayms(500);
		GPIO_B14 = 0;
		delayms(500);
	}
}
