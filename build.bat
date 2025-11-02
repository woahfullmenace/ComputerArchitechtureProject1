@echo off
if not exist build mkdir build >nul 2>&1
gcc -O3 -Wall -Wextra -std=c11 -o build\matmul.exe "src\progamming assignment part 1.c"
