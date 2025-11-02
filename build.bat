@echo off
if not exist build mkdir build >nul 2>&1
gcc -O3 -Wall -Wextra -std=c11 -o build\pa_part1.exe src\pa_part1.c
gcc -O3 -Wall -Wextra -std=c11 -o build\pa_part2.exe src\pa_part2.c