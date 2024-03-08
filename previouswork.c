// CALCULATES BPM BASED ON PERIOD
#include <EFM8LB1.h>
#include <stdio.h>
#include <string.h>

#define SYSCLK      24500000L  // SYSCLK frequency in Hz
#define BAUDRATE      115200L  // Baud rate of UART in bps

// lcd initialization
    #define LCD_RS P1_7
    // #define LCD_RW Px_x // Not used in this code.  Connect to GND
    #define LCD_E  P2_0
    #define LCD_D4 P1_3
    #define LCD_D5 P1_2
    #define LCD_D6 P1_1
    #define LCD_D7 P1_0
    #define CHARS_PER_LINE 16

	#define SW_1   P0_2
	#define SW_2   P0_3
	#define SW_3   P0_4

unsigned char overflow_count;

char _c51_external_startup (void)
{
	// Disable Watchdog with key sequence
	SFRPAGE = 0x00;
	WDTCN = 0xDE; //First key
	WDTCN = 0xAD; //Second key
  
	VDM0CN |= 0x80;
	RSTSRC = 0x02;

	// Use a 24.5MHz clock - CHANGED SEGMENT TO BELOW

    // Copied from PeriodEFM8.c + efm8_lcd_4bit
    #if (SYSCLK == 48000000L)	
		SFRPAGE = 0x10;
		PFE0CN  = 0x10; // SYSCLK < 50 MHz.
		SFRPAGE = 0x00;
	#elif (SYSCLK == 72000000L)
		SFRPAGE = 0x10;
		PFE0CN  = 0x20; // SYSCLK < 75 MHz.
		SFRPAGE = 0x00;
	#endif
	
	#if (SYSCLK == 12250000L)
		CLKSEL = 0x10;
		CLKSEL = 0x10;
		while ((CLKSEL & 0x80) == 0);
	#elif (SYSCLK == 24500000L)
		CLKSEL = 0x00;
		CLKSEL = 0x00;
		while ((CLKSEL & 0x80) == 0);
	#elif (SYSCLK == 48000000L)	
		// Before setting clock to 48 MHz, must transition to 24.5 MHz first
		CLKSEL = 0x00;
		CLKSEL = 0x00;
		while ((CLKSEL & 0x80) == 0);
		CLKSEL = 0x07;
		CLKSEL = 0x07;
		while ((CLKSEL & 0x80) == 0);
	#elif (SYSCLK == 72000000L)
		// Before setting clock to 72 MHz, must transition to 24.5 MHz first
		CLKSEL = 0x00;
		CLKSEL = 0x00;
		while ((CLKSEL & 0x80) == 0);
		CLKSEL = 0x03;
		CLKSEL = 0x03;
		while ((CLKSEL & 0x80) == 0);
	#else
		#error SYSCLK must be either 12250000L, 24500000L, 48000000L, or 72000000L
	#endif

	
	// UNCHANGED FROM HELLO WORLD AFTER ABOVE
	P0MDOUT |= 0x10; // Enable UART0 TX as push-pull output
	XBR0     = 0x01; // Enable UART0 on P0.4(TX) and P0.5(RX)                     
	XBR1     = 0X00;
	XBR2     = 0x40; // Enable crossbar and weak pull-ups

    // added - from PeriodEFM8.c
    #if (((SYSCLK/BAUDRATE)/(2L*12L))>0xFFL)
		#error Timer 0 reload value is incorrect because (SYSCLK/BAUDRATE)/(2L*12L) > 0xFF
	#endif

	// Configure Uart 0
	SCON0 = 0x10;

    /*CKCON0 |= 0b_0000_0000 ; // Timer 1 uses the system clock divided by 12.
	TH1 = 0x100-((SYSCLK/BAUDRATE)/(2L*12L));
*/
    
	CKCON0 |= 0b_0000_1000 ; // Timer 1 uses the system clock.
	TH1 = 0x100-((SYSCLK/BAUDRATE)/2L);
    

	TL1 = TH1;      // Init Timer1
	TMOD &= ~0xf0;  // TMOD: timer 1 in 8-bit auto-reload
	TMOD |=  0x20;                       
	TR1 = 1; // START Timer1
	TI = 1;  // Indicate TX0 ready
	
	return 0;
}

