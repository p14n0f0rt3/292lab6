@echo off
::This file was created automatically by CrossIDE to compile with C51.
C:
cd "\Users\keybo\Documents\GitHub\292lab6\main-coded\"
"C:\Users\keybo\Documents\GitHub\292lab5\call51\Bin\c51.exe" --use-stdout  "C:\Users\keybo\Documents\GitHub\292lab6\main-coded\lcd.c"
if not exist hex2mif.exe goto done
if exist lcd.ihx hex2mif lcd.ihx
if exist lcd.hex hex2mif lcd.hex
:done
echo done
echo Crosside_Action Set_Hex_File C:\Users\keybo\Documents\GitHub\292lab6\main-coded\lcd.hex
