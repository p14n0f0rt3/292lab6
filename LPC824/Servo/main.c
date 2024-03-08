// servo.mk: this LPC824 project shows how to output a standard servo pwm output.
// Notice that pin PIO_14 is directly controlled by the timer.
// PIO_15 is changed using the interrupt service routine for the timer.

#include "lpc824.h"
#include "serial.h"

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

#define SYSTEM_CLK 60000000L
#define DEFAULT_F 100000L // For a 10us servo resolution

volatile unsigned int servo_cnt=0;
volatile unsigned int servo1=150; // 150 means a pulse of 1.5ms

// Configure the pins as outputs
void ConfigPins(void)
{
	GPIO_DIR0 |= BIT14; // To check the ISR rate
	GPIO_DIR0 |= BIT15; // Our servo signal output
}

void wait_1ms(void)
{
	// For SysTick info check the LPC824 manual page 317 in chapter 20.
	SYST_RVR = (SYSTEM_CLK/1000L) - 1;  // set reload register, counter rolls over from zero, hence -1
	SYST_CVR = 0; // load the SysTick counter
	SYST_CSR = 0x05; // Bit 0: ENABLE, BIT 1: TICKINT, BIT 2:CLKSOURCE
	while((SYST_CSR & BIT16)==0); // Bit 16 is the COUNTFLAG.  True when counter rolls over from zero.
	SYST_CSR = 0x00; // Disable Systick counter
}

void waitms(int len)
{
	while(len--) wait_1ms();
}

void InitTimer(void)
{
	SCTIMER_CTRL |= BIT2; // halt SCTimer

    // Assign a pin to the timer. So we can check the frequency.  (It should be 100kHz)
    // Assign GPIO_14 to SCT_OUT0_O
	SWM_PINASSIGN7 &= 0x00ffffff;
	SWM_PINASSIGN7 |= (14 << 24); 
	
	SYSCON_SYSAHBCLKCTRL |= BIT8; // Turn on SCTimer 
	SYSCON_PRESETCTRL |=  BIT8; // Clear the reset SCT control
	
	SCTIMER_CONFIG |= BIT0; // Unified 32 bit counter
	SCTIMER_MATCH0 = SYSTEM_CLK/DEFAULT_F/2; // Set delay period 
	SCTIMER_MATCHREL0 = SYSTEM_CLK/DEFAULT_F/2;
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
	servo_cnt++;
	if(servo_cnt==2000) servo_cnt=0; // Period of servo signal is 20ms
	if(servo_cnt<=servo1)
	{
		GPIO_B15 = 1;
	}
	else
	{
		GPIO_B15 = 0;
	}
}

int myAtoi(char *str)
{
    int i, res=0;
    for (i=0; str[i]!='\0'; ++i) res=res*10+(str[i]-'0');
    return res;
}

void main(void)
{
	int new_width;
	char buff2[100];
	
	ConfigPins();	
	InitTimer();
	initUART(115200);
	enable_interrupts();
	
	waitms(500); // Wait for PuTTY to start before sending data.
	eputs("Servo signal using the LPC824.  The signal is in pin 11.\r\n");
	while(1)	
	{
	    eputs("\r\nNew pulse width (60 to 240): ");
	    egets(buff2, 100-1);
	    new_width=myAtoi(buff2);
	    if( (new_width>=60) && (new_width<=240) )
	    {
	    	servo1=new_width;
	    }
	}
}
