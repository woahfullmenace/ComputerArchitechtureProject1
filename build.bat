@echo off
if not exist build mkdir build >nul 2>&1
if not exist logs mkdir logs >nul 2>&1
set "BUILD_LOG=logs\build_bat.log"
echo [%date% %time%] Build started >> "%BUILD_LOG%"

gcc -O3 -Wall -Wextra -std=c11 -o build\pa_part1.exe src\pa_part1.c
set "EC=%ERRORLEVEL%"
echo [%date% %time%] pa_part1.exe build exit=%EC% >> "%BUILD_LOG%"

gcc -O3 -Wall -Wextra -std=c11 -o build\pa_part2.exe src\pa_part2.c
set "EC=%ERRORLEVEL%"
echo [%date% %time%] pa_part2.exe build exit=%EC% >> "%BUILD_LOG%"

gcc -O3 -Wall -Wextra -std=c11 -o build\pa_part3.exe src\pa_part3.c
set "EC=%ERRORLEVEL%"
echo [%date% %time%] pa_part3.exe build exit=%EC% >> "%BUILD_LOG%"

gcc -O3 -Wall -Wextra -std=c11 -o build\pa_part4.exe src\pa_part4.c
set "EC=%ERRORLEVEL%"
echo [%date% %time%] pa_part4.exe build exit=%EC% >> "%BUILD_LOG%"

gcc -O3 -Wall -Wextra -std=c11 -o build\pa_part5.exe src\pa_part5.c
set "EC=%ERRORLEVEL%"
echo [%date% %time%] pa_part5.exe build exit=%EC% >> "%BUILD_LOG%"

echo [%date% %time%] Build finished >> "%BUILD_LOG%"
