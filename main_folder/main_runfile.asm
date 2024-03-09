;--------------------------------------------------------
; File Created by C51
; Version 1.0.0 #1170 (Feb 16 2022) (MSVC)
; This file was generated Fri Mar 08 17:10:33 2024
;--------------------------------------------------------
$name main_runfile
$optc51 --model-small
	R_DSEG    segment data
	R_CSEG    segment code
	R_BSEG    segment bit
	R_XSEG    segment xdata
	R_PSEG    segment xdata
	R_ISEG    segment idata
	R_OSEG    segment data overlay
	BIT_BANK  segment data overlay
	R_HOME    segment code
	R_GSINIT  segment code
	R_IXSEG   segment xdata
	R_CONST   segment code
	R_XINIT   segment code
	R_DINIT   segment code

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	public _main
	public _ConfigPins
	public _GetPeriod
	public _wait_1ms
;--------------------------------------------------------
; Special Function Registers
;--------------------------------------------------------
;--------------------------------------------------------
; special function bits
;--------------------------------------------------------
;--------------------------------------------------------
; overlayable register banks
;--------------------------------------------------------
	rbank0 segment data overlay
;--------------------------------------------------------
; internal ram data
;--------------------------------------------------------
	rseg R_DSEG
_main_buff_1_30:
	ds 17
;--------------------------------------------------------
; overlayable items in internal ram 
;--------------------------------------------------------
	rseg	R_OSEG
;--------------------------------------------------------
; indirectly addressable internal ram data
;--------------------------------------------------------
	rseg R_ISEG
;--------------------------------------------------------
; absolute internal ram data
;--------------------------------------------------------
	DSEG
;--------------------------------------------------------
; bit data
;--------------------------------------------------------
	rseg R_BSEG
;--------------------------------------------------------
; paged external ram data
;--------------------------------------------------------
	rseg R_PSEG
;--------------------------------------------------------
; external ram data
;--------------------------------------------------------
	rseg R_XSEG
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	XSEG
;--------------------------------------------------------
; external initialized ram data
;--------------------------------------------------------
	rseg R_IXSEG
	rseg R_HOME
	rseg R_GSINIT
	rseg R_CSEG
;--------------------------------------------------------
; Reset entry point and interrupt vectors
;--------------------------------------------------------
	CSEG at 0x0000
	ljmp	_crt0
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	rseg R_HOME
	rseg R_GSINIT
	rseg R_GSINIT
;--------------------------------------------------------
; data variables initialization
;--------------------------------------------------------
	rseg R_DINIT
	; The linker places a 'ret' at the end of segment R_DINIT.
;--------------------------------------------------------
; code
;--------------------------------------------------------
	rseg R_CSEG
;------------------------------------------------------------
;Allocation info for local variables in function 'wait_1ms'
;------------------------------------------------------------
;------------------------------------------------------------
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:10: void wait_1ms(void)
;	-----------------------------------------
;	 function wait_1ms
;	-----------------------------------------
_wait_1ms:
	using	0
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:13: SYST_RVR = (F_CPU/1000L) - 1;  // set reload register, counter rolls over from zero, hence -1
	mov	dptr,#0xE014
	mov	b,#0x00
	mov	a,#0x2F
	lcall	__gptrput
	inc	dptr
	mov	a,#0x75
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:14: SYST_CVR = 0; // load the SysTick counter
	mov	dptr,#0xE018
	clr	a
	mov	b,a
	lcall	__gptrput
	inc	dptr
	clr	a
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:15: SYST_CSR = 0x05; // Bit 0: ENABLE, BIT 1: TICKINT, BIT 2:CLKSOURCE
	mov	dptr,#0xE010
	mov	b,#0x00
	mov	a,#0x05
	lcall	__gptrput
	inc	dptr
	clr	a
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:16: while((SYST_CSR & BIT16)==0); // Bit 16 is the COUNTFLAG.  True when counter rolls over from zero.
L002001?:
	mov	dptr,#0xE010
	mov	b,#0x00
	lcall	__gptrget
	inc	dptr
	lcall	__gptrget
	clr	a
	mov	r2,a
	mov	r3,a
	orl	a,r2
	jz	L002001?
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:17: SYST_CSR = 0x00; // Disable Systick counter
	mov	dptr,#0xE010
	clr	a
	mov	b,a
	lcall	__gptrput
	inc	dptr
	clr	a
	ljmp	__gptrput
