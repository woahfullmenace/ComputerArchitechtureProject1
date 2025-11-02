@echo off
setlocal enabledelayedexpansion

echo === Build All Parts (1, 2, 3, 4, 5) ===
if not exist build mkdir build >nul 2>&1
if not exist build\explaination mkdir build\explaination >nul 2>&1
if not exist logs mkdir logs >nul 2>&1
set "RUN_LOG=logs\run.log"
echo [%date% %time%] build-all started >> "%RUN_LOG%"

rem Prefer MSVC if available, otherwise use GCC
where cl >nul 2>&1
if %ERRORLEVEL%==0 (
  echo [cl] Building Part 1 -> build\pa_part1.exe
  cl /O2 /W4 /nologo /Fe:build\pa_part1.exe src\pa_part1.c || goto :build_fail
  echo [%date% %time%] cl built pa_part1.exe exit=%ERRORLEVEL% >> "%RUN_LOG%"
  echo [cl] Building Part 2 -> build\pa_part2.exe
  cl /O2 /W4 /nologo /Fe:build\pa_part2.exe src\pa_part2.c || goto :build_fail
  echo [%date% %time%] cl built pa_part2.exe exit=%ERRORLEVEL% >> "%RUN_LOG%"
  echo [cl] Building Part 3 -> build\pa_part3.exe
  cl /O2 /W4 /nologo /Fe:build\pa_part3.exe src\pa_part3.c || goto :build_fail
  echo [%date% %time%] cl built pa_part3.exe exit=%ERRORLEVEL% >> "%RUN_LOG%"
  echo [cl] Building Part 4 -> build\pa_part4.exe
  cl /O2 /W4 /nologo /Fe:build\pa_part4.exe src\pa_part4.c || goto :build_fail
  echo [%date% %time%] cl built pa_part4.exe exit=%ERRORLEVEL% >> "%RUN_LOG%"
  echo [cl] Building Part 5 -> build\pa_part5.exe
  cl /O2 /W4 /nologo /Fe:build\pa_part5.exe src\pa_part5.c || goto :build_fail
  echo [%date% %time%] cl built pa_part5.exe exit=%ERRORLEVEL% >> "%RUN_LOG%"
  goto :run_all
)

where gcc >nul 2>&1
if %ERRORLEVEL%==0 (
  echo [gcc] Building Part 1 -> build\pa_part1.exe
  gcc -O3 -Wall -Wextra -std=c11 -o build\pa_part1.exe src\pa_part1.c || goto :build_fail
  echo [%date% %time%] gcc built pa_part1.exe exit=%ERRORLEVEL% >> "%RUN_LOG%"
  echo [gcc] Building Part 2 -> build\pa_part2.exe
  gcc -O3 -Wall -Wextra -std=c11 -o build\pa_part2.exe src\pa_part2.c || goto :build_fail
  echo [%date% %time%] gcc built pa_part2.exe exit=%ERRORLEVEL% >> "%RUN_LOG%"
  echo [gcc] Building Part 3 -> build\pa_part3.exe
  gcc -O3 -Wall -Wextra -std=c11 -o build\pa_part3.exe src\pa_part3.c || goto :build_fail
  echo [%date% %time%] gcc built pa_part3.exe exit=%ERRORLEVEL% >> "%RUN_LOG%"
  echo [gcc] Building Part 4 -> build\pa_part4.exe
  gcc -O3 -Wall -Wextra -std=c11 -o build\pa_part4.exe src\pa_part4.c || goto :build_fail
  echo [%date% %time%] gcc built pa_part4.exe exit=%ERRORLEVEL% >> "%RUN_LOG%"
  echo [gcc] Building Part 5 -> build\pa_part5.exe
  gcc -O3 -Wall -Wextra -std=c11 -o build\pa_part5.exe src\pa_part5.c || goto :build_fail
  echo [%date% %time%] gcc built pa_part5.exe exit=%ERRORLEVEL% >> "%RUN_LOG%"
  goto :run_all
)

echo ERROR: Neither 'cl' (MSVC) nor 'gcc' found in PATH.
echo Use a VS Developer Command Prompt or install MinGW-w64.
exit /b 1

