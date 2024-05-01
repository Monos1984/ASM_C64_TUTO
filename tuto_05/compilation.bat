@echo off
 
..\..\TMPx\TMPx.exe src\main.asm -o binaire\test.prg 
if exist binaire\*.rp9 erase binaire\*.rp9
pause 