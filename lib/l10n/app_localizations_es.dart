// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Seguimiento de Bienestar';

  @override
  String get dashboard => 'Panel';

  @override
  String get mentalHealth => 'Salud Mental';

  @override
  String get physicalHealth => 'Salud Física';

  @override
  String get skinHealth => 'Salud de la Piel';

  @override
  String get settings => 'Configuración';

  @override
  String get hrv => 'Variabilidad de la Frecuencia Cardíaca';

  @override
  String hrvValue(num value) {
    return '$value ms';
  }

  @override
  String get heartRate => 'Frecuencia Cardíaca';

  @override
  String heartRateValue(num value) {
    return '$value lpm';
  }

  @override
  String get steps => 'Pasos';

  @override
  String stepsValue(num value) {
    return '$value pasos';
  }

  @override
  String get sleep => 'Sueño';

  @override
  String sleepHours(num hours) {
    return '$hours horas';
  }

  @override
  String get mood => 'Estado de Ánimo';

  @override
  String get stress => 'Nivel de Estrés';

  @override
  String get anxiety => 'Nivel de Ansiedad';

  @override
  String get energy => 'Nivel de Energía';

  @override
  String get skinCondition => 'Condición de la Piel';

  @override
  String get hydration => 'Hidratación';

  @override
  String get moisture => 'Nivel de Humedad';

  @override
  String get acne => 'Acné';

  @override
  String get today => 'Hoy';

  @override
  String get thisWeek => 'Esta Semana';

  @override
  String get thisMonth => 'Este Mes';

  @override
  String get connectHealth => 'Conectar Datos de Salud';

  @override
  String get connectHealthDescription =>
      'Conecta con Apple Health o Google Fit para rastrear automáticamente tus métricas de bienestar';

  @override
  String get grantPermission => 'Otorgar Permiso';

  @override
  String get permissionRequired => 'Permiso Requerido';

  @override
  String get permissionDescription =>
      'Esta aplicación necesita acceso a tus datos de salud para rastrear tus métricas de bienestar';

  @override
  String get noData => 'No Hay Datos Disponibles';

  @override
  String get noDataDescription =>
      'Conecta tu aplicación de salud para comenzar a rastrear';

  @override
  String get trackMood => 'Registrar Estado de Ánimo';

  @override
  String get moodRating => '¿Cómo te sientes?';

  @override
  String get veryGood => 'Muy Bien';

  @override
  String get good => 'Bien';

  @override
  String get neutral => 'Neutral';

  @override
  String get bad => 'Mal';

  @override
  String get veryBad => 'Muy Mal';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get addNote => 'Agregar Nota';

  @override
  String get notes => 'Notas';

  @override
  String get date => 'Fecha';

  @override
  String get time => 'Hora';

  @override
  String get viewDetails => 'Ver Detalles';

  @override
  String get lastSync => 'Última Sincronización';

  @override
  String get syncNow => 'Sincronizar Ahora';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get english => 'Inglés';

  @override
  String get spanish => 'Español';

  @override
  String get turkish => 'Turco';

  @override
  String get polish => 'Polaco';

  @override
  String get theme => 'Tema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get system => 'Sistema';

  @override
  String get about => 'Acerca de';

  @override
  String get version => 'Versión';

  @override
  String get privacy => 'Política de Privacidad';

  @override
  String get terms => 'Términos de Servicio';
}
