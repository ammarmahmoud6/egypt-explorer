# final_project

A Flutter application with a Python (Flask) backend.

## Running the app

The app talks to a live backend hosted at `http://ammar5555.pythonanywhere.com` by default — no flags or local server needed.

To run it (Windows or any OS with Flutter installed):

```
flutter run -d chrome
```

Or on Windows, just double-click `start.bat` in the project root.

You can still point the app at any other backend URL at build time:

```
flutter run -d chrome --dart-define=BACKEND_URL=https://your-url.example.com
```

## Backend development

The backend lives in `backend/`. If you ever need to run it manually (e.g. to test changes before redeploying to PythonAnywhere):

```
cd backend
python app.py
```

Then point the app at it with `flutter run -d chrome --dart-define=BACKEND_URL=http://localhost:5000`.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
