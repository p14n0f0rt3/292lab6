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
}

void delay(int len)
{
	while(len--);
}

void main(void)
{
	ConfigPins();
	
	// Test code: This routes main clock (divided by 100) to pin 1
	SYSCON_CLKOUTSEL = 3; // select main clock as clock out source
	SYSCON_CLKOUTDIV = 100; // divide down so easier to measure
	SYSCON_CLKOUTUEN = 1; // update clockout source
	SWM_PINASSIGN11 = (23 << 16); // route clock out on pin 1 (GPIO0_23)
	while(1)	
	{
		GPIO_B14 = 1;
		delay(2000000);
		GPIO_B14 = 0; 
		delay(2000000);
	}
}
