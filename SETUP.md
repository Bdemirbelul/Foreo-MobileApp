# Setup Guide

## Quick Start

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```

2. **Generate Localization Files**
   ```bash
   flutter gen-l10n
   ```

3. **Run the App**
   ```bash
   # For mobile
   flutter run
   
   # For web
   flutter run -d chrome
   ```

## Platform-Specific Setup

### iOS Setup

1. Open `ios/Runner.xcworkspace` in Xcode
2. In `Info.plist`, add HealthKit usage description:
   ```xml
   <key>NSHealthShareUsageDescription</key>
   <string>This app needs access to your health data to track wellbeing metrics</string>
   <key>NSHealthUpdateUsageDescription</key>
   <string>This app needs access to update your health data</string>
   ```
3. Enable HealthKit capability in Xcode project settings

### Android Setup

1. Open `android/app/src/main/AndroidManifest.xml`
2. Add permissions (if not already present):
   ```xml
   <uses-permission android:name="android.permission.ACTIVITY_RECOGNITION"/>
   <uses-permission android:name="android.permission.INTERNET"/>
   ```

### Web Setup

No additional setup required. The app will use SharedPreferences for data storage on web.

## Troubleshooting

### Localization Not Working
- Run `flutter gen-l10n` to generate localization files
- Ensure `l10n.yaml` exists in the root directory

### Health Data Not Syncing
- Check that permissions are granted in device settings
- For iOS: Settings > Privacy & Security > Health
- For Android: Settings > Apps > [App Name] > Permissions

### Database Errors
- On mobile: Ensure sqflite is properly installed
- On web: Data is stored in browser's local storage

## Building for Production

### iOS
```bash
flutter build ios --release
```

### Android
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

### Web
```bash
flutter build web --release
```