:run_all
echo.
echo === Running Part 1 (pa_part1.exe) ===
call :run_and_capture build\pa_part1.exe P1_TIME || goto :run_fail
echo [%date% %time%] ran pa_part1.exe time=%P1_TIME% >> "%RUN_LOG%"
echo.
echo === Running Part 2 (pa_part2.exe) ===
call :run_and_capture build\pa_part2.exe P2_TIME || goto :run_fail
echo [%date% %time%] ran pa_part2.exe time=%P2_TIME% >> "%RUN_LOG%"
echo.
echo === Running Part 3 (pa_part3.exe) ===
call :run_and_capture build\pa_part3.exe P3_TIME || goto :run_fail
echo [%date% %time%] ran pa_part3.exe time=%P3_TIME% >> "%RUN_LOG%"
echo.
echo === Running Part 4 (pa_part4.exe) ===
call :run_and_capture build\pa_part4.exe P4_TIME || goto :run_fail
echo [%date% %time%] ran pa_part4.exe time=%P4_TIME% >> "%RUN_LOG%"
echo.
echo === Running Part 5 (pa_part5.exe) ===
call :run_and_capture build\pa_part5.exe P5_TIME || goto :run_fail
echo [%date% %time%] ran pa_part5.exe time=%P5_TIME% >> "%RUN_LOG%"
echo.
echo === All parts executed. ===
echo [%date% %time%] build-all finished >> "%RUN_LOG%"

echo.
echo === Writing Part 6 explanation and timing comparison ===
set "_EXPF=build\explaination\part6_explaination.txt"
echo Part 6: Timing Comparison and Explanation> "%_EXPF%"
echo.>> "%_EXPF%"
echo Measured times (seconds):>> "%_EXPF%"
echo   Part 1: %P1_TIME%>> "%_EXPF%"
echo   Part 2: %P2_TIME%>> "%_EXPF%"
echo   Part 3: %P3_TIME%>> "%_EXPF%"
echo   Part 4: %P4_TIME%>> "%_EXPF%"
echo   Part 5: %P5_TIME%>> "%_EXPF%"
echo.>> "%_EXPF%"
echo Why times differ:>> "%_EXPF%"
echo - Parallelism vs. core count: More threads use more CPU cores and reduce wall time up to available physical cores.>> "%_EXPF%"
echo - Memory hierarchy and bandwidth: Multiple threads increase DRAM traffic; speedup tapers when memory bandwidth is saturated.>> "%_EXPF%"
echo - Cache effects: Shared last-level cache between threads can reduce locality and add contention.>> "%_EXPF%"
echo - Threading overhead and scheduling: Creating/joining threads adds small overhead; OS scheduling adds variance.>> "%_EXPF%"
echo - SMT/Hyper-Threading: Threads beyond physical cores have diminishing returns since execution units are shared.>> "%_EXPF%"
echo.>> "%_EXPF%"
echo Expected trend:>> "%_EXPF%"
echo - Parts 1, 2, 3 are similar ^(single-threaded work; Part 3 adds small thread overhead^).>> "%_EXPF%"
echo - Part 4 ^(2 threads^) ~up to 2x faster on 2+ core CPUs.>> "%_EXPF%"
echo - Part 5 ^(4 threads^) ~up to 4x faster on 4+ core CPUs, limited by memory bandwidth/cache.>> "%_EXPF%"

exit /b 0

:build_fail
echo Build failed. See messages above.
exit /b 1

:run_fail
echo Execution failed. See messages above.
exit /b 1

:run_and_capture
setlocal ENABLEDELAYEDEXPANSION
set "APP=%~1"
set "VARNAME=%~2"
set "TMP=build\_run_tmp.txt"
"%APP%" > "%TMP%" 2>&1
type "%TMP%"
set "__CAPTURED__="
for /f "usebackq delims=" %%T in (`powershell -NoProfile -Command "$c=Get-Content -Raw '%TMP%'; $m=[regex]::Match($c,'([0-9]+(\.[0-9]+)?)\s*seconds'); if($m.Success){ $m.Groups[1].Value }"`) do set "__CAPTURED__=%%T"
del /q "%TMP%" >nul 2>&1
endlocal & set "%VARNAME%=%__CAPTURED__%"
exit /b 0
