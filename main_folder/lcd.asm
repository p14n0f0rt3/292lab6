;--------------------------------------------------------
; File Created by C51
; Version 1.0.0 #1170 (Feb 16 2022) (MSVC)
; This file was generated Fri Mar 08 17:12:48 2024
;--------------------------------------------------------
$name lcd
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
	public _LCDprint_PARM_3
	public _LCDprint_PARM_2
	public _Delay_us
	public _waitms
	public _LCD_pulse
	public _LCD_byte
	public _WriteData
	public _WriteCommand
	public _LCD_4BIT
	public _LCDprint
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
_LCDprint_PARM_2:
	ds 1
_LCDprint_PARM_3:
	ds 1
;--------------------------------------------------------
; overlayable items in internal ram 
;--------------------------------------------------------
	rseg R_OSEG
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
;Allocation info for local variables in function 'Delay_us'
;------------------------------------------------------------
;us                        Allocated to registers r2 
;------------------------------------------------------------
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:6: void Delay_us(unsigned char us)
;	-----------------------------------------
;	 function Delay_us
;	-----------------------------------------
_Delay_us:
	using	0
	mov	r2,dpl
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:9: SYST_RVR = (F_CPU/(1000000L/us)) - 1;  // set reload register, counter rolls over from zero, hence -1
	mov	__divslong_PARM_2,r2
	mov	(__divslong_PARM_2 + 1),#0x00
	mov	(__divslong_PARM_2 + 2),#0x00
	mov	(__divslong_PARM_2 + 3),#0x00
	mov	dptr,#0x4240
	mov	b,#0x0F
	clr	a
	lcall	__divslong
	mov	__divslong_PARM_2,dpl
	mov	(__divslong_PARM_2 + 1),dph
	mov	(__divslong_PARM_2 + 2),b
	mov	(__divslong_PARM_2 + 3),a
	mov	dptr,#0xC380
	mov	b,#0xC9
	mov	a,#0x01
	lcall	__divslong
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
	mov	r5,a
	dec	r2
	cjne	r2,#0xff,L002008?
	dec	r3
	cjne	r3,#0xff,L002008?
	dec	r4
	cjne	r4,#0xff,L002008?
	dec	r5
L002008?:
	mov	dptr,#0xE014
	mov	b,#0x00
	mov	a,r2
	lcall	__gptrput
	inc	dptr
	mov	a,r3
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:10: SYST_CVR = 0; // load the SysTick counter
	mov	dptr,#0xE018
	clr	a
	mov	b,a
	lcall	__gptrput
	inc	dptr
	clr	a
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:11: SYST_CSR = 0x05; // Bit 0: ENABLE, BIT 1: TICKINT, BIT 2:CLKSOURCE
	mov	dptr,#0xE010
	mov	b,#0x00
	mov	a,#0x05
	lcall	__gptrput
	inc	dptr
	clr	a
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:12: while((SYST_CSR & BIT16)==0); // Bit 16 is the COUNTFLAG.  True when counter rolls over from zero.
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
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:13: SYST_CSR = 0x00; // Disable Systick counter
	mov	dptr,#0xE010
	clr	a
	mov	b,a
	lcall	__gptrput
	inc	dptr
	clr	a
	ljmp	__gptrput
;------------------------------------------------------------
;Allocation info for local variables in function 'waitms'
;------------------------------------------------------------
;ms                        Allocated to registers r2 r3 
;j                         Allocated to registers r4 r5 
;k                         Allocated to registers r6 
;------------------------------------------------------------
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:16: void waitms (unsigned int ms)
;	-----------------------------------------
;	 function waitms
;	-----------------------------------------
_waitms:
	mov	r2,dpl
	mov	r3,dph
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:20: for(j=0; j<ms; j++)
	mov	r4,#0x00
	mov	r5,#0x00
L003005?:
	clr	c
	mov	a,r4
	subb	a,r2
	mov	a,r5
	subb	a,r3
	jnc	L003009?
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:21: for (k=0; k<4; k++) Delay_us(250);
	mov	r6,#0x00
L003001?:
	cjne	r6,#0x04,L003018?
L003018?:
	jnc	L003007?
	mov	dpl,#0xFA
	push	ar2
	push	ar3
	push	ar4
	push	ar5
	push	ar6
	lcall	_Delay_us
	pop	ar6
	pop	ar5
	pop	ar4
	pop	ar3
	pop	ar2
	inc	r6
	sjmp	L003001?
L003007?:
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:20: for(j=0; j<ms; j++)
	inc	r4
	cjne	r4,#0x00,L003005?
	inc	r5
	sjmp	L003005?
L003009?:
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'LCD_pulse'
;------------------------------------------------------------
;------------------------------------------------------------
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:24: void LCD_pulse (void)
;	-----------------------------------------
;	 function LCD_pulse
;	-----------------------------------------
_LCD_pulse:
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:26: LCD_E_1;
	mov	dptr,#(0x0D&0x00ff)
	clr	a
	mov	b,a
	mov	a,#0x01
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:27: Delay_us(40);
	mov	dpl,#0x28
	lcall	_Delay_us
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:28: LCD_E_0;
	mov	dptr,#0x000D
	clr	a
	mov	b,a
	ljmp	__gptrput
