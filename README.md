# Wellbeing Tracker

A comprehensive, unbranded wellbeing application that tracks mental, physical, and skin health metrics. The app integrates with Apple Health and Google Fit to collect HRV (Heart Rate Variability) and other wellbeing metrics.

## Features

### Mental Health Tracking
- Mood tracking (1-5 scale)
- Stress level monitoring (1-10 scale)
- Anxiety level tracking (1-10 scale)
- Energy level assessment (1-10 scale)
- Notes and journaling

### Physical Health Tracking
- **HRV (Heart Rate Variability)** - Automatic collection from Apple Health/Google Fit
- Heart rate monitoring
- Steps tracking
- Sleep duration tracking
- Interactive charts and visualizations
- Historical data analysis

### Skin Health Tracking
- Skin condition rating (1-5 scale)
- Hydration level tracking (1-10 scale)
- Moisture level monitoring (1-10 scale)
- Acne tracking
- Notes and observations

### Additional Features
- **Multi-language Support**: English, Spanish, Turkish, Polish
- **Cross-platform**: iOS, Android, and Web
- **Dark/Light Theme**: System-aware theme switching
- **Dashboard**: Overview of all metrics with charts
- **Data Persistence**: Local storage for all tracked data

## Getting Started

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK
- For iOS: Xcode and CocoaPods
- For Android: Android Studio and Android SDK
- For Web: Chrome or any modern browser

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd foreo_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate localization files:
```bash
flutter gen-l10n
```

### Running the App

#### Mobile (iOS/Android)
```bash
# iOS
flutter run -d ios

# Android
flutter run -d android
```

#### Web
```bash
flutter run -d chrome
```

### Building for Production

#### iOS
```bash
flutter build ios
```

#### Android
```bash
flutter build apk
# or
flutter build appbundle
```

#### Web
```bash
flutter build web
```

## Health Data Integration

### iOS (Apple Health)
1. The app will request permissions when you first connect
2. Grant access to:
   - Heart Rate Variability
   - Heart Rate
   - Steps
   - Sleep Analysis
   - Active Energy

### Android (Google Fit)
1. The app will request permissions when you first connect
2. Grant access to:
   - Activity Recognition (for steps)
   - Health data permissions

### Web
- Health data integration is not available on web platforms
- Mental and skin health tracking still work on web
- Data is stored locally in the browser

## Project Structure

```
lib/
├── l10n/                    # Localization files (ARB format)
│   ├── app_en.arb          # English
│   ├── app_es.arb          # Spanish
│   ├── app_tr.arb          # Turkish
│   └── app_pl.arb          # Polish
├── models/                  # Data models
│   ├── health_metric.dart
│   ├── mental_health.dart
│   └── skin_health.dart
├── screens/                # UI screens
│   ├── dashboard_screen.dart
│   ├── physical_health_screen.dart
│   ├── mental_health_screen.dart
│   ├── skin_health_screen.dart
│   └── settings_screen.dart
├── services/               # Business logic
│   ├── app_state.dart
│   ├── health_service.dart
│   ├── database_service.dart
│   ├── database_service_mobile.dart
│   └── database_service_web.dart
├── widgets/               # Reusable widgets
│   ├── metric_card.dart
│   └── health_chart.dart
└── main.dart             # App entry point
```

## Technologies Used

- **Flutter**: Cross-platform UI framework
- **Provider**: State management
- **Health**: Health data integration (iOS/Android)
- **sqflite**: Local database (mobile)
- **shared_preferences**: Local storage (web)
- **fl_chart**: Data visualization
- **intl**: Internationalization

## Permissions

### iOS
- HealthKit permissions (configured in Info.plist)

### Android
- Activity Recognition permission (for steps)
- Health data permissions

## Data Privacy

- All data is stored locally on your device
- No data is transmitted to external servers
- Health data permissions are requested only when needed
- You can disconnect health services at any time

## Contributing

This is an unbranded application template. Feel free to customize it for your needs.

## License

This project is provided as-is for use and modification.

## Support

For issues or questions, please refer to the Flutter documentation or create an issue in the repository.
# Foreo-MobileApp
