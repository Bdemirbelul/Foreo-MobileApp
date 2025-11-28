// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Wellbeing Tracker';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get mentalHealth => 'Mental Health';

  @override
  String get physicalHealth => 'Physical Health';

  @override
  String get skinHealth => 'Skin Health';

  @override
  String get settings => 'Settings';

  @override
  String get hrv => 'Heart Rate Variability';

  @override
  String hrvValue(num value) {
    return '$value ms';
  }

  @override
  String get heartRate => 'Heart Rate';

  @override
  String heartRateValue(num value) {
    return '$value bpm';
  }

  @override
  String get steps => 'Steps';

  @override
  String stepsValue(num value) {
    return '$value steps';
  }

  @override
  String get sleep => 'Sleep';

  @override
  String sleepHours(num hours) {
    return '$hours hours';
  }

  @override
  String get mood => 'Mood';

  @override
  String get stress => 'Stress Level';

  @override
  String get anxiety => 'Anxiety Level';

  @override
  String get energy => 'Energy Level';

  @override
  String get skinCondition => 'Skin Condition';

  @override
  String get hydration => 'Hydration';

  @override
  String get moisture => 'Moisture Level';

  @override
  String get acne => 'Acne';

  @override
  String get today => 'Today';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get connectHealth => 'Connect Health Data';

  @override
  String get connectHealthDescription =>
      'Connect to Apple Health or Google Fit to automatically track your wellbeing metrics';

  @override
  String get grantPermission => 'Grant Permission';

  @override
  String get permissionRequired => 'Permission Required';

  @override
  String get permissionDescription =>
      'This app needs access to your health data to track your wellbeing metrics';

  @override
  String get noData => 'No Data Available';

  @override
  String get noDataDescription => 'Connect your health app to start tracking';

  @override
  String get trackMood => 'Track Mood';

  @override
  String get moodRating => 'How are you feeling?';

  @override
  String get veryGood => 'Very Good';

  @override
  String get good => 'Good';

  @override
  String get neutral => 'Neutral';

  @override
  String get bad => 'Bad';

  @override
  String get veryBad => 'Very Bad';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get addNote => 'Add Note';

  @override
  String get notes => 'Notes';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get viewDetails => 'View Details';

  @override
  String get lastSync => 'Last Sync';

  @override
  String get syncNow => 'Sync Now';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Spanish';

  @override
  String get turkish => 'Turkish';

  @override
  String get polish => 'Polish';

  @override
  String get theme => 'Theme';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get privacy => 'Privacy Policy';

  @override
  String get terms => 'Terms of Service';
}