;------------------------------------------------------------
;Allocation info for local variables in function 'GetPeriod'
;------------------------------------------------------------
;n                         Allocated to registers r2 r3 
;i                         Allocated to registers r4 r5 
;saved_TCNT1a              Allocated with name '_GetPeriod_saved_TCNT1a_1_21'
;saved_TCNT1b              Allocated with name '_GetPeriod_saved_TCNT1b_1_21'
;------------------------------------------------------------
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:52: long int GetPeriod (int n)
;	-----------------------------------------
;	 function GetPeriod
;	-----------------------------------------
_GetPeriod:
	mov	r2,dpl
	mov	r3,dph
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:57: SYST_RVR = 0xffffff;  // 24-bit counter set to check for signal present
	mov	dptr,#0xE014
	mov	b,#0x00
	mov	a,#0xFF
	lcall	__gptrput
	inc	dptr
	mov	a,#0xFF
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:58: SYST_CVR = 0xffffff; // load the SysTick counter
	mov	dptr,#0xE018
	mov	b,#0x00
	mov	a,#0xFF
	lcall	__gptrput
	inc	dptr
	mov	a,#0xFF
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:59: SYST_CSR = 0x05; // Bit 0: ENABLE, BIT 1: TICKINT, BIT 2:CLKSOURCE
	mov	dptr,#0xE010
	mov	b,#0x00
	mov	a,#0x05
	lcall	__gptrput
	inc	dptr
	clr	a
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:60: while (PIN_PERIOD!=0) // Wait for square wave to be 0
L003003?:
	mov	dptr,#0x0001
	mov	b,#0x00
	lcall	__gptrget
	jz	L003005?
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:62: if(SYST_CSR & BIT16) return 0;
	mov	dptr,#0xE010
	mov	b,#0x00
	lcall	__gptrget
	inc	dptr
	lcall	__gptrget
	clr	a
	mov	r4,a
	mov	r5,a
	orl	a,r4
	jz	L003003?
	mov	dptr,#(0x00&0x00ff)
	clr	a
	mov	b,a
	ret
L003005?:
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:64: SYST_CSR = 0x00; // Disable Systick counter
	mov	dptr,#0xE010
	clr	a
	mov	b,a
	lcall	__gptrput
	inc	dptr
	clr	a
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:66: SYST_RVR = 0xffffff;  // 24-bit counter set to check for signal present
	mov	dptr,#0xE014
	mov	b,#0x00
	mov	a,#0xFF
	lcall	__gptrput
	inc	dptr
	mov	a,#0xFF
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:67: SYST_CVR = 0xffffff; // load the SysTick counter
	mov	dptr,#0xE018
	mov	b,#0x00
	mov	a,#0xFF
	lcall	__gptrput
	inc	dptr
	mov	a,#0xFF
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:68: SYST_CSR = 0x05; // Bit 0: ENABLE, BIT 1: TICKINT, BIT 2:CLKSOURCE
	mov	dptr,#0xE010
	mov	b,#0x00
	mov	a,#0x05
	lcall	__gptrput
	inc	dptr
	clr	a
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:69: while (PIN_PERIOD==0) // Wait for square wave to be 1
L003008?:
	mov	dptr,#0x0001
	mov	b,#0x00
	lcall	__gptrget
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:71: if(SYST_CSR & BIT16) return 0;
	jnz	L003010?
	mov	dptr,#0xE010
	mov	b,a
	lcall	__gptrget
	inc	dptr
	lcall	__gptrget
	clr	a
	mov	r4,a
	mov	r5,a
	orl	a,r4
	jz	L003008?
	mov	dptr,#(0x00&0x00ff)
	clr	a
	mov	b,a
	ret
L003010?:
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:73: SYST_CSR = 0x00; // Disable Systick counter
	mov	dptr,#0xE010
	clr	a
	mov	b,a
	lcall	__gptrput
	inc	dptr
	clr	a
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:75: SYST_RVR = 0xffffff;  // 24-bit counter reset
	mov	dptr,#0xE014
	mov	b,#0x00
	mov	a,#0xFF
	lcall	__gptrput
	inc	dptr
	mov	a,#0xFF
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:76: SYST_CVR = 0xffffff; // load the SysTick counter to initial value
	mov	dptr,#0xE018
	mov	b,#0x00
	mov	a,#0xFF
	lcall	__gptrput
	inc	dptr
	mov	a,#0xFF
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:77: SYST_CSR = 0x05; // Bit 0: ENABLE, BIT 1: TICKINT, BIT 2:CLKSOURCE
	mov	dptr,#0xE010
	mov	b,#0x00
	mov	a,#0x05
	lcall	__gptrput
	inc	dptr
	clr	a
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:78: for(i=0; i<n; i++) // Measure the time of 'n' periods
	mov	r4,#0x00
	mov	r5,#0x00