;------------------------------------------------------------
;Allocation info for local variables in function 'LCD_byte'
;------------------------------------------------------------
;x                         Allocated to registers r2 
;------------------------------------------------------------
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:31: void LCD_byte (unsigned char x)
;	-----------------------------------------
;	 function LCD_byte
;	-----------------------------------------
_LCD_byte:
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:34: if(x&0x80) LCD_D7_1; else LCD_D7_0;
	mov	a,dpl
	mov	r2,a
	jnb	acc.7,L005002?
	mov	dptr,#(0x0A&0x00ff)
	clr	a
	mov	b,a
	mov	a,#0x01
	lcall	__gptrput
	sjmp	L005003?
L005002?:
	mov	dptr,#0x000A
	clr	a
	mov	b,a
	lcall	__gptrput
L005003?:
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:35: if(x&0x40) LCD_D6_1; else LCD_D6_0;
	mov	a,r2
	jnb	acc.6,L005005?
	mov	dptr,#(0x0B&0x00ff)
	clr	a
	mov	b,a
	mov	a,#0x01
	lcall	__gptrput
	sjmp	L005006?
L005005?:
	mov	dptr,#0x000B
	clr	a
	mov	b,a
	lcall	__gptrput
L005006?:
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:36: if(x&0x20) LCD_D5_1; else LCD_D5_0;
	mov	a,r2
	jnb	acc.5,L005008?
	mov	dptr,#(0x02&0x00ff)
	clr	a
	mov	b,a
	mov	a,#0x01
	lcall	__gptrput
	sjmp	L005009?
L005008?:
	mov	dptr,#0x0002
	clr	a
	mov	b,a
	lcall	__gptrput
L005009?:
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:37: if(x&0x10) LCD_D4_1; else LCD_D4_0;
	mov	a,r2
	jnb	acc.4,L005011?
	mov	dptr,#(0x03&0x00ff)
	clr	a
	mov	b,a
	mov	a,#0x01
	lcall	__gptrput
	sjmp	L005012?
L005011?:
	mov	dptr,#0x0003
	clr	a
	mov	b,a
	lcall	__gptrput
L005012?:
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:38: LCD_pulse();
	push	ar2
	lcall	_LCD_pulse
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:39: Delay_us(40);
	mov	dpl,#0x28
	lcall	_Delay_us
	pop	ar2
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:41: if(x&0x08) LCD_D7_1; else LCD_D7_0;
	mov	a,r2
	jnb	acc.3,L005014?
	mov	dptr,#(0x0A&0x00ff)
	clr	a
	mov	b,a
	mov	a,#0x01
	lcall	__gptrput
	sjmp	L005015?
L005014?:
	mov	dptr,#0x000A
	clr	a
	mov	b,a
	lcall	__gptrput
L005015?:
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:42: if(x&0x04) LCD_D6_1; else LCD_D6_0;
	mov	a,r2
	jnb	acc.2,L005017?
	mov	dptr,#(0x0B&0x00ff)
	clr	a
	mov	b,a
	mov	a,#0x01
	lcall	__gptrput
	sjmp	L005018?
L005017?:
	mov	dptr,#0x000B
	clr	a
	mov	b,a
	lcall	__gptrput
L005018?:
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:43: if(x&0x02) LCD_D5_1; else LCD_D5_0;
	mov	a,r2
	jnb	acc.1,L005020?
	mov	dptr,#(0x02&0x00ff)
	clr	a
	mov	b,a
	mov	a,#0x01
	lcall	__gptrput
	sjmp	L005021?
L005020?:
	mov	dptr,#0x0002
	clr	a
	mov	b,a
	lcall	__gptrput
L005021?:
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:44: if(x&0x01) LCD_D4_1; else LCD_D4_0;
	mov	a,r2
	jnb	acc.0,L005023?
	mov	dptr,#(0x03&0x00ff)
	clr	a
	mov	b,a
	mov	a,#0x01
	lcall	__gptrput
	sjmp	L005024?
L005023?:
	mov	dptr,#0x0003
	clr	a
	mov	b,a
	lcall	__gptrput
L005024?:
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:45: LCD_pulse();
	ljmp	_LCD_pulse
;------------------------------------------------------------
;Allocation info for local variables in function 'WriteData'
;------------------------------------------------------------
;x                         Allocated to registers r2 
;------------------------------------------------------------
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:48: void WriteData (unsigned char x)
;	-----------------------------------------
;	 function WriteData
;	-----------------------------------------
_WriteData:
	mov	r2,dpl
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:50: LCD_RS_1;
	mov	dptr,#(0x11&0x00ff)
	clr	a
	mov	b,a
	mov	a,#0x01
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:51: LCD_byte(x);
	mov	dpl,r2
	lcall	_LCD_byte
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:52: waitms(2);
	mov	dptr,#0x0002
	ljmp	_waitms
