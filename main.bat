@echo off
:: Check if running as administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrative privileges...
    PowerShell -Command "Start-Process -FilePath '%~f0' -Verb runAs"
    exit /b
)

:: Generate disk list
set "disklist=%temp%\disklist.txt"
set "scriptfile=%temp%\diskpart_script.txt"
echo list disk > "%scriptfile%"
diskpart /s "%scriptfile%" > "%disklist%"

:: Display disks
echo.
echo Available disks:
type "%disklist%"
echo.

:: Prompt user for disk number
set /p "choice=Enter the disk number to select: "

:: Validate input
findstr /b "Disk %choice%" "%disklist%" >nul
if errorlevel 1 (
    echo Invalid selection. Exiting.
    goto cleanup
)

echo You selected disk %choice%.

:: Prepare diskpart commands: clean, convert to MBR, create partition, format, assign, select partition, mark active
set "diskpartCommands=%temp%\diskpart_commands.txt"
(
echo select disk %choice%
echo clean
echo convert mbr
echo create partition primary
echo format fs=ntfs quick
echo assign
echo select partition 1
echo active
) > "%diskpartCommands%"

:: Run diskpart with these commands
diskpart /s "%diskpartCommands%"

echo.
echo Disk %choice% has been cleaned, partition 1 created, formatted, assigned, and marked as active.
pause

:cleanup
del "%scriptfile%"
del "%disklist%"
del "%diskpartCommands%"
