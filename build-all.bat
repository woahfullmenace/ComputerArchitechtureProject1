@echo off
setlocal enabledelayedexpansion

echo === Build All Parts (1, 2, 3) ===
if not exist build mkdir build >nul 2>&1

rem Prefer MSVC if available, otherwise use GCC
where cl >nul 2>&1
if %ERRORLEVEL%==0 (
  echo [cl] Building Part 1 -> build\pa_part1.exe
  cl /O2 /W4 /nologo /Fe:build\pa_part1.exe src\pa_part1.c || goto :build_fail
  echo [cl] Building Part 2 -> build\pa_part2.exe
  cl /O2 /W4 /nologo /Fe:build\pa_part2.exe src\pa_part2.c || goto :build_fail
  echo [cl] Building Part 3 -> build\pa_part3.exe
  cl /O2 /W4 /nologo /Fe:build\pa_part3.exe src\pa_part3.c || goto :build_fail
  goto :run_all
)

where gcc >nul 2>&1
if %ERRORLEVEL%==0 (
  echo [gcc] Building Part 1 -> build\pa_part1.exe
  gcc -O3 -Wall -Wextra -std=c11 -o build\pa_part1.exe src\pa_part1.c || goto :build_fail
  echo [gcc] Building Part 2 -> build\pa_part2.exe
  gcc -O3 -Wall -Wextra -std=c11 -o build\pa_part2.exe src\pa_part2.c || goto :build_fail
  echo [gcc] Building Part 3 -> build\pa_part3.exe
  gcc -O3 -Wall -Wextra -std=c11 -o build\pa_part3.exe src\pa_part3.c || goto :build_fail
  goto :run_all
)

echo ERROR: Neither 'cl' (MSVC) nor 'gcc' found in PATH.
echo Use a VS Developer Command Prompt or install MinGW-w64.
exit /b 1

:run_all
echo.
echo === Running Part 1 (pa_part1.exe) ===
build\pa_part1.exe || goto :run_fail
echo.
echo === Running Part 2 (pa_part2.exe) ===
build\pa_part2.exe || goto :run_fail
echo.
echo === Running Part 3 (pa_part3.exe) ===
build\pa_part3.exe || goto :run_fail
echo.
echo === All parts executed. ===
exit /b 0

:build_fail
echo Build failed. See messages above.
exit /b 1

:run_fail
echo Execution failed. See messages above.
exit /b 1

