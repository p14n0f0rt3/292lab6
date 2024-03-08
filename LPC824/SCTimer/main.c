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
	GPIO_DIR0 |= BIT14; // pin 20
	GPIO_DIR0 |= BIT15; // pin 11
}

long Dly=30000000;

void InitTimer()
{
    // Assign a pin to the timer.
    // Assign GPIO_14 to SCT_OUT0_O
	SWM_PINASSIGN7 &= 0x00ffffff;
	SWM_PINASSIGN7 |= (14 << 24); 
	
	SYSCON_SYSAHBCLKCTRL |= BIT8; // Turn on SCTimer 
	SYSCON_PRESETCTRL |=  BIT8; // Clear the reset SCT control
	
	SCTIMER_CONFIG |= BIT0; // Unified 32 bit counter
	SCTIMER_MATCH0 = Dly; // Set delay period 
	SCTIMER_MATCHREL0 = Dly;
	SCTIMER_EV0_STATE = BIT0;  // Event 0 pushes us into state 0
	// Event 0 configuration:
	// Event occurs on match of MATCH0, new state is 1	
	SCTIMER_EV0_CTRL =  BIT12 + BIT14 + BIT15;
	// State 1 configuration
	SCTIMER_EV1_STATE = BIT1;  // Event 1 pushes us into state 1
	// Event 1 configuration
	// Event occurs on MATCH0, new state is 0
	SCTIMER_EV1_CTRL =  BIT12 + BIT14;
	// OUT0 is set by event 0
	SCTIMER_OUT0_SET = BIT0;
	// OUT1 is cleared by event 1
	SCTIMER_OUT0_CLR = BIT1;
	// Processing events 0 and 1
	SCTIMER_LIMIT_L = BIT0 + BIT1;
	// Remove halt on SCTimer
	SCTIMER_CTRL &= ~BIT2;		
		
	SCTIMER_EVEN = 0x01; //Interrupt on event 0
	NVIC_ISER0|=BIT9; // Enable SCT interrupts in NVIC
}

void STC_IRQ_Handler(void)
{
	SCTIMER_EVFLAG = 0x01; // Clear interrupt flag
	GPIO_B15 = GPIO_B15?0:1; // Toggle pin 11
}

void main(void)
{
	ConfigPins();
	InitTimer();
	enable_interrupts();
	
	while(1)	
	{
	}
}
