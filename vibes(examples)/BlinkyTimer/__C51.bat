@echo off
::This file was created automatically by CrossIDE to compile with C51.
C:
cd "\Users\keybo\Documents\GitHub\292lab6\vibes(examples)\BlinkyTimer\"
"C:\Users\keybo\Documents\GitHub\292lab5\call51\Bin\c51.exe" --use-stdout  "C:\Users\keybo\Documents\GitHub\292lab6\vibes(examples)\BlinkyTimer\BlinkyTimer.c"
if not exist hex2mif.exe goto done
if exist BlinkyTimer.ihx hex2mif BlinkyTimer.ihx
if exist BlinkyTimer.hex hex2mif BlinkyTimer.hex
:done
echo done
echo Crosside_Action Set_Hex_File C:\Users\keybo\Documents\GitHub\292lab6\vibes(examples)\BlinkyTimer\BlinkyTimer.hex
