@echo off
::This file was created automatically by CrossIDE to compile with C51.
C:
cd "\Users\keybo\Documents\GitHub\292lab6\LPC824\Blinky\"
"C:\Users\keybo\Documents\GitHub\292lab5\call51\Bin\c51.exe" --use-stdout  "C:\Users\keybo\Documents\GitHub\292lab6\LPC824\Blinky\init.c"
if not exist hex2mif.exe goto done
if exist init.ihx hex2mif init.ihx
if exist init.hex hex2mif init.hex
:done
echo done
echo Crosside_Action Set_Hex_File C:\Users\keybo\Documents\GitHub\292lab6\LPC824\Blinky\init.hex