;------------------------------------------------------------
;Allocation info for local variables in function 'WriteCommand'
;------------------------------------------------------------
;x                         Allocated to registers r2 
;------------------------------------------------------------
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:55: void WriteCommand (unsigned char x)
;	-----------------------------------------
;	 function WriteCommand
;	-----------------------------------------
_WriteCommand:
	mov	r2,dpl
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:57: LCD_RS_0;
	mov	dptr,#0x0011
	clr	a
	mov	b,a
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:58: LCD_byte(x);
	mov	dpl,r2
	lcall	_LCD_byte
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:59: waitms(5);
	mov	dptr,#0x0005
	ljmp	_waitms
;------------------------------------------------------------
;Allocation info for local variables in function 'LCD_4BIT'
;------------------------------------------------------------
;------------------------------------------------------------
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:62: void LCD_4BIT (void)
;	-----------------------------------------
;	 function LCD_4BIT
;	-----------------------------------------
_LCD_4BIT:
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:64: LCD_E_0; // Resting state of LCD's enable is zero
	mov	dptr,#0x000D
	clr	a
	mov	b,a
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:66: waitms(20);
	mov	dptr,#0x0014
	lcall	_waitms
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:68: WriteCommand(0x33);
	mov	dpl,#0x33
	lcall	_WriteCommand
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:69: WriteCommand(0x33);
	mov	dpl,#0x33
	lcall	_WriteCommand
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:70: WriteCommand(0x32); // Change to 4-bit mode
	mov	dpl,#0x32
	lcall	_WriteCommand
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:73: WriteCommand(0x28);
	mov	dpl,#0x28
	lcall	_WriteCommand
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:74: WriteCommand(0x0c);
	mov	dpl,#0x0C
	lcall	_WriteCommand
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:75: WriteCommand(0x01); // Clear screen command (takes some time)
	mov	dpl,#0x01
	lcall	_WriteCommand
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:76: waitms(20); // Wait for clear screen command to finsih.
	mov	dptr,#0x0014
	ljmp	_waitms
;------------------------------------------------------------
;Allocation info for local variables in function 'LCDprint'
;------------------------------------------------------------
;line                      Allocated with name '_LCDprint_PARM_2'
;clear                     Allocated with name '_LCDprint_PARM_3'
;string                    Allocated to registers r2 r3 r4 
;j                         Allocated to registers r5 r6 
;------------------------------------------------------------
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:79: void LCDprint(char * string, unsigned char line, unsigned char clear)
;	-----------------------------------------
;	 function LCDprint
;	-----------------------------------------
_LCDprint:
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:83: WriteCommand(line==2?0xc0:0x80);
	mov	a,#0x02
	cjne	a,_LCDprint_PARM_2,L009013?
	mov	r5,#0xC0
	sjmp	L009014?
L009013?:
	mov	r5,#0x80
L009014?:
	mov	dpl,r5
	push	ar2
	push	ar3
	push	ar4
	lcall	_WriteCommand
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:84: waitms(5);
	mov	dptr,#0x0005
	lcall	_waitms
	pop	ar4
	pop	ar3
	pop	ar2
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:85: for(j=0; string[j]!=0; j++)	WriteData(string[j]);// Write the message
	mov	r5,#0x00
	mov	r6,#0x00
L009003?:
	mov	a,r5
	add	a,r2
	mov	r7,a
	mov	a,r6
	addc	a,r3
	mov	r0,a
	mov	ar1,r4
	mov	dpl,r7
	mov	dph,r0
	mov	b,r1
	lcall	__gptrget
	mov	r7,a
	jz	L009006?
	mov	dpl,r7
	push	ar2
	push	ar3
	push	ar4
	push	ar5
	push	ar6
	lcall	_WriteData
	pop	ar6
	pop	ar5
	pop	ar4
	pop	ar3
	pop	ar2
	inc	r5
	cjne	r5,#0x00,L009003?
	inc	r6
	sjmp	L009003?
L009006?:
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:86: if(clear) for(; j<CHARS_PER_LINE; j++) WriteData(' '); // Clear the rest of the line
	mov	a,_LCDprint_PARM_3
	jz	L009011?
	mov	ar2,r5
	mov	ar3,r6
L009007?:
	clr	c
	mov	a,r2
	subb	a,#0x10
	mov	a,r3
	xrl	a,#0x80
	subb	a,#0x80
	jnc	L009011?
	mov	dpl,#0x20
	push	ar2
	push	ar3
	lcall	_WriteData
	pop	ar3
	pop	ar2
	inc	r2
	cjne	r2,#0x00,L009007?
	inc	r3
	sjmp	L009007?
L009011?:
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'main'
;------------------------------------------------------------
;------------------------------------------------------------
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:89: int main(void) {
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	C:\Users\keybo\Documents\GitHub\292lab6\main_folder\lcd.c:90: return;
	ret
	rseg R_CSEG

	rseg R_XINIT

	rseg R_CONST

	CSEG

end
