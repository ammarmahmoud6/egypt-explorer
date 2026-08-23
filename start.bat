@echo off
REM One-click launcher: runs the Flutter web app against the deployed backend
REM at http://ammar5555.pythonanywhere.com (the default, no flags needed).

echo Starting Flutter app in Chrome...
start "Flutter App" cmd /k "cd /d "%~dp0" && flutter run -d chrome"

echo App launched. It talks to the live PythonAnywhere backend by default.