@echo off
::This file was created automatically by CrossIDE to compile with C51.
C:
cd "\Users\keybo\Documents\GitHub\292lab6\main_folder\"
"C:\Users\keybo\Documents\GitHub\292lab5\call51\Bin\c51.exe" --use-stdout  "C:\Users\keybo\Documents\GitHub\292lab6\main_folder\serial.c"
if not exist hex2mif.exe goto done
if exist serial.ihx hex2mif serial.ihx
if exist serial.hex hex2mif serial.hex
:done
echo done
echo Crosside_Action Set_Hex_File C:\Users\keybo\Documents\GitHub\292lab6\main_folder\serial.hex
