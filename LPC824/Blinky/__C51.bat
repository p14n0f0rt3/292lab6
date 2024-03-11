@echo off
::This file was created automatically by CrossIDE to compile with C51.
C:
cd "\Users\keybo\Documents\GitHub\292lab6\LPC824\Blinky\"
"C:\Users\keybo\Documents\GitHub\292lab5\call51\Bin\c51.exe" --use-stdout  "C:\Users\keybo\Documents\GitHub\292lab6\LPC824\Blinky\main.c"
if not exist hex2mif.exe goto done
if exist main.ihx hex2mif main.ihx
if exist main.hex hex2mif main.hex
:done
echo done
echo Crosside_Action Set_Hex_File C:\Users\keybo\Documents\GitHub\292lab6\LPC824\Blinky\main.hex
