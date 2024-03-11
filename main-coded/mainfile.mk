SHELL=cmd
# Specify the compiler to use
CC= avr-gcc
# Specify the microcontroller
CPU=-mmcu=atmega328p
# C compiler options
COPT= -g -Os $(CPU)
# Object files to link
OBJS= main.o usart.o lcd.o

PORTN=$(shell type COMPORT.inc)


# Search for the path of the right libraries.  Works only on Windows.
GCCPATH=$(subst \bin\arm-none-eabi-gcc.exe,\,$(shell where $(CC)))
LIBPATH1=$(subst \libgcc.a,,$(shell dir /s /b "$(GCCPATH)*libgcc.a" | find "v6-m"))
LIBPATH2=$(subst \libc_nano.a,,$(shell dir /s /b "$(GCCPATH)*libc_nano.a" | find "v6-m"))
LIBSPEC=-L"$(LIBPATH1)" -L"$(LIBPATH2)"


# The default 'target' (output) is blinky.elf and 'depends' on
# the object files listed in the 'OBJS' assignment above.
# These object files are linked together to create Blinky.elf.
# The linked file is converted to hex using program aver-objcopy.
main.elf: $(OBJS)
	avr-gcc $(CPU) -Wl,-Map, main.map $(OBJS) -o main.elf
	avr-objcopy -j .text -j .data -O ihex main.elf main.hex
	@echo done!

main.o: main.c usart.h
	avr-gcc -g -Os -Wall -mmcu=atmega328p -c main.c

usart.o: usart.c usart.h
	avr-gcc -g -Os -Wall -mmcu=atmega328p -c usart.c

lcd.o: lcd.c usart.h LCD.h
	avr-gcc -g -Os -Wall -mmcu=atmega328p -c lcd.c

clean:
	@del *.hex *.elf *.o 2>nul

FlashLoad:
	@taskkill /f /im putty.exe /t /fi "status eq running" > NUL
	spi_atmega -p -v -crystal main.hex
	@cmd /c start putty.exe -serial $(PORTN) -sercfg 115200,8,n,1,N

putty:
	@taskkill /f /im putty.exe /t /fi "status eq running" > NUL
	@cmd /c start putty.exe -serial $(PORTN) -sercfg 115200,8,n,1,N

dummy: avr_printf.hex
	@echo Hello dummy!

explorer:
	cmd /c start explorer .