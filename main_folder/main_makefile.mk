# Since we are compiling in windows, select 'cmd' as the default shell.  This
# is important because make will search the path for a linux/unix like shell
# and if it finds it will use it instead.  This is the case when cygwin is
# installed.  That results in commands like 'del' and echo that don't work.
SHELL=cmd
CC=arm-none-eabi-gcc # Specify the compiler to use
AS=arm-none-eabi-as # Specify the assembler to use
LD=arm-none-eabi-ld # Specity the linker to use
CCFLAGS=-mcpu=cortex-m0 -mthumb -g # Flags for C compilation

PORTN=$(shell type COMPORT.inc)

# Search for the path of the right libraries.  Works only on Windows.
GCCPATH=$(subst \bin\arm-none-eabi-gcc.exe,\,$(shell where $(CC)))
LIBPATH1=$(subst \libgcc.a,,$(shell dir /s /b "$(GCCPATH)*libgcc.a" | find "v6-m"))
LIBPATH2=$(subst \libc_nano.a,,$(shell dir /s /b "$(GCCPATH)*libc_nano.a" | find "v6-m"))
LIBSPEC=-L"$(LIBPATH1)" -L"$(LIBPATH2)"


# List the object files involved in this project
OBJS=main_runfile.o init.o lcd.o serial.o 

# The default 'target' (output) is main_runfile.elf and 'depends' on
# the object files listed in the 'OBJS' assignment above.
# These object files are linked together to create main_runfile.elf.
# The linked file is converted to hex using program objcopy.
main_runfile.elf : $(OBJS)
	$(LD) $(OBJS) $(LIBSPEC) -lgcc -T lpc824_linker_script.ld --cref -Map main_runfile.map -o main_runfile.elf
	arm-none-eabi-objcopy -O ihex main_runfile.elf main_runfile.hex
	@echo Success!
# The object file main_runfile.o depends on main_runfile.c. main_runfile.c is compiled
# to create main_runfile.o.
main_runfile.o: main_runfile.c 
	$(CC) -c $(CCFLAGS) main_runfile.c -o main_runfile.o

# The object file init.o depends on init.c.  init.c is
# compiled to create init.o
init.o: init.c 
	$(CC) -c $(CCFLAGS) init.c -o init.o

lcd.o: lcd.c 
	$(CC) -c $(CCFLAGS) lcd.c -o lcd.o
	
serial.o: serial.c lpc824.h serial.h
	$(CC) -c $(CCFLAGS) serial.c -o serial.o

	
# Target 'clean' is used to remove all object files and executables
# associated with this project
clean: 
	@del $(OBJS) 2>NUL
	@del main_runfile.elf main_runfile.hex main_runfile.map 2>NUL

LoadFlash:
	@taskkill /f /im putty.exe /t /fi "status eq running" > NUL
	lpcprog.exe main_runfile.hex -ft230 115200 12000000	
	cmd /c start putty -serial $(PORTN) -sercfg 115200,8,n,1,N

putty:
	@taskkill /f /im putty.exe /t /fi "status eq running" > NUL
	cmd /c start putty -serial $(PORTN) -sercfg 115200,8,n,1,N
	
explorer:
	@explorer .

dummy: main_runfile.map
	@echo Hello from 'dummy' target...



