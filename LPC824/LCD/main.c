// Freq_Gen.mk: this LPC824 project shows how to output a square wave
// at a desired frequency on one of the pins of the microcontroller.
// Actually two frequencies are generated, f at PIO_15 (pin 11) and 2f
// at PIO_14 (pin 20).  Pin PIO_14 is directly controlled by the timer.
// PIO_15 is changed using the interrupt service routine for the timer.

#include "lpc824.h"
#include "serial.h"
#include "lcd.h"

#define SYSTEM_CLK 30000000L

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

void ConfigPins(void)
{
	// Disable SWCLK and SWDIO on pins 7 and 8. They iare enabled by default:
	SWM_PINENABLE0 |= BIT4; // Disable SWCLK
	SWM_PINENABLE0 |= BIT5; // Disable SWDIO

	// Configure the pins connected to the LCD as outputs
	GPIO_DIR0 |= BIT17; // Used for LCD_RS  Pin 2 of TSSOP20 package.
	GPIO_DIR0 |= BIT13; // Used for LCD_E.  Pin 3 of TSSOP20 package.
	GPIO_DIR0 |= BIT3;  // Used for LCD_D4. Pin 7 of TSSOP20 package.
	GPIO_DIR0 |= BIT2;  // Used for LCD_D5. Pin 8 of TSSOP20 package.
	GPIO_DIR0 |= BIT11; // Used for LCD_D6. Pin 9 of TSSOP20 package. WARNING: NEEDS PULL-UP Resistor to VDD.
	GPIO_DIR0 |= BIT10; // Used for LCD_D7. Pin 10 of TSSOP20 package. WARNING: NEEDS PULL-UP Resistor to VDD.
}

void main(void)
{
	char buff[17];
	unsigned long reload;
	
	initUART(115200);
	enable_interrupts();
	ConfigPins();	
	LCD_4BIT();

	eputs("\n"); // First dummy transmission to initialize all the transmitter functions
	waitms(1000); // Wait for putty to start
	eputs("4-bit mode LCD test using the LPC824.\r\n");
	
   	// Display something in the LCD
	LCDprint("LCD 4-bit test:", 1, 1);
	LCDprint("Hello, World!", 2, 1);
	
	buff[0]=0; 
	
	while(1)	
	{
		eputs("Type what you want to display in line 2 (16 char max): ");
		egets(buff, sizeof(buff)-1);
		eputs("\r\n");
		LCDprint(buff, 2, 1);
	}
}
