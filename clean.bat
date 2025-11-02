@echo off
setlocal enabledelayedexpansion

echo Cleaning all .exe files under %CD% recursively...
for /r %%F in (*.exe) do (
  echo Deleting "%%F"
  del /f /q "%%F" >nul 2>&1
)

REM Also remove matrix outputs in build\output if present
if exist "build\output\data3" (
  echo Deleting "build\output\data3"
  del /f /q "build\output\data3" >nul 2>&1
)
if exist "build\output\data3_part2" (
  echo Deleting "build\output\data3_part2"
  del /f /q "build\output\data3_part2" >nul 2>&1
)
if exist "build\output\data3_part3" (
  echo Deleting "build\output\data3_part3"
  del /f /q "build\output\data3_part3" >nul 2>&1
)
if exist "build\output\data3_part4" (
  echo Deleting "build\output\data3_part4"
  del /f /q "build\output\data3_part4" >nul 2>&1
)
if exist "build\output\data3_part5" (
  echo Deleting "build\output\data3_part5"
  del /f /q "build\output\data3_part5" >nul 2>&1
)
if exist "build\explaination" (
  echo Deleting "build\explaination" (Part 6 explanation)
  rmdir /s /q "build\explaination" >nul 2>&1
)

echo Done.