L003021?:
	clr	c
	mov	a,r4
	subb	a,r2
	mov	a,r5
	xrl	a,#0x80
	mov	b,r3
	xrl	b,#0x80
	subb	a,b
	jnc	L003024?
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:80: while (PIN_PERIOD!=0) // Wait for square wave to be 0
L003013?:
	mov	dptr,#0x0001
	mov	b,#0x00
	lcall	__gptrget
	jz	L003018?
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:82: if(SYST_CSR & BIT16) return 0;
	mov	dptr,#0xE010
	mov	b,#0x00
	lcall	__gptrget
	inc	dptr
	lcall	__gptrget
	clr	a
	mov	r6,a
	mov	r7,a
	orl	a,r6
	jz	L003013?
	mov	dptr,#(0x00&0x00ff)
	clr	a
	mov	b,a
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:84: while (PIN_PERIOD==0) // Wait for square wave to be 1
	ret
L003018?:
	mov	dptr,#0x0001
	mov	b,#0x00
	lcall	__gptrget
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:86: if(SYST_CSR & BIT16) return 0;
	jnz	L003023?
	mov	dptr,#0xE010
	mov	b,a
	lcall	__gptrget
	inc	dptr
	lcall	__gptrget
	clr	a
	mov	r6,a
	mov	r7,a
	orl	a,r6
	jz	L003018?
	mov	dptr,#(0x00&0x00ff)
	clr	a
	mov	b,a
	ret
L003023?:
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:78: for(i=0; i<n; i++) // Measure the time of 'n' periods
	inc	r4
	cjne	r4,#0x00,L003021?
	inc	r5
	sjmp	L003021?
