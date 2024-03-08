SHELL=cmd
CC=arm-none-eabi-gcc
AS=arm-none-eabi-as
LD=arm-none-eabi-ld

CCFLAGS=-mcpu=cortex-m0 -mthumb -g
 
# Search for the path of the right libraries.  Works only on Windows.
GCCPATH=$(subst \bin\arm-none-eabi-gcc.exe,\,$(shell where $(CC)))
LIBPATH1=$(subst \libgcc.a,,$(shell dir /s /b "$(GCCPATH)*libgcc.a" | find "v6-m"))
LIBPATH2=$(subst \libc_nano.a,,$(shell dir /s /b "$(GCCPATH)*libc_nano.a" | find "v6-m"))
LIBSPEC=-L"$(LIBPATH1)" -L"$(LIBPATH2)"

OBJS= init.o main.o 

main.elf : $(OBJS)
	$(LD) $(OBJS) $(LIBSPEC) -lgcc -T lpc824_linker_script.ld --cref -Map main.map -o main.elf
	arm-none-eabi-objcopy -O ihex main.elf main.hex
	@echo Success!

main.o: main.c
	$(CC) -c $(CCFLAGS) main.c -o main.o

init.o: init.c
	$(CC) -c $(CCFLAGS) init.c -o init.o

clean: 
	@del $(OBJS) 2>NUL
	@del main.elf main.hex main.map 2>NUL

FlashLoad:
	@taskkill /f /im putty.exe /t /fi "status eq running" > NUL
	lpcprog.exe main.hex -ft230 115200 12000000	

dummy: main.map lpc824_linker_script.ld main.hex
	@echo :-)

explorer:
	@explorer .
