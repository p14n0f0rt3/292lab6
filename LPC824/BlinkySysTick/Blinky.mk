# Since we are compiling in windows, select 'cmd' as the default shell.  This
# is important because make will search the path for a linux/unix like shell
# and if it finds it will use it instead.  This is the case when cygwin is
# installed.  That results in commands like 'del' and echo that don't work.
SHELL=cmd
# Specify the compiler to use
CC=arm-none-eabi-gcc
# Specify the assembler to use
AS=arm-none-eabi-as
# Specity the linker to use
LD=arm-none-eabi-ld
# Flags for C compilation
CCFLAGS=-mcpu=cortex-m0 -mthumb -g
# Flags for linking
LDFLAGS=-T lpc824_linker_script.ld --cref
# List the object files involved in this project
OBJS=init.o	main.o 

# The default 'target' (output) is main.elf and 'depends' on
# the object files listed in the 'OBJS' assignment above.
# These object files are linked together to create main.elf.
# The linked file is converted to hex using program objcopy.
main.elf: $(OBJS)
	$(LD) $(OBJS) $(LDFLAGS) -Map main.map -o main.elf
	arm-none-eabi-objcopy -O ihex main.elf main.hex
	@echo Success!

# The object file main.o depends on main.c. main.c is compiled
# to create main.o.
main.o: main.c
	$(CC) -c $(CCFLAGS) main.c -o main.o

# The object file init.o depends on init.c.  init.c is
# compiled to create init.o
init.o: init.c
	$(CC) -c $(CCFLAGS) init.c -o init.o

# Target 'clean' is used to remove all object files and executables
# associated with this project
clean: 
	del $(OBJS)
	del *.elf
	del *.hex
	del *.map

# Target 'FlashLoad' is used to load the hex file to the microcontroller 
# using the flash loader.
FlashLoad:
	@taskkill /f /im putty.exe /t /fi "status eq running" > NUL
	lpcprog.exe main.hex -ft230 115200 12000000	

# Phony targets can be added to show useful files in the file list of
# CrossIDE or execute arbitrary programs:
dummy: lpc824_linker_script.ld main.hex
	@echo :-)

explorer:
	@explorer .