L003024?:
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:89: SYST_CSR = 0x00; // Disable Systick counter
	mov	dptr,#0xE010
	clr	a
	mov	b,a
	lcall	__gptrput
	inc	dptr
	clr	a
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:91: return 0x1000000-SYST_CVR;
	mov	dptr,#0xE018
	mov	b,#0x00
	lcall	__gptrget
	mov	r2,a
	inc	dptr
	lcall	__gptrget
	mov	r3,a
	clr	a
	mov	r4,a
	mov	r5,a
	clr	c
	subb	a,r2
	mov	r2,a
	clr	a
	subb	a,r3
	mov	r3,a
	clr	a
	subb	a,r4
	mov	r4,a
	mov	a,#0x01
	subb	a,r5
	mov	dpl,r2
	mov	dph,r3
	mov	b,r4
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'ConfigPins'
;------------------------------------------------------------
;------------------------------------------------------------
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:95: void ConfigPins(void)
;	-----------------------------------------
;	 function ConfigPins
;	-----------------------------------------
_ConfigPins:
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:98: SWM_PINENABLE0 |= BIT4; // Disable SWCLK
	mov	dptr,#0xC1C0
	mov	b,#0x00
	lcall	__gptrget
	mov	r2,a
	inc	dptr
	lcall	__gptrget
	mov	r3,a
	orl	ar2,#0x10
	mov	dptr,#0xC1C0
	mov	b,#0x00
	mov	a,r2
	lcall	__gptrput
	inc	dptr
	mov	a,r3
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:99: SWM_PINENABLE0 |= BIT5; // Disable SWDIO
	mov	dptr,#0xC1C0
	mov	b,#0x00
	lcall	__gptrget
	mov	r2,a
	inc	dptr
	lcall	__gptrget
	mov	r3,a
	orl	ar2,#0x20
	mov	dptr,#0xC1C0
	mov	b,#0x00
	mov	a,r2
	lcall	__gptrput
	inc	dptr
	mov	a,r3
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:102: GPIO_DIR0 |= BIT17; // Used for LCD_RS  Pin 2 of TSSOP20 package.
	mov	dptr,#0x2000
	mov	b,#0x00
	lcall	__gptrget
	mov	r2,a
	inc	dptr
	lcall	__gptrget
	mov	r3,a
	mov	dptr,#0x2000
	mov	b,#0x00
	mov	a,r2
	lcall	__gptrput
	inc	dptr
	mov	a,r3
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:103: GPIO_DIR0 |= BIT13; // Used for LCD_E.  Pin 3 of TSSOP20 package.
	mov	dptr,#0x2000
	mov	b,#0x00
	lcall	__gptrget
	mov	r2,a
	inc	dptr
	lcall	__gptrget
	mov	r3,a
	orl	ar3,#0x20
	mov	dptr,#0x2000
	mov	b,#0x00
	mov	a,r2
	lcall	__gptrput
	inc	dptr
	mov	a,r3
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:104: GPIO_DIR0 |= BIT3;  // Used for LCD_D4. Pin 7 of TSSOP20 package.
	mov	dptr,#0x2000
	mov	b,#0x00
	lcall	__gptrget
	mov	r2,a
	inc	dptr
	lcall	__gptrget
	mov	r3,a
	orl	ar2,#0x08
	mov	dptr,#0x2000
	mov	b,#0x00
	mov	a,r2
	lcall	__gptrput
	inc	dptr
	mov	a,r3
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:105: GPIO_DIR0 |= BIT2;  // Used for LCD_D5. Pin 8 of TSSOP20 package.
	mov	dptr,#0x2000
	mov	b,#0x00
	lcall	__gptrget
	mov	r2,a
	inc	dptr
	lcall	__gptrget
	mov	r3,a
	orl	ar2,#0x04
	mov	dptr,#0x2000
	mov	b,#0x00
	mov	a,r2
	lcall	__gptrput
	inc	dptr
	mov	a,r3
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:106: GPIO_DIR0 |= BIT11; // Used for LCD_D6. Pin 9 of TSSOP20 package. WARNING: NEEDS PULL-UP Resistor to VDD.
	mov	dptr,#0x2000
	mov	b,#0x00
	lcall	__gptrget
	mov	r2,a
	inc	dptr
	lcall	__gptrget
	mov	r3,a
	orl	ar3,#0x08
	mov	dptr,#0x2000
	mov	b,#0x00
	mov	a,r2
	lcall	__gptrput
	inc	dptr
	mov	a,r3
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:107: GPIO_DIR0 |= BIT10; // Used for LCD_D7. Pin 10 of TSSOP20 package. WARNING: NEEDS PULL-UP Resistor to VDD.
	mov	dptr,#0x2000
	mov	b,#0x00
	lcall	__gptrget
	mov	r2,a
	inc	dptr
	lcall	__gptrget
	mov	r3,a
	orl	ar3,#0x04
	mov	dptr,#0x2000
	mov	b,#0x00
	mov	a,r2
	lcall	__gptrput
	inc	dptr
	mov	a,r3
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:109: GPIO_DIR0 &= ~(BIT1); // Configure PIO0_1 as input.
	mov	dptr,#0x2000
	mov	b,#0x00
	lcall	__gptrget
	mov	r2,a
	inc	dptr
	lcall	__gptrget
	mov	r3,a
	anl	ar2,#0xFD
	mov	dptr,#0x2000
	mov	b,#0x00
	mov	a,r2
	lcall	__gptrput
	inc	dptr
	mov	a,r3
	ljmp	__gptrput
;------------------------------------------------------------
;Allocation info for local variables in function 'main'
;------------------------------------------------------------
;buff                      Allocated with name '_main_buff_1_30'
;reload                    Allocated with name '_main_reload_1_30'
;count                     Allocated to registers r2 r3 r4 r5 
;T                         Allocated to registers r6 r7 r0 r1 
;f                         Allocated to registers r6 r7 r0 r1 
;------------------------------------------------------------
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:113: void main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:122: initUART(115200);
	mov	dptr,#0xC200
	lcall	_initUART
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:124: ConfigPins();	
	lcall	_ConfigPins
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:125: LCD_4BIT();
	lcall	_LCD_4BIT
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:128: eputs("\n"); // First dummy transmission to initialize all the transmitter functions
	mov	dptr,#__str_0
	mov	b,#0x80
	lcall	_eputs
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:129: waitms(1000); // Wait for putty to start
	mov	dptr,#0x03E8
	lcall	_waitms
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:130: eputs("4-bit mode LCD test using the LPC824.\r\n");
	mov	dptr,#__str_1
	mov	b,#0x80
	lcall	_eputs
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:133: LCDprint("LCD 4-bit test:", 1, 1);
	mov	_LCDprint_PARM_2,#0x01
	mov	_LCDprint_PARM_3,#0x01
	mov	dptr,#__str_2
	mov	b,#0x80
	lcall	_LCDprint
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:134: LCDprint("Hello, World!", 2, 1);
	mov	_LCDprint_PARM_2,#0x02
	mov	_LCDprint_PARM_3,#0x01
	mov	dptr,#__str_3
	mov	b,#0x80
	lcall	_LCDprint
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:138: LCD_4BIT();
	lcall	_LCD_4BIT
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:140: while(1)
L005005?:
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:142: count=GetPeriod(100);
	mov	dptr,#0x0064
	lcall	_GetPeriod
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
	mov	r5,a
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:143: if(count>0)
	clr	c
	clr	a
	subb	a,r2
	clr	a
	subb	a,r3
	clr	a
	subb	a,r4
	clr	a
	xrl	a,#0x80
	mov	b,r5
	xrl	b,#0x80
	subb	a,b
	jc	L005011?
	ljmp	L005002?
