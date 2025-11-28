// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Monitor Zdrowia';

  @override
  String get dashboard => 'Panel';

  @override
  String get mentalHealth => 'Zdrowie Psychiczne';

  @override
  String get physicalHealth => 'Zdrowie Fizyczne';

  @override
  String get skinHealth => 'Zdrowie Skóry';

  @override
  String get settings => 'Ustawienia';

  @override
  String get hrv => 'Zmienność Rytmu Serca';

  @override
  String hrvValue(num value) {
    return '$value ms';
  }

  @override
  String get heartRate => 'Tętno';

  @override
  String heartRateValue(num value) {
    return '$value bpm';
  }

  @override
  String get steps => 'Kroki';

  @override
  String stepsValue(num value) {
    return '$value kroków';
  }

  @override
  String get sleep => 'Sen';

  @override
  String sleepHours(num hours) {
    return '$hours godzin';
  }

  @override
  String get mood => 'Nastrój';

  @override
  String get stress => 'Poziom Stresu';

  @override
  String get anxiety => 'Poziom Lęku';

  @override
  String get energy => 'Poziom Energii';

  @override
  String get skinCondition => 'Stan Skóry';

  @override
  String get hydration => 'Nawodnienie';

  @override
  String get moisture => 'Poziom Wilgotności';

  @override
  String get acne => 'Trądzik';

  @override
  String get today => 'Dzisiaj';

  @override
  String get thisWeek => 'Ten Tydzień';

  @override
  String get thisMonth => 'Ten Miesiąc';

  @override
  String get connectHealth => 'Połącz Dane Zdrowotne';

  @override
  String get connectHealthDescription =>
      'Połącz z Apple Health lub Google Fit, aby automatycznie śledzić swoje wskaźniki zdrowia';

  @override
  String get grantPermission => 'Udziel Uprawnień';

  @override
  String get permissionRequired => 'Wymagane Uprawnienia';

  @override
  String get permissionDescription =>
      'Ta aplikacja wymaga dostępu do Twoich danych zdrowotnych, aby śledzić wskaźniki zdrowia';

  @override
  String get noData => 'Brak Danych';

  @override
  String get noDataDescription =>
      'Połącz swoją aplikację zdrowotną, aby rozpocząć śledzenie';

  @override
  String get trackMood => 'Śledź Nastrój';

  @override
  String get moodRating => 'Jak się czujesz?';

  @override
  String get veryGood => 'Bardzo Dobrze';

  @override
  String get good => 'Dobrze';

  @override
  String get neutral => 'Neutralnie';

  @override
  String get bad => 'Źle';

  @override
  String get veryBad => 'Bardzo Źle';

  @override
  String get save => 'Zapisz';

  @override
  String get cancel => 'Anuluj';

  @override
  String get addNote => 'Dodaj Notatkę';

  @override
  String get notes => 'Notatki';

  @override
  String get date => 'Data';

  @override
  String get time => 'Czas';

  @override
  String get viewDetails => 'Zobacz Szczegóły';

  @override
  String get lastSync => 'Ostatnia Synchronizacja';

  @override
  String get syncNow => 'Synchronizuj Teraz';

  @override
  String get language => 'Język';

  @override
  String get selectLanguage => 'Wybierz Język';

  @override
  String get english => 'Angielski';

  @override
  String get spanish => 'Hiszpański';

  @override
  String get turkish => 'Turecki';

  @override
  String get polish => 'Polski';

  @override
  String get theme => 'Motyw';

  @override
  String get light => 'Jasny';

  @override
  String get dark => 'Ciemny';

  @override
  String get system => 'Systemowy';

  @override
  String get about => 'O Aplikacji';

  @override
  String get version => 'Wersja';

  @override
  String get privacy => 'Polityka Prywatności';

  @override
  String get terms => 'Warunki Usługi';
}
