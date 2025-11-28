import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/health_metric.dart';
import '../models/mental_health.dart';
import '../models/skin_health.dart';
import 'mock_data_service.dart';
import 'database_service.dart' as db;

class AppState extends ChangeNotifier {
  final db.DatabaseService _databaseService = db.DatabaseService.instance;

  // Health data (using mock data)
  List<HRVData> _hrvData = [];
  List<HeartRateData> _heartRateData = [];
  List<StepsData> _stepsData = [];
  List<SleepData> _sleepData = [];

  // Mental health
  List<MentalHealthEntry> _mentalHealthEntries = [];

  // Skin health
  List<SkinHealthEntry> _skinHealthEntries = [];

  // Settings
  Locale _locale = const Locale('en');
  ThemeMode _themeMode = ThemeMode.light;
  bool _dataInitialized = false;

  // Authentication
  bool _isAuthenticated = false;
  String? _userEmail;

  // Getters
  List<HRVData> get hrvData => _hrvData;
  List<HeartRateData> get heartRateData => _heartRateData;
  List<StepsData> get stepsData => _stepsData;
  List<SleepData> get sleepData => _sleepData;
  List<MentalHealthEntry> get mentalHealthEntries => _mentalHealthEntries;
  List<SkinHealthEntry> get skinHealthEntries => _skinHealthEntries;
  Locale get locale => _locale;
  ThemeMode get themeMode => _themeMode;
  bool get isAuthenticated => _isAuthenticated;
  String? get userEmail => _userEmail;

  AppState() {
    _loadSettings();
    _initializeData();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language') ?? 'en';
    final themeModeString = prefs.getString('theme_mode') ?? 'light';
    final isAuth = prefs.getBool('is_authenticated') ?? false;
    final email = prefs.getString('user_email');

    _locale = Locale(languageCode);
    _themeMode = ThemeMode.values.firstWhere(
      (e) => e.toString() == 'ThemeMode.$themeModeString',
      orElse: () => ThemeMode.light,
    );
    _isAuthenticated = isAuth;
    _userEmail = email;

    notifyListeners();
  }

  Future<void> login(String email) async {
    _isAuthenticated = true;
    _userEmail = email;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_authenticated', true);
    await prefs.setString('user_email', email);
    notifyListeners();
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _userEmail = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_authenticated', false);
    await prefs.remove('user_email');
    notifyListeners();
  }

  Future<void> _initializeData() async {
    if (_dataInitialized) return;

    // Load mock health data
    _hrvData = MockDataService.generateHRVData(days: 30);
    _heartRateData = MockDataService.generateHeartRateData(days: 30);
    _stepsData = MockDataService.generateStepsData(days: 30);
    _sleepData = MockDataService.generateSleepData(days: 30);

    // Load stored entries
    await _loadMentalHealthEntries();
    await _loadSkinHealthEntries();

    _dataInitialized = true;
    notifyListeners();
  }

  Future<void> refreshHealthData() async {
    _hrvData = MockDataService.generateHRVData(days: 30);
    _heartRateData = MockDataService.generateHeartRateData(days: 30);
    _stepsData = MockDataService.generateStepsData(days: 30);
    _sleepData = MockDataService.generateSleepData(days: 30);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', locale.languageCode);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', mode.toString().split('.').last);
    notifyListeners();
  }

  Future<void> addMentalHealthEntry(MentalHealthEntry entry) async {
    await _databaseService.insertMentalHealthEntry(entry);
    await _loadMentalHealthEntries();
  }

  Future<void> _loadMentalHealthEntries() async {
    _mentalHealthEntries = await _databaseService.getMentalHealthEntries();
    notifyListeners();
  }

  Future<void> addSkinHealthEntry(SkinHealthEntry entry) async {
    await _databaseService.insertSkinHealthEntry(entry);
    await _loadSkinHealthEntries();
  }

  Future<void> _loadSkinHealthEntries() async {
    _skinHealthEntries = await _databaseService.getSkinHealthEntries();
    notifyListeners();
  }
}
