# LifeOS UI MVP

This repository contains two ways to review the LifeOS UI work:

1. **Flutter source** in `lib/` for the actual app structure.
2. **Static visual preview** in `preview/index.html` so the design can be viewed immediately even when Flutter is not installed in the environment.

## Why you may see `package:flutter/material.dart` errors

Those errors happen when the project is opened without a working Flutter SDK and dependency resolution. `package:flutter/material.dart` is provided by the Flutter SDK, not by this repository itself.

Typical fixes on a local machine are:

1. Install Flutter and confirm it with `flutter doctor`.
2. Open the **project root** (the folder containing `pubspec.yaml`).
3. Run `flutter pub get`.
4. Re-open the IDE or restart the Dart/Flutter analysis server.

I also added standard Flutter project metadata files so IDEs are more likely to recognize this as a Flutter app.

## View the design right now

Open `preview/index.html` in a browser to review the screen designs immediately, even before Flutter is installed.

## Flutter files

- `lib/app.dart`: app routes and entry flow
- `lib/theme.dart`: design system
- `lib/screens/*`: screen implementations, now including a location access step before quick setup
- `lib/services/*`: modular score, suggestions, maps, notifications, and demo-data services
- `lib/widgets/*`: reusable components such as charts, suggestion cards, and habit streak cards

## When Flutter is available

Typical commands would be:

```bash
flutter pub get
flutter run
```