L005011?:
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:145: T=count/(F_CPU*100.0);
	mov	dpl,r2
	mov	dph,r3
	mov	b,r4
	mov	a,r5
	push	ar2
	push	ar3
	push	ar4
	push	ar5
	lcall	___slong2fs
	mov	r6,dpl
	mov	r7,dph
	mov	r0,b
	mov	r1,a
	mov	a,#0x5E
	push	acc
	mov	a,#0xD0
	push	acc
	mov	a,#0x32
	push	acc
	mov	a,#0x4F
	push	acc
	mov	dpl,r6
	mov	dph,r7
	mov	b,r0
	mov	a,r1
	lcall	___fsdiv
	mov	r6,dpl
	mov	r7,dph
	mov	r0,b
	mov	r1,a
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:146: f=1/T;
	push	ar6
	push	ar7
	push	ar0
	push	ar1
	mov	dptr,#0x0000
	mov	b,#0x80
	mov	a,#0x3F
	lcall	___fsdiv
	mov	r6,dpl
	mov	r7,dph
	mov	r0,b
	mov	r1,a
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:147: eputs("f=");
	mov	dptr,#__str_4
	mov	b,#0x80
	push	ar6
	push	ar7
	push	ar0
	push	ar1
	lcall	_eputs
	pop	ar1
	pop	ar0
	pop	ar7
	pop	ar6
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:148: PrintNumber(f, 10, 7);
	mov	dpl,r6
	mov	dph,r7
	mov	b,r0
	mov	a,r1
	lcall	___fs2sint
	mov	_PrintNumber_PARM_2,#0x0A
	clr	a
	mov	(_PrintNumber_PARM_2 + 1),a
	mov	_PrintNumber_PARM_3,#0x07
	clr	a
	mov	(_PrintNumber_PARM_3 + 1),a
	lcall	_PrintNumber
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:150: eputs("Hz, count=");
	mov	dptr,#__str_5
	mov	b,#0x80
	lcall	_eputs
	pop	ar5
	pop	ar4
	pop	ar3
	pop	ar2
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:151: PrintNumber(count, 10, 6);
	mov	dpl,r2
	mov	dph,r3
	mov	_PrintNumber_PARM_2,#0x0A
	clr	a
	mov	(_PrintNumber_PARM_2 + 1),a
	mov	_PrintNumber_PARM_3,#0x06
	clr	a
	mov	(_PrintNumber_PARM_3 + 1),a
	lcall	_PrintNumber
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:153: eputs("\r");
	mov	dptr,#__str_6
	mov	b,#0x80
	lcall	_eputs
	sjmp	L005003?
L005002?:
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:157: eputs("NO SIGNAL                     \r");
	mov	dptr,#__str_7
	mov	b,#0x80
	lcall	_eputs
L005003?:
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\main_runfile.c:159: waitms(200);
	mov	dptr,#0x00C8
	lcall	_waitms
	ljmp	L005005?
	rseg R_CSEG

	rseg R_XINIT

	rseg R_CONST
__str_0:
	db 0x0A
	db 0x00
__str_1:
	db '4-bit mode LCD test using the LPC824.'
	db 0x0D
	db 0x0A
	db 0x00
__str_2:
	db 'LCD 4-bit test:'
	db 0x00
__str_3:
	db 'Hello, World!'
	db 0x00
__str_4:
	db 'f='
	db 0x00
__str_5:
	db 'Hz, count='
	db 0x00
__str_6:
	db 0x0D
	db 0x00
__str_7:
	db 'NO SIGNAL                     '
	db 0x0D
	db 0x00

	CSEG

end
