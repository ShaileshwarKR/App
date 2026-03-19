# LifeOS UI MVP

This repository contains two ways to review the LifeOS UI work:

1. **Flutter source** in `lib/` for the actual app structure.
2. **Static visual preview** in `preview/index.html` so the design can be viewed immediately even when Flutter is not installed in the environment.

## Why the previous result was hard to see

The earlier change added Flutter UI source files only. Because this environment does **not** have the Flutter SDK installed, the app cannot be built or launched here, so there was no immediate visual artifact to open.

## View the design right now

Open `preview/index.html` in a browser to review the screen designs.

## Flutter files

- `lib/app.dart`: app routes and entry flow
- `lib/theme.dart`: design system
- `lib/screens/*`: screen implementations
- `lib/widgets/*`: reusable components

## When Flutter is available

Typical commands would be:

```bash
flutter pub get
flutter run
```
