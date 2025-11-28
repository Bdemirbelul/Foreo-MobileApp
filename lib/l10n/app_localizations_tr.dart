// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Sağlık Takipçisi';

  @override
  String get dashboard => 'Kontrol Paneli';

  @override
  String get mentalHealth => 'Zihinsel Sağlık';

  @override
  String get physicalHealth => 'Fiziksel Sağlık';

  @override
  String get skinHealth => 'Cilt Sağlığı';

  @override
  String get settings => 'Ayarlar';

  @override
  String get hrv => 'Kalp Atış Hızı Değişkenliği';

  @override
  String hrvValue(num value) {
    return '$value ms';
  }

  @override
  String get heartRate => 'Kalp Atış Hızı';

  @override
  String heartRateValue(num value) {
    return '$value bpm';
  }

  @override
  String get steps => 'Adımlar';

  @override
  String stepsValue(num value) {
    return '$value adım';
  }

  @override
  String get sleep => 'Uyku';

  @override
  String sleepHours(num hours) {
    return '$hours saat';
  }

  @override
  String get mood => 'Ruh Hali';

  @override
  String get stress => 'Stres Seviyesi';

  @override
  String get anxiety => 'Kaygı Seviyesi';

  @override
  String get energy => 'Enerji Seviyesi';

  @override
  String get skinCondition => 'Cilt Durumu';

  @override
  String get hydration => 'Hidrasyon';

  @override
  String get moisture => 'Nem Seviyesi';

  @override
  String get acne => 'Akne';

  @override
  String get today => 'Bugün';

  @override
  String get thisWeek => 'Bu Hafta';

  @override
  String get thisMonth => 'Bu Ay';

  @override
  String get connectHealth => 'Sağlık Verilerini Bağla';

  @override
  String get connectHealthDescription =>
      'Sağlık metriklerinizi otomatik olarak takip etmek için Apple Health veya Google Fit\'e bağlanın';

  @override
  String get grantPermission => 'İzin Ver';

  @override
  String get permissionRequired => 'İzin Gerekli';

  @override
  String get permissionDescription =>
      'Bu uygulama sağlık metriklerinizi takip etmek için sağlık verilerinize erişim gerektirir';

  @override
  String get noData => 'Veri Yok';

  @override
  String get noDataDescription =>
      'Takip etmeye başlamak için sağlık uygulamanızı bağlayın';

  @override
  String get trackMood => 'Ruh Halini Takip Et';

  @override
  String get moodRating => 'Nasıl hissediyorsunuz?';

  @override
  String get veryGood => 'Çok İyi';

  @override
  String get good => 'İyi';

  @override
  String get neutral => 'Nötr';

  @override
  String get bad => 'Kötü';

  @override
  String get veryBad => 'Çok Kötü';

  @override
  String get save => 'Kaydet';

  @override
  String get cancel => 'İptal';

  @override
  String get addNote => 'Not Ekle';

  @override
  String get notes => 'Notlar';

  @override
  String get date => 'Tarih';

  @override
  String get time => 'Saat';

  @override
  String get viewDetails => 'Detayları Gör';

  @override
  String get lastSync => 'Son Senkronizasyon';

  @override
  String get syncNow => 'Şimdi Senkronize Et';

  @override
  String get language => 'Dil';

  @override
  String get selectLanguage => 'Dil Seç';

  @override
  String get english => 'İngilizce';

  @override
  String get spanish => 'İspanyolca';

  @override
  String get turkish => 'Türkçe';

  @override
  String get polish => 'Lehçe';

  @override
  String get theme => 'Tema';

  @override
  String get light => 'Açık';

  @override
  String get dark => 'Koyu';

  @override
  String get system => 'Sistem';

  @override
  String get about => 'Hakkında';

  @override
  String get version => 'Sürüm';

  @override
  String get privacy => 'Gizlilik Politikası';

  @override
  String get terms => 'Hizmet Şartları';
}
