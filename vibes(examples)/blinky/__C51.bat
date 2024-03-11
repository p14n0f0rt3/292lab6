@echo off
::This file was created automatically by CrossIDE to compile with C51.
C:
cd "\Users\keybo\Documents\GitHub\292lab6\vibes(examples)\blinky\"
"C:\Users\keybo\Documents\GitHub\292lab5\call51\Bin\c51.exe" --use-stdout  "C:\Users\keybo\Documents\GitHub\292lab6\vibes(examples)\blinky\blinky.c"
if not exist hex2mif.exe goto done
if exist blinky.ihx hex2mif blinky.ihx
if exist blinky.hex hex2mif blinky.hex
:done
echo done
echo Crosside_Action Set_Hex_File C:\Users\keybo\Documents\GitHub\292lab6\vibes(examples)\blinky\blinky.hex
