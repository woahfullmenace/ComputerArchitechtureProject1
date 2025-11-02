@echo off
setlocal enabledelayedexpansion

echo Cleaning all .exe files under %CD% recursively...
for /r %%F in (*.exe) do (
  echo Deleting "%%F"
  del /f /q "%%F" >nul 2>&1
)

REM Also remove matrix output in build\data3 if present
if exist "build\data3" (
  echo Deleting "build\data3"
  del /f /q "build\data3" >nul 2>&1
)

echo Done.
