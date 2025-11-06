@echo off
setlocal enabledelayedexpansion

rem This script converts all files with a specified extension in the current directory
rem and its subdirectories to MP4 format using FFmpeg.

rem Check if FFmpeg is installed and in the system's PATH.
where ffmpeg >nul 2>nul
if %errorlevel% neq 0 (
echo.
echo ERROR: FFmpeg is not found in your system's PATH.
echo Please install FFmpeg and make sure it is accessible from the command line.
echo.
echo You can download it from https://ffmpeg.org/download.html
echo.
pause
exit /b 1
)

echo.
echo ====================================
echo Video Converter Script
echo ====================================
echo.
pause

rem Ask the user for the file extension to convert
set /p "e=Enter the source file extension (e.g., mov): "
echo.

rem Loop through all files with the specified extension in the current directory and subdirectories
for /r %%i in ("*.%e%") do (
rem Get the full path and name of the output file
rem "%%~dpi" gets the drive and path, "%%~ni" gets the filename without extension
set "o=%%~dpi%%~ni_new.mp4"

echo Processing "%%i" to "!o!"

rem The FFmpeg command.
rem -y: Overwrite output files without asking.
rem -i "%%i": The input file.
rem -c:a aac -b:a 320k: Audio codec and bitrate.
rem The selected video conversion parameters are used here.
ffmpeg -y -i "%%i" -c:a copy -rc:v vbr -cq:v 20 -minrate 12M -maxrate:v 20M -bufsize:v 40M -c:v hevc_nvenc -color_range tv -spatial-aq 1 -aq-strength 15 -map_metadata 0:g:0 "!o!"

rem Copy the original file's creation, write, and access times to the new file.
rem The `!` is for delayed expansion, which is needed because the `o` variable is changing in the loop.
powershell ^(Get-Item -LiteralPath '!o!'^).CreationTime = ^(Get-Item -LiteralPath '%%i'^).CreationTime
powershell ^(Get-Item -LiteralPath '!o!'^).LastWriteTime = ^(Get-Item -LiteralPath '%%i'^).LastWriteTime
powershell ^(Get-Item -LiteralPath '!o!'^).LastAccessTime = ^(Get-Item -LiteralPath '%%i'^).LastAccessTime

echo Done %%i
echo.

)

echo.
echo ====================================
echo All conversions are complete.
echo ====================================
echo.
pause