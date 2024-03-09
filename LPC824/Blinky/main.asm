;--------------------------------------------------------
; File Created by C51
; Version 1.0.0 #1170 (Feb 16 2022) (MSVC)
; This file was generated Fri Mar 08 17:36:22 2024
;--------------------------------------------------------
$name main
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
	public _delay
	public _ConfigPins
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
;Allocation info for local variables in function 'ConfigPins'
;------------------------------------------------------------
;------------------------------------------------------------
;	C:\Users\keybo\Documents\GitHub\292lab6\LPC824\Blinky\main.c:25: void ConfigPins()
;	-----------------------------------------
;	 function ConfigPins
;	-----------------------------------------
_ConfigPins:
	using	0
;	C:\Users\keybo\Documents\GitHub\292lab6\LPC824\Blinky\main.c:27: GPIO_DIR0 |= BIT14; 
	mov	dptr,#0x2000
	mov	b,#0x00
	lcall	__gptrget
	mov	r2,a
	inc	dptr
	lcall	__gptrget
	mov	r3,a
	orl	ar3,#0x40
	mov	dptr,#0x2000
	mov	b,#0x00
	mov	a,r2
	lcall	__gptrput
	inc	dptr
	mov	a,r3
	ljmp	__gptrput
;------------------------------------------------------------
;Allocation info for local variables in function 'delay'
;------------------------------------------------------------
;len                       Allocated to registers r2 r3 
;------------------------------------------------------------
;	C:\Users\keybo\Documents\GitHub\292lab6\LPC824\Blinky\main.c:30: void delay(int len)
;	-----------------------------------------
;	 function delay
;	-----------------------------------------
_delay:
	mov	r2,dpl
	mov	r3,dph
;	C:\Users\keybo\Documents\GitHub\292lab6\LPC824\Blinky\main.c:32: while(len--);
L003001?:
	mov	ar4,r2
	mov	ar5,r3
	dec	r2
	cjne	r2,#0xff,L003008?
	dec	r3
L003008?:
	mov	a,r4
	orl	a,r5
	jnz	L003001?
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'main'
;------------------------------------------------------------
;------------------------------------------------------------
;	C:\Users\keybo\Documents\GitHub\292lab6\LPC824\Blinky\main.c:35: void main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	C:\Users\keybo\Documents\GitHub\292lab6\LPC824\Blinky\main.c:37: ConfigPins();
	lcall	_ConfigPins
;	C:\Users\keybo\Documents\GitHub\292lab6\LPC824\Blinky\main.c:40: SYSCON_CLKOUTSEL = 3; // select main clock as clock out source
	mov	dptr,#0x80E0
	mov	b,#0x04
	mov	a,#0x03
	lcall	__gptrput
	inc	dptr
	clr	a
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\LPC824\Blinky\main.c:41: SYSCON_CLKOUTDIV = 100; // divide down so easier to measure
	mov	dptr,#0x80E8
	mov	b,#0x04
	mov	a,#0x64
	lcall	__gptrput
	inc	dptr
	clr	a
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\LPC824\Blinky\main.c:42: SYSCON_CLKOUTUEN = 1; // update clockout source
	mov	dptr,#0x80E4
	mov	b,#0x04
	mov	a,#0x01
	lcall	__gptrput
	inc	dptr
	clr	a
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\LPC824\Blinky\main.c:43: SWM_PINASSIGN11 = (23 << 16); // route clock out on pin 1 (GPIO0_23)
	mov	dptr,#0xC02C
	clr	a
	mov	b,a
	lcall	__gptrput
	inc	dptr
	clr	a
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\LPC824\Blinky\main.c:44: while(1)	
L004002?:
;	C:\Users\keybo\Documents\GitHub\292lab6\LPC824\Blinky\main.c:46: GPIO_B14 = 1;
	mov	dptr,#(0x0E&0x00ff)
	clr	a
	mov	b,a
	mov	a,#0x01
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\LPC824\Blinky\main.c:47: delay(2000000);
	mov	dptr,#0x8480
	lcall	_delay
;	C:\Users\keybo\Documents\GitHub\292lab6\LPC824\Blinky\main.c:48: GPIO_B14 = 0; 
	mov	dptr,#0x000E
	clr	a
	mov	b,a
	lcall	__gptrput
;	C:\Users\keybo\Documents\GitHub\292lab6\LPC824\Blinky\main.c:49: delay(2000000);
	mov	dptr,#0x8480
	lcall	_delay
	sjmp	L004002?
	rseg R_CSEG

	rseg R_XINIT

	rseg R_CONST

	CSEG

end