// Uses Timer3 to delay <us> micro-seconds. 
void Timer3us(unsigned char us)
{
	unsigned char i;               // usec counter
	
	// The input for Timer 3 is selected as SYSCLK by setting T3ML (bit 6) of CKCON0:
	CKCON0|=0b_0100_0000;
	
	TMR3RL = (-(SYSCLK)/1000000L); // Set Timer3 to overflow in 1us.
	TMR3 = TMR3RL;                 // Initialize Timer3 for first overflow
	
	TMR3CN0 = 0x04;                 // Sart Timer3 and clear overflow flag
	for (i = 0; i < us; i++)       // Count <us> overflows
	{
		while (!(TMR3CN0 & 0x80));  // Wait for overflow
		TMR3CN0 &= ~(0x80);         // Clear overflow indicator
	}
	TMR3CN0 = 0 ;                   // Stop Timer3 and clear overflow flag
}

void waitms (unsigned int ms)
{
	unsigned int j;
	for(j=ms; j!=0; j--)
	{
		Timer3us(249);
		Timer3us(249);
		Timer3us(249);
		Timer3us(250);
	}
}
/* note that in EFM8_LCD_4bit.c this is the code for waitms:
void waitms (unsigned int ms)
{
	unsigned int j;
	unsigned char k;
	for(j=0; j<ms; j++)
		for (k=0; k<4; k++) Timer3us(250);
}
*/

void TIMER0_Init(void)
{
	TMOD&=0b_1111_0000; // Set the bits of Timer/Counter 0 to zero
	TMOD|=0b_0000_0001; // Timer/Counter 0 used as a 16-bit timer
	TR0=0; // Stop Timer/Counter 0
}
void LCD_pulse (void)
{
	LCD_E=1;
	Timer3us(40);
	LCD_E=0;
}

void LCD_byte (unsigned char x)
{
	// The accumulator in the C8051Fxxx is bit addressable!
	ACC=x; //Send high nible
	LCD_D7=ACC_7;
	LCD_D6=ACC_6;
	LCD_D5=ACC_5;
	LCD_D4=ACC_4;
	LCD_pulse();
	Timer3us(40);
	ACC=x; //Send low nible
	LCD_D7=ACC_3;
	LCD_D6=ACC_2;
	LCD_D5=ACC_1;
	LCD_D4=ACC_0;
	LCD_pulse();
}

void WriteData (unsigned char x)
{
	LCD_RS=1;
	LCD_byte(x);
	waitms(2);
}

void WriteCommand (unsigned char x)
{
	LCD_RS=0;
	LCD_byte(x);
	waitms(5);
}

void LCD_4BIT (void)
{
	LCD_E=0; // Resting state of LCD's enable is zero
	// LCD_RW=0; // We are only writing to the LCD in this program
	waitms(20);
	// First make sure the LCD is in 8-bit mode and then change to 4-bit mode
	WriteCommand(0x33);
	WriteCommand(0x33);
	WriteCommand(0x32); // Change to 4-bit mode

	// Configure the LCD
	WriteCommand(0x28);
	WriteCommand(0x0c);
	WriteCommand(0x01); // Clear screen command (takes some time)
	waitms(20); // Wait for clear screen command to finsih.
}
void LCDprint(char * string, unsigned char line, bit clear)
{
	int j;

	WriteCommand(line == 2 ? 0xc0:0x80);
	waitms(5);
	for (j=0; string[j]!=0; j++)	
        WriteData(string[j]);// Write the message
	if (clear) 
        for(; j<CHARS_PER_LINE; j++) 
            WriteData(' '); // Clear the rest of the line
}

