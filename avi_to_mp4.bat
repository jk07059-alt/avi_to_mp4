@echo off
REM Drag one or more video files (avi, mkv, mov...) onto this file.
REM Each one is converted to an H.264 mp4 next to the original (same name, .mp4).

where ffmpeg >nul 2>nul
if errorlevel 1 (
  echo ffmpeg is not installed. Installing it now...
  winget install -e --id Gyan.FFmpeg --accept-source-agreements --accept-package-agreements
  echo.
  echo Install finished. Close this window and drag the video onto this file again.
  pause
  exit /b
)

if "%~1"=="" (
  echo Drag a video file onto this .bat file to convert it.
  pause
  exit /b
)

for %%F in (%*) do (
  echo.
  echo Converting: %%~nxF
  ffmpeg -hide_banner -loglevel warning -stats -y -i "%%~fF" -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2" -c:v libx264 -crf 16 -preset fast -pix_fmt yuv420p -an -movflags +faststart "%%~dpnF.mp4"
  if errorlevel 1 (echo FAILED: %%~nxF) else (echo Done: %%~dpnF.mp4)
)
echo.
pause
