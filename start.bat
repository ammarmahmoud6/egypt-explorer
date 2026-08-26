@echo off
REM One-click launcher for the Egypt Explorer project.
REM
REM Options:
REM   start.bat            -> runs the Flutter web app against the deployed
REM                           backend (http://ammar5555.pythonanywhere.com).
REM   start.bat deploy     -> pushes backend changes to git and reloads the
REM                           PythonAnywhere web app (python deploy.py).

setlocal
cd /d "%~dp0"

if /I "%~1"=="deploy" (
    echo ============================================
    echo Deploying backend to PythonAnywhere...
    echo ============================================
    REM If the token is not set yet, prompt for it once per session.
    if not defined PYTHONANYWHERE_API_TOKEN (
        set /p PYTHONANYWHERE_API_TOKEN=PythonAnywhere API token: 
    )
    python deploy.py
    if errorlevel 1 (
        echo.
        echo Deploy failed. Check the output above.
        exit /b 1
    )
    echo.
    echo Deploy finished successfully.
    exit /b 0
)

REM Default: launch the Flutter web app against the deployed backend.
echo Starting Flutter app in Chrome...
start "Flutter App" cmd /k "cd /d "%~dp0" && flutter run -d chrome"

echo App launched. It talks to the live PythonAnywhere backend by default.
endlocal
