CC=arm-none-eabi-gcc
AS=arm-none-eabi-as
LD=arm-none-eabi-ld
CCFLAGS=-mcpu=cortex-m0 -mthumb -g -lgcc

# Search for the path of libraries.
SHELL=cmd
GCCPATH=$(subst \bin\arm-none-eabi-gcc.exe,\,$(shell where $(CC)))
LIBPATH1=$(subst \libgcc.a,,$(shell dir /s /b "$(GCCPATH)*libgcc.a" | find "v6-m"))
LIBPATH2=$(subst \libc_nano.a,,$(shell dir /s /b "$(GCCPATH)*libc_nano.a" | find "v6-m"))
PORTN=$(shell type COMPORT.inc)

LIBSPEC=-L"$(LIBPATH1)" -L"$(LIBPATH2)"

OBJS=init.o main.o serial.o newlib_stubs.o

main.elf : $(OBJS)
	$(LD) $(OBJS) $(LIBSPEC) -lgcc -T lpc824_linker_script.ld --cref -Map main.map -o main.elf
	arm-none-eabi-objcopy -O ihex main.elf main.hex
	@echo Success!

main.o: main.c lpc824.h serial.h
	$(CC) -c $(CCFLAGS) main.c -o main.o

init.o: init.c lpc824.h serial.h
	$(CC) -c $(CCFLAGS) init.c -o init.o

serial.o: serial.c lpc824.h serial.h
	$(CC) -c $(CCFLAGS) serial.c -o serial.o
	
newlib_stubs.o: newlib_stubs.c lpc824.h serial.h
	$(CC) -c $(CCFLAGS) newlib_stubs.c -o newlib_stubs.o

clean: 
	@del $(OBJS)
	@del main.elf main.hex main.map


LoadFlash:
	@taskkill /f /im putty.exe /t /fi "status eq running" > NUL
	lpcprog.exe main.hex -ft230 115200 12000000	
	@cmd /c start putty -serial $(PORTN) -sercfg 115200,8,n,1,N

putty:
	@taskkill /f /im putty.exe /t /fi "status eq running" > NUL
	@cmd /c start putty -serial $(PORTN) -sercfg 115200,8,n,1,N
	
explorer:
	@explorer .

dummy: main.map main.hex lpc824_linker_script.ld
	@echo Hello from 'dummy' target...
