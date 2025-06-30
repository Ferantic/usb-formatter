@echo off
:: Check if the script is running with admin rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    :: Not running as admin, so relaunch as admin
    echo Requesting administrative privileges...
    PowerShell -Command "Start-Process -FilePath '%~f0' -Verb runAs"
    exit /b
)

:: Your script code goes here
echo Script is running with administrator privileges.
pause