int getsn (char * buff, int len)
{
	int j;
	char c;
	
	for(j=0; j<(len-1); j++)
	{
		c=getchar();
		if ( (c=='\n') || (c=='\r') )
		{
			buff[j]=0;
			return j;
		}
		else
		{
			buff[j]=c;
		}
	}
	buff[j]=0;
	return len;
}

void setting_detect (float period, float bpm) {
	int menu_setting;
	
	float frequency;

	float bpm_avg = 0;
	float bpm_sum = 0;
	int count = 0;

	char bpm_buffer[17];

	if((SW_1 == 1)&&(SW_2 == 0) && (SW_3 == 0))
		menu_setting = 1; //display avg bpm
	else if((SW_1 == 0)&&(SW_2 == 1) && (SW_3 == 0))
		menu_setting = 2; //display period
	else if((SW_1 == 0)&&(SW_2 == 0) && (SW_3 == 1))
		menu_setting = 3; //display frequency
	else
		menu_setting = 0; //default setting displaying bpm


	if(menu_setting == 1) {
			count++;
			bpm_sum += bpm;
			bpm_avg = bpm_sum / count;

			sprintf(bpm_buffer, "%.4f", bpm_avg);
        	LCDprint("Average BPM: ", 1, 1);
        	LCDprint(bpm_buffer, 2, 1);
		}

		else if(menu_setting == 2) {

			sprintf(bpm_buffer, "%.4f", period);
        	LCDprint("Period (s): ", 1, 1);
        	LCDprint(bpm_buffer, 2, 1);
		}

		else if(menu_setting == 3) {
			frequency = (float)1/period;

			sprintf(bpm_buffer, "%.4f", frequency);
        	LCDprint("Frequency (Hz): ", 1, 1);
        	LCDprint(bpm_buffer, 2, 1);
		}

		else {
		
		sprintf(bpm_buffer, "%.4f", bpm);
        LCDprint("Current BPM: ", 1, 1);
        LCDprint(bpm_buffer, 2, 1);
		}
}
void main (void) 
{
	// Variables
	float period;
	float bpm;
		
//	char frequencyarr_buffer[6];

    // Configure LCD AND print hello world there
    //char buff[17];
	// Configure the LCD
	LCD_4BIT();

    // Print Hello World to Serial Port
    printf( "Hello, world!\r\n" );

    // Calculate period
	
	TIMER0_Init();

	waitms(500); // Give PuTTY a chance to start.
	printf("\x1b[2J"); // Clear screen using ANSI escape sequence.

	/*printf ("EFM8 Period measurement at pin P0.1 using Timer 0.\n"
	        "File: %s\n"
	        "Compiled: %s, %s\n\n",
	 
	    __FILE__, __DATE__, __TIME__);*/
	
    while (1)
    {
    	// Reset the counter
		TL0=0; 
		TH0=0;
		TF0=0;
		overflow_count=0;
		
		while(P0_1!=0); // Wait for the signal to be zero
		while(P0_1!=1); // Wait for the signal to be one
		TR0=1; // Start the timer
		while(P0_1!=0) // Wait for the signal to be zero
		{
			if(TF0==1) // Did the 16-bit timer overflow?
			{
				TF0=0;
				overflow_count++;
			}
		}
		while(P0_1!=1) // Wait for the signal to be one
		{
			if(TF0==1) // Did the 16-bit timer overflow?
			{
				TF0=0;
				overflow_count++;
			}
		}
		TR0=0; // Stop timer 0, the 24-bit number [overflow_count-TH0-TL0] has the period!
		period=(overflow_count*65536.0+TH0*256.0+TL0)*(12.0/SYSCLK);
		// Send the period to the serial port
		//printf( "\rT=%f ms    ", period*1000.0);
		
		bpm = 60/period;
		setting_detect(period, bpm);
	
		printf("%3.4f\r\n", period);
		
		setting_detect(period, bpm);
        }

		
	
}
