@echo off
REM One-click launcher: starts the Flask backend and the Flutter web app.

echo Starting backend (Flask)...
start "Backend - Flask" cmd /k "cd /d "%~dp0backend" && python app.py"

REM Give Flask a couple of seconds to start up (ping-based delay works everywhere).
ping -n 4 127.0.0.1 >nul

echo Starting Flutter app in Chrome...
start "Flutter App" cmd /k "cd /d "%~dp0" && flutter run -d chrome --dart-define=BACKEND_URL=http://localhost:5000"

echo Both windows launched. Leave them open while using the app.