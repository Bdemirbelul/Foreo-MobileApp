import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:io';
import '../services/app_state.dart';
import '../services/ai_chat_service.dart';
import '../models/note.dart';
import '../models/medication.dart';
import '../models/health_metric.dart';
import '../models/mental_health.dart';

class WellnessScreen extends StatefulWidget {
  const WellnessScreen({super.key});

  @override
  State<WellnessScreen> createState() => _WellnessScreenState();
}

class _WellnessScreenState extends State<WellnessScreen> {
  int _activeTab = 0;
  bool _showAI = false;
  final TextEditingController _aiInputController = TextEditingController();
  final ScrollController _aiScrollController = ScrollController();
  final AIChatService _aiService = AIChatService();
  final ImagePicker _imagePicker = ImagePicker();
  File? _faceImage;
  String? _faceAnalysis;

  // Data entry states
  double _sleepHours = 7.5;
  int _moodRating = 5;
  final List<String> _skinRoutineSteps = const [
    'Cleanser',
    'Vitamin C',
    'Moisturizer',
    'Sunscreen',
  ];
  late Map<String, bool> _skinRoutineState;

  // Notes and Medications
  List<Note> _notes = [];
  List<Medication> _medications = [];
  final TextEditingController _noteTitleController = TextEditingController();
  final TextEditingController _noteContentController = TextEditingController();
  final TextEditingController _medNameController = TextEditingController();
  final TextEditingController _medDosageController = TextEditingController();

  final List<Map<String, dynamic>> _metrics = [
    {
      'hrv': 65,
      'hydration': 72,
      'mood': 7,
      'sleep': 7.5,
      'skinScore': 82,
      'stress': 30,
    },
  ];

  final Map<String, Map<String, dynamic>> _translations = {
    'en': {
      'tabs': {
        'home': 'Home',
        'mental': 'Mental',
        'physical': 'Physical',
        'skin': 'Skin',
      },
      'ai': {
        'title': 'Holistic AI Assistant',
        'placeholder': 'Ask about your skin & health...',
        'greeting':
            'Hi! I analyzed your skin, sleep and stress data. How can I help today?',
      },
      'sections': {
        'mental': {
          'title': 'Mind Balance',
          'breath': 'Breathwork',
          'journal': 'Mood Journal',
          'insight': 'Low stress detected.',
        },
        'physical': {
          'title': 'Body Recovery',
          'recovery': 'Recovery Score',
          'steps': 'Steps',
          'sleep': 'Sleep Quality',
          'energy': 'Energy',
          'high': 'High',
          'recommendation': 'Recommendation',
          'heavyWorkout': 'Heavy Workout Suitable',
        },
        'skin': {
          'title': 'Skin Health',
          'scan': 'Start Face Scan',
          'uv': 'UV Index',
          'moisture': 'Moisture',
          'routine': 'Morning Routine',
          'barrier': 'Your skin barrier is strong.',
        },
      },
      'welcome': 'Hello, Alex',
      'overall': 'Overall',
    },
    'tr': {
      'tabs': {
        'home': 'Ana Sayfa',
        'mental': 'Zihinsel',
        'physical': 'Fiziksel',
        'skin': 'Cilt',
      },
      'ai': {
        'title': 'Holistik AI Asistan',
        'placeholder': 'Cildin ve sağlığın hakkında sor...',
        'greeting':
            'Merhaba! Cilt, uyku ve stres verilerini analiz ettim. Bugün sana nasıl yardımcı olabilirim?',
      },
      'sections': {
        'mental': {
          'title': 'Zihin Dengesi',
          'breath': 'Nefes Egzersizi',
          'journal': 'Duygu Günlüğü',
          'insight': 'Düşük stres tespit edildi.',
        },
        'physical': {
          'title': 'Bedensel İyileşme',
          'recovery': 'Toparlanma Skoru',
          'steps': 'Adımlar',
          'sleep': 'Uyku Kalitesi',
          'energy': 'Enerji',
          'high': 'Yüksek',
          'recommendation': 'Tavsiye',
          'heavyWorkout': 'Ağır Antrenman Uygun',
        },
        'skin': {
          'title': 'Cilt Sağlığı',
          'scan': 'Yüz Taraması Başlat',
          'uv': 'UV İndeksi',
          'moisture': 'Nem',
          'routine': 'Sabah Rutini',
          'barrier': 'Cilt bariyerin güçlü.',
        },
      },
      'welcome': 'Merhaba, Alex',
      'overall': 'Genel',
    },
    'es': {
      'tabs': {
        'home': 'Inicio',
        'mental': 'Mental',
        'physical': 'Físico',
        'skin': 'Piel',
      },
      'ai': {
        'title': 'Asistente IA',
        'placeholder': 'Pregunta sobre tu piel...',
        'greeting':
            '¡Hola! Analicé tus datos de piel, sueño y estrés. ¿Cómo puedo ayudar hoy?',
      },
      'sections': {
        'mental': {
          'title': 'Equilibrio Mental',
          'breath': 'Respiración',
          'journal': 'Diario',
          'insight': 'Bajo estrés detectado.',
        },
        'physical': {
          'title': 'Recuperación',
          'recovery': 'Puntaje Recup.',
          'steps': 'Pasos',
          'sleep': 'Calidad Sueño',
          'energy': 'Energía',
          'high': 'Alta',
          'recommendation': 'Recomendación',
          'heavyWorkout': 'Entrenamiento Intenso Apto',
        },
        'skin': {
          'title': 'Salud de Piel',
          'scan': 'Escanear Cara',
          'uv': 'Índice UV',
          'moisture': 'Humedad',
          'routine': 'Rutina Mañana',
          'barrier': 'Tu barrera cutánea es fuerte.',
        },
      },
      'welcome': 'Hola, Alex',
      'overall': 'General',
    },
    'pl': {
      'tabs': {
        'home': 'Dom',
        'mental': 'Umysł',
        'physical': 'Fizyczne',
        'skin': 'Skóra',
      },
      'ai': {
        'title': 'Asystent AI',
        'placeholder': 'Zapytaj o skórę...',
        'greeting':
            'Cześć! Przeanalizowałem dane dotyczące skóry, snu i stresu. Jak mogę pomóc?',
      },
      'sections': {
        'mental': {
          'title': 'Balans Umysłu',
          'breath': 'Oddech',
          'journal': 'Dziennik',
          'insight': 'Wykryto niski stres.',
        },
        'physical': {
          'title': 'Regeneracja',
          'recovery': 'Wynik Regen.',
          'steps': 'Kroki',
          'sleep': 'Jakość Snu',
          'energy': 'Energia',
          'high': 'Wysoka',
          'recommendation': 'Rekomendacja',
          'heavyWorkout': 'Ciężki Trening Odpowiedni',
        },
        'skin': {
          'title': 'Zdrowie Skóry',
          'scan': 'Skanuj Twarz',
          'uv': 'Indeks UV',
          'moisture': 'Wilgotność',
          'routine': 'Rutyna Rano',
          'barrier': 'Twoja bariera skóry jest silna.',
        },
      },
      'welcome': 'Cześć, Alex',
      'overall': 'Ogólny',
    },
  };

  @override
  void initState() {
    super.initState();
    _skinRoutineState = {for (final step in _skinRoutineSteps) step: false};
  }

  String _lang = 'en';

  Map<String, dynamic> get _t => _translations[_lang]!;

  List<Color> _getGradientColors() {
    switch (_activeTab) {
      case 0: // home
        return [const Color(0xFF1E293B), const Color(0xFF0F172A)];
      case 1: // mental
        return [const Color(0xFF312E81), const Color(0xFF1E1B4B)];
      case 2: // physical
        return [const Color(0xFF064E3B), const Color(0xFF022C22)];
      case 3: // skin
        return [const Color(0xFF7F1D1D), const Color(0xFF991B1B)];
      default:
        return [const Color(0xFF1E293B), const Color(0xFF0F172A)];
    }
  }

  void _handleSendAI() {
    if (_aiInputController.text.trim().isEmpty) return;

    final userMsg = _aiInputController.text.trim();
    _aiInputController.clear();

    setState(() {
      _aiService.addUserMessage(userMsg);
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      final appState = Provider.of<AppState>(context, listen: false);
      final response = _aiService.generateResponse(userMsg, appState);
      setState(() {
        _aiService.addBotMessage(response);
        _scrollToBottom();
      });
    });
  }

  void _scrollToBottom() {
    if (_aiScrollController.hasClients) {
      _aiScrollController.animateTo(
        _aiScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _aiInputController.dispose();
    _aiScrollController.dispose();
    _noteTitleController.dispose();
    _noteContentController.dispose();
    _medNameController.dispose();
    _medDosageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = _getGradientColors();
    final metrics = _metrics[0];

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(child: _buildContent(metrics)),
                  _buildBottomNav(),
                ],
              ),
            ),
          ),
          if (_showAI) _buildAIModal(),
        ],
      ),
      floatingActionButton: _buildAIFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildHeader() {
    final now = DateTime.now();
    final weekdays = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _t['welcome'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
              Text(
                '${weekdays[now.weekday % 7]}, ${now.day} ${months[now.month - 1]}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: ['tr', 'en', 'es', 'pl'].map((lang) {
                final isSelected = _lang == lang;
                return GestureDetector(
                  onTap: () => setState(() => _lang = lang),
                  child: Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        lang.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.black : Colors.white54,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(Map<String, dynamic> metrics) {
    switch (_activeTab) {
      case 0:
        return _buildHome(metrics);
      case 1:
        return _buildMental(metrics);
      case 2:
        return _buildPhysical(metrics);
      case 3:
        return _buildSkin(metrics);
      default:
        return _buildHome(metrics);
    }
  }

  Widget _buildHome(Map<String, dynamic> metrics) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // Hero Score
          Container(
            height: 200,
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.blue.withOpacity(0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 192,
                  height: 192,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF475569),
                      width: 4,
                    ),
                    color: const Color(0xFF1E293B).withOpacity(0.8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '88',
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _t['overall'].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF60A5FA),
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Summary Cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  icon: Icons.psychology_rounded,
                  label: _t['tabs']['mental'],
                  value: '92%',
                  color: const Color(0xFF818CF8),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  icon: Icons.favorite_rounded,
                  label: _t['tabs']['physical'],
                  value: '85%',
                  color: const Color(0xFF34D399),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  icon: Icons.face_rounded,
                  label: _t['tabs']['skin'],
                  value: '82%',
                  color: const Color(0xFFFB7185),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Data Entry Section
          Text(
            _lang == 'tr' ? 'Veri Girişi' : 'Data Entry',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDataEntryButton(
                  icon: Icons.bedtime_rounded,
                  label: _lang == 'tr' ? 'Uyku' : 'Sleep',
                  value: '${_sleepHours}h',
                  onTap: () => _showSleepInputDialog(),
                  color: const Color(0xFF60A5FA),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDataEntryButton(
                  icon: Icons.mood_rounded,
                  label: _lang == 'tr' ? 'Ruh Hali' : 'Mood',
                  value: '$_moodRating/10',
                  onTap: () => _showMoodInputDialog(),
                  color: const Color(0xFF818CF8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Face Photo Section
          Text(
            _lang == 'tr' ? 'Yüz Analizi' : 'Face Analysis',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildFacePhotoSection(),
          const SizedBox(height: 24),
          // Charts Section
          Text(
            _lang == 'tr' ? 'Grafikler' : 'Charts',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildChartsSection(),
        ],
      ),
    );
  }

  Widget _buildDataEntryButton({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B).withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF475569), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacePhotoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF475569), width: 1),
      ),
      child: Column(
        children: [
          if (_faceImage != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                _faceImage!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            if (_faceAnalysis != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _faceAnalysis!,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
            const SizedBox(height: 12),
          ],
          ElevatedButton.icon(
            onPressed: _pickFaceImage,
            icon: const Icon(Icons.camera_alt_rounded),
            label: Text(
              _faceImage == null
                  ? (_lang == 'tr' ? 'Fotoğraf Yükle' : 'Upload Photo')
                  : (_lang == 'tr' ? 'Yeniden Yükle' : 'Retake'),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection() {
    final appState = Provider.of<AppState>(context);

    // Get last 7 days of data
    final now = DateTime.now();
    final weekStart = now.subtract(const Duration(days: 6));

    // Sleep data
    final sleepData = appState.sleepData
        .where((d) => d.timestamp.isAfter(weekStart))
        .toList();
    final sleepSpots = _generateSleepSpots(sleepData);

    // Steps data
    final stepsData = appState.stepsData
        .where((d) => d.timestamp.isAfter(weekStart))
        .toList();
    final stepsSpots = _generateStepsSpots(stepsData);

    // Heart rate data
    final hrData = appState.heartRateData
        .where((d) => d.timestamp.isAfter(weekStart))
        .toList();
    final hrSpots = _generateHeartRateSpots(hrData);

    // Stress data (from mental health entries)
    final stressData = appState.mentalHealthEntries
        .where((e) => e.timestamp.isAfter(weekStart))
        .toList();
    final stressSpots = _generateStressSpots(stressData);

    return Column(
      children: [
        // Steps Chart
        _buildProfessionalChart(
          title: _lang == 'tr'
              ? 'Günlük Adımlar (7 Gün)'
              : 'Daily Steps (7 Days)',
          icon: Icons.directions_walk_rounded,
          color: const Color(0xFF10B981),
          spots: stepsSpots,
          maxY: 15000,
          unit: _lang == 'tr' ? 'adım' : 'steps',
          isSteps: true,
        ),
        const SizedBox(height: 16),
        // Sleep Chart
        _buildProfessionalChart(
          title: _lang == 'tr' ? 'Uyku Skoru (7 Gün)' : 'Sleep Score (7 Days)',
          icon: Icons.bedtime_rounded,
          color: const Color(0xFF60A5FA),
          spots: sleepSpots,
          maxY: 10,
          unit: _lang == 'tr' ? 'saat' : 'hours',
          isSteps: false,
        ),
        const SizedBox(height: 16),
        // Heart Rate Chart
        _buildProfessionalChart(
          title: _lang == 'tr'
              ? 'Kalp Atış Hızı (7 Gün)'
              : 'Heart Rate (7 Days)',
          icon: Icons.favorite_rounded,
          color: const Color(0xFFEF4444),
          spots: hrSpots,
          maxY: 100,
          unit: 'bpm',
          isSteps: false,
        ),
        const SizedBox(height: 16),
        // Stress Level Chart
        _buildProfessionalChart(
          title: _lang == 'tr'
              ? 'Stres Seviyesi (7 Gün)'
              : 'Stress Level (7 Days)',
          icon: Icons.psychology_rounded,
          color: const Color(0xFF818CF8),
          spots: stressSpots,
          maxY: 10,
          unit: '/10',
          isSteps: false,
        ),
      ],
    );
  }

  List<FlSpot> _generateSleepSpots(List<SleepData> data) {
    if (data.isEmpty) {
      return List.generate(7, (i) => FlSpot(i.toDouble(), 7.5));
    }

    final Map<int, List<double>> dailySleep = {};
    for (var entry in data) {
      final day = entry.timestamp
          .difference(DateTime.now().subtract(const Duration(days: 6)))
          .inDays;
      if (day >= 0 && day < 7) {
        dailySleep.putIfAbsent(day, () => []).add(entry.value ?? 0);
      }
    }

    return List.generate(7, (i) {
      if (dailySleep.containsKey(i) && dailySleep[i]!.isNotEmpty) {
        final avg =
            dailySleep[i]!.reduce((a, b) => a + b) / dailySleep[i]!.length;
        return FlSpot(i.toDouble(), avg);
      }
      return FlSpot(i.toDouble(), 7.5);
    });
  }

  List<FlSpot> _generateStepsSpots(List<StepsData> data) {
    if (data.isEmpty) {
      return List.generate(7, (i) => FlSpot(i.toDouble(), 8000));
    }

    final Map<int, int> dailySteps = {};
    for (var entry in data) {
      final day = entry.timestamp
          .difference(DateTime.now().subtract(const Duration(days: 6)))
          .inDays;
      if (day >= 0 && day < 7) {
        dailySteps[day] = (dailySteps[day] ?? 0) + (entry.value?.toInt() ?? 0);
      }
    }

    return List.generate(7, (i) {
      return FlSpot(i.toDouble(), (dailySteps[i] ?? 8000).toDouble());
    });
  }

  List<FlSpot> _generateHeartRateSpots(List<HeartRateData> data) {
    if (data.isEmpty) {
      return List.generate(7, (i) => FlSpot(i.toDouble(), 72));
    }

    final Map<int, List<double>> dailyHR = {};
    for (var entry in data) {
      final day = entry.timestamp
          .difference(DateTime.now().subtract(const Duration(days: 6)))
          .inDays;
      if (day >= 0 && day < 7) {
        dailyHR.putIfAbsent(day, () => []).add(entry.value ?? 0);
      }
    }

    return List.generate(7, (i) {
      if (dailyHR.containsKey(i) && dailyHR[i]!.isNotEmpty) {
        final avg = dailyHR[i]!.reduce((a, b) => a + b) / dailyHR[i]!.length;
        return FlSpot(i.toDouble(), avg);
      }
      return FlSpot(i.toDouble(), 72);
    });
  }

  List<FlSpot> _generateStressSpots(List<MentalHealthEntry> data) {
    if (data.isEmpty) {
      return List.generate(7, (i) => FlSpot(i.toDouble(), 3));
    }

    final Map<int, List<int>> dailyStress = {};
    for (var entry in data) {
      final day = entry.timestamp
          .difference(DateTime.now().subtract(const Duration(days: 6)))
          .inDays;
      if (day >= 0 && day < 7 && entry.stress != null) {
        dailyStress.putIfAbsent(day, () => []).add(entry.stress!);
      }
    }

    return List.generate(7, (i) {
      if (dailyStress.containsKey(i) && dailyStress[i]!.isNotEmpty) {
        final avg =
            dailyStress[i]!.reduce((a, b) => a + b) / dailyStress[i]!.length;
        return FlSpot(i.toDouble(), avg.toDouble());
      }
      return FlSpot(i.toDouble(), 3);
    });
  }

  Widget _buildProfessionalChart({
    required String title,
    required IconData icon,
    required Color color,
    required List<FlSpot> spots,
    required double maxY,
    required String unit,
    required bool isSteps,
  }) {
    final weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF475569), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              if (spots.isNotEmpty)
                Text(
                  isSteps
                      ? '${spots.last.y.toInt()} $unit'
                      : '${spots.last.y.toStringAsFixed(1)} $unit',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 4,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.white.withOpacity(0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < 7) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              weekDays[value.toInt()],
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 12,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        if (value % (maxY / 4) == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              isSteps
                                  ? '${(value / 1000).toStringAsFixed(1)}k'
                                  : value.toStringAsFixed(0),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 11,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                      interval: maxY / 4,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                    left: BorderSide(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: color,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: color,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          color.withOpacity(0.3),
                          color.withOpacity(0.05),
                        ],
                      ),
                    ),
                  ),
                ],
                minY: 0,
                maxY: maxY,
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => color.withOpacity(0.9),
                    tooltipPadding: const EdgeInsets.all(8),
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          isSteps
                              ? '${spot.y.toInt()} $unit'
                              : '${spot.y.toStringAsFixed(1)} $unit',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFaceImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
      );

      if (image != null) {
        setState(() {
          _faceImage = File(image.path);
          _faceAnalysis = _analyzeFaceImage();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    }
  }

  String _analyzeFaceImage() {
    // Simulated AI analysis
    final analyses = [
      _lang == 'tr'
          ? 'Cildiniz iyi görünüyor! Nem seviyesi yeterli ve cilt bariyeri güçlü.'
          : 'Your skin looks good! Hydration level is adequate and skin barrier is strong.',
      _lang == 'tr'
          ? 'Hafif kuruluk tespit edildi. Nemlendirici kullanmanız önerilir.'
          : 'Slight dryness detected. Using moisturizer is recommended.',
      _lang == 'tr'
          ? 'Cildiniz parlak ve sağlıklı görünüyor. Mevcut rutininizi sürdürün.'
          : 'Your skin looks bright and healthy. Continue your current routine.',
    ];
    return analyses[DateTime.now().millisecond % analyses.length];
  }

  void _showSleepInputDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_lang == 'tr' ? 'Uyku Saati' : 'Sleep Hours'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${_sleepHours.toStringAsFixed(1)} ${_lang == 'tr' ? 'saat' : 'hours'}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Slider(
                value: _sleepHours,
                min: 4,
                max: 12,
                divisions: 16,
                onChanged: (value) {
                  setState(() => _sleepHours = value);
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_lang == 'tr' ? 'İptal' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
            child: Text(_lang == 'tr' ? 'Kaydet' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _showMoodInputDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_lang == 'tr' ? 'Ruh Hali' : 'Mood'),
        content: StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  children: List.generate(10, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() => _moodRating = index + 1);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.star_rounded,
                          color: index < _moodRating
                              ? Colors.amber
                              : Colors.grey,
                          size: 32,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                Text(
                  '$_moodRating/10',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_lang == 'tr' ? 'İptal' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
            child: Text(_lang == 'tr' ? 'Kaydet' : 'Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF475569), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.white54),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMental(Map<String, dynamic> metrics) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF6366F1).withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.psychology_rounded,
                      color: Color(0xFFC7D2FE),
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _t['sections']['mental']['title'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFC7D2FE),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _t['sections']['mental']['insight'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFA5B4FC),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              'Low',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              '/ Stress',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF818CF8),
                          width: 4,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          '30',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.air_rounded,
                  label: _t['sections']['mental']['breath'],
                  color: const Color(0xFF60A5FA),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.calendar_today_rounded,
                  label: _t['sections']['mental']['journal'],
                  color: const Color(0xFFA78BFA),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Notes Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _lang == 'tr' ? 'Notlarım' : 'My Notes',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: _showAddNoteDialog,
                icon: const Icon(
                  Icons.add_circle_rounded,
                  color: Color(0xFF818CF8),
                ),
                iconSize: 28,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildNotesList(),
          const SizedBox(height: 24),
          // Medication Schedule
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _lang == 'tr' ? 'İlaç Takvimi' : 'Medication Schedule',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: _showAddMedicationDialog,
                icon: const Icon(
                  Icons.add_circle_rounded,
                  color: Color(0xFF818CF8),
                ),
                iconSize: 28,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildMedicationList(),
        ],
      ),
    );
  }

  Widget _buildNotesList() {
    if (_notes.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B).withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF475569), width: 1),
        ),
        child: Column(
          children: [
            Icon(
              Icons.note_add_rounded,
              size: 48,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 12),
            Text(
              _lang == 'tr' ? 'Henüz not eklenmedi' : 'No notes yet',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: _notes.map((note) => _buildNoteCard(note)).toList(),
    );
  }

  Widget _buildNoteCard(Note note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF475569), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  note.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit_rounded,
                      size: 18,
                      color: Color(0xFF818CF8),
                    ),
                    onPressed: () => _editNote(note),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_rounded,
                      size: 18,
                      color: Colors.red,
                    ),
                    onPressed: () => _deleteNote(note),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            note.content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            _formatDate(note.createdAt),
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationList() {
    if (_medications.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B).withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF475569), width: 1),
        ),
        child: Column(
          children: [
            Icon(
              Icons.medication_rounded,
              size: 48,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 12),
            Text(
              _lang == 'tr' ? 'Henüz ilaç eklenmedi' : 'No medications yet',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: _medications.map((med) => _buildMedicationCard(med)).toList(),
    );
  }

  Widget _buildMedicationCard(Medication med) {
    final today = DateTime.now();
    final isToday = med.daysOfWeek.contains(today.weekday % 7);
    final nextTime = _getNextMedicationTime(med);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isToday && med.isActive
            ? const Color(0xFF4F46E5).withOpacity(0.2)
            : const Color(0xFF1E293B).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isToday && med.isActive
              ? const Color(0xFF818CF8)
              : const Color(0xFF475569),
          width: isToday && med.isActive ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.medication_liquid_rounded,
                      color: isToday && med.isActive
                          ? const Color(0xFF818CF8)
                          : Colors.white70,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            med.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isToday && med.isActive
                                  ? Colors.white
                                  : Colors.white70,
                            ),
                          ),
                          Text(
                            med.dosage,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  if (isToday && med.isActive && nextTime != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _formatTime(nextTime),
                        style: const TextStyle(
                          color: Color(0xFF10B981),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  IconButton(
                    icon: const Icon(
                      Icons.edit_rounded,
                      size: 18,
                      color: Color(0xFF818CF8),
                    ),
                    onPressed: () => _editMedication(med),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_rounded,
                      size: 18,
                      color: Colors.red,
                    ),
                    onPressed: () => _deleteMedication(med),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              _buildDayChip('Sun', 0, med.daysOfWeek),
              _buildDayChip('Mon', 1, med.daysOfWeek),
              _buildDayChip('Tue', 2, med.daysOfWeek),
              _buildDayChip('Wed', 3, med.daysOfWeek),
              _buildDayChip('Thu', 4, med.daysOfWeek),
              _buildDayChip('Fri', 5, med.daysOfWeek),
              _buildDayChip('Sat', 6, med.daysOfWeek),
            ],
          ),
          if (med.times.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 16,
                  color: Colors.white54,
                ),
                const SizedBox(width: 4),
                Text(
                  med.times.map((t) => _formatTimeOfDay(t)).join(', '),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDayChip(String label, int day, List<int> selectedDays) {
    final isSelected = selectedDays.contains(day);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF818CF8).withOpacity(0.3)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF818CF8)
              : Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: isSelected ? Colors.white : Colors.white54,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  TimeOfDay? _getNextMedicationTime(Medication med) {
    if (!med.isActive || med.times.isEmpty) return null;
    final now = TimeOfDay.now();
    for (final time in med.times) {
      if (time.hour > now.hour ||
          (time.hour == now.hour && time.minute > now.minute)) {
        return time;
      }
    }
    return med.times.first;
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatTime(TimeOfDay time) {
    return _formatTimeOfDay(time);
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return _lang == 'tr' ? 'Bugün' : 'Today';
    } else if (difference == 1) {
      return _lang == 'tr' ? 'Dün' : 'Yesterday';
    } else if (difference < 7) {
      return _lang == 'tr' ? '$difference gün önce' : '$difference days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showAddNoteDialog() {
    _noteTitleController.clear();
    _noteContentController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(
          _lang == 'tr' ? 'Yeni Not' : 'New Note',
          style: const TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _noteTitleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: _lang == 'tr' ? 'Başlık' : 'Title',
                  labelStyle: const TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF475569)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF475569)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF818CF8)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _noteContentController,
                style: const TextStyle(color: Colors.white),
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: _lang == 'tr' ? 'İçerik' : 'Content',
                  labelStyle: const TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF475569)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF475569)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF818CF8)),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_lang == 'tr' ? 'İptal' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_noteTitleController.text.isNotEmpty &&
                  _noteContentController.text.isNotEmpty) {
                final note = Note(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: _noteTitleController.text,
                  content: _noteContentController.text,
                  createdAt: DateTime.now(),
                );
                setState(() {
                  _notes.add(note);
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF818CF8),
            ),
            child: Text(_lang == 'tr' ? 'Kaydet' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _editNote(Note note) {
    _noteTitleController.text = note.title;
    _noteContentController.text = note.content;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(
          _lang == 'tr' ? 'Notu Düzenle' : 'Edit Note',
          style: const TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _noteTitleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: _lang == 'tr' ? 'Başlık' : 'Title',
                  labelStyle: const TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF475569)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF475569)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF818CF8)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _noteContentController,
                style: const TextStyle(color: Colors.white),
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: _lang == 'tr' ? 'İçerik' : 'Content',
                  labelStyle: const TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF475569)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF475569)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF818CF8)),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_lang == 'tr' ? 'İptal' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_noteTitleController.text.isNotEmpty &&
                  _noteContentController.text.isNotEmpty) {
                setState(() {
                  final index = _notes.indexWhere((n) => n.id == note.id);
                  if (index != -1) {
                    _notes[index] = Note(
                      id: note.id,
                      title: _noteTitleController.text,
                      content: _noteContentController.text,
                      createdAt: note.createdAt,
                      updatedAt: DateTime.now(),
                    );
                  }
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF818CF8),
            ),
            child: Text(_lang == 'tr' ? 'Güncelle' : 'Update'),
          ),
        ],
      ),
    );
  }

  void _deleteNote(Note note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(
          _lang == 'tr' ? 'Notu Sil' : 'Delete Note',
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          _lang == 'tr'
              ? 'Bu notu silmek istediğinize emin misiniz?'
              : 'Are you sure you want to delete this note?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_lang == 'tr' ? 'İptal' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _notes.removeWhere((n) => n.id == note.id);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(_lang == 'tr' ? 'Sil' : 'Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddMedicationDialog() {
    _medNameController.clear();
    _medDosageController.clear();
    List<int> selectedDays = [];
    List<TimeOfDay> selectedTimes = [];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: Text(
            _lang == 'tr' ? 'Yeni İlaç' : 'New Medication',
            style: const TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _medNameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: _lang == 'tr' ? 'İlaç Adı' : 'Medication Name',
                    labelStyle: const TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF475569)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF475569)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF818CF8)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _medDosageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: _lang == 'tr' ? 'Dozaj' : 'Dosage',
                    labelStyle: const TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF475569)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF475569)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF818CF8)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _lang == 'tr' ? 'Haftanın Günleri' : 'Days of Week',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildDaySelector('Sun', 0, selectedDays, setDialogState),
                    _buildDaySelector('Mon', 1, selectedDays, setDialogState),
                    _buildDaySelector('Tue', 2, selectedDays, setDialogState),
                    _buildDaySelector('Wed', 3, selectedDays, setDialogState),
                    _buildDaySelector('Thu', 4, selectedDays, setDialogState),
                    _buildDaySelector('Fri', 5, selectedDays, setDialogState),
                    _buildDaySelector('Sat', 6, selectedDays, setDialogState),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  _lang == 'tr' ? 'Saatler' : 'Times',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                ...selectedTimes.asMap().entries.map((entry) {
                  final index = entry.key;
                  final time = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _formatTimeOfDay(time),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed: () {
                            setDialogState(() {
                              selectedTimes.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                }),
                ElevatedButton.icon(
                  onPressed: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      setDialogState(() {
                        selectedTimes.add(time);
                        selectedTimes.sort((a, b) {
                          if (a.hour != b.hour) return a.hour.compareTo(b.hour);
                          return a.minute.compareTo(b.minute);
                        });
                      });
                    }
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(_lang == 'tr' ? 'Saat Ekle' : 'Add Time'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF818CF8),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_lang == 'tr' ? 'İptal' : 'Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_medNameController.text.isNotEmpty &&
                    _medDosageController.text.isNotEmpty &&
                    selectedDays.isNotEmpty &&
                    selectedTimes.isNotEmpty) {
                  final med = Medication(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: _medNameController.text,
                    dosage: _medDosageController.text,
                    daysOfWeek: selectedDays,
                    times: selectedTimes,
                    startDate: DateTime.now(),
                  );
                  setState(() {
                    _medications.add(med);
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF818CF8),
              ),
              child: Text(_lang == 'tr' ? 'Kaydet' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySelector(
    String label,
    int day,
    List<int> selectedDays,
    StateSetter setDialogState,
  ) {
    final isSelected = selectedDays.contains(day);
    return GestureDetector(
      onTap: () {
        setDialogState(() {
          if (isSelected) {
            selectedDays.remove(day);
          } else {
            selectedDays.add(day);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF818CF8).withOpacity(0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF818CF8)
                : Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.white : Colors.white54,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _editMedication(Medication med) {
    _medNameController.text = med.name;
    _medDosageController.text = med.dosage;
    List<int> selectedDays = List.from(med.daysOfWeek);
    List<TimeOfDay> selectedTimes = List.from(med.times);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: Text(
            _lang == 'tr' ? 'İlacı Düzenle' : 'Edit Medication',
            style: const TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _medNameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: _lang == 'tr' ? 'İlaç Adı' : 'Medication Name',
                    labelStyle: const TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF475569)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF475569)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF818CF8)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _medDosageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: _lang == 'tr' ? 'Dozaj' : 'Dosage',
                    labelStyle: const TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF475569)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF475569)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF818CF8)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _lang == 'tr' ? 'Haftanın Günleri' : 'Days of Week',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildDaySelector('Sun', 0, selectedDays, setDialogState),
                    _buildDaySelector('Mon', 1, selectedDays, setDialogState),
                    _buildDaySelector('Tue', 2, selectedDays, setDialogState),
                    _buildDaySelector('Wed', 3, selectedDays, setDialogState),
                    _buildDaySelector('Thu', 4, selectedDays, setDialogState),
                    _buildDaySelector('Fri', 5, selectedDays, setDialogState),
                    _buildDaySelector('Sat', 6, selectedDays, setDialogState),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  _lang == 'tr' ? 'Saatler' : 'Times',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                ...selectedTimes.asMap().entries.map((entry) {
                  final index = entry.key;
                  final time = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _formatTimeOfDay(time),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed: () {
                            setDialogState(() {
                              selectedTimes.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                }),
                ElevatedButton.icon(
                  onPressed: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      setDialogState(() {
                        selectedTimes.add(time);
                        selectedTimes.sort((a, b) {
                          if (a.hour != b.hour) return a.hour.compareTo(b.hour);
                          return a.minute.compareTo(b.minute);
                        });
                      });
                    }
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(_lang == 'tr' ? 'Saat Ekle' : 'Add Time'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF818CF8),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_lang == 'tr' ? 'İptal' : 'Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_medNameController.text.isNotEmpty &&
                    _medDosageController.text.isNotEmpty &&
                    selectedDays.isNotEmpty &&
                    selectedTimes.isNotEmpty) {
                  setState(() {
                    final index = _medications.indexWhere(
                      (m) => m.id == med.id,
                    );
                    if (index != -1) {
                      _medications[index] = Medication(
                        id: med.id,
                        name: _medNameController.text,
                        dosage: _medDosageController.text,
                        daysOfWeek: selectedDays,
                        times: selectedTimes,
                        startDate: med.startDate,
                        isActive: med.isActive,
                      );
                    }
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF818CF8),
              ),
              child: Text(_lang == 'tr' ? 'Güncelle' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteMedication(Medication med) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(
          _lang == 'tr' ? 'İlacı Sil' : 'Delete Medication',
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          _lang == 'tr'
              ? 'Bu ilacı silmek istediğinize emin misiniz?'
              : 'Are you sure you want to delete this medication?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_lang == 'tr' ? 'İptal' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _medications.removeWhere((m) => m.id == med.id);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(_lang == 'tr' ? 'Sil' : 'Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildPhysical(Map<String, dynamic> metrics) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF059669).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF10B981).withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.favorite_rounded,
                      color: Color(0xFF6EE7B7),
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _t['sections']['physical']['title'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6EE7B7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildProgressBar(
                  label: '${_t['sections']['physical']['recovery']} (HRV)',
                  value: '${metrics['hrv']} ms',
                  progress: 0.65,
                  color: const Color(0xFF10B981),
                ),
                const SizedBox(height: 16),
                _buildProgressBar(
                  label: _t['sections']['physical']['sleep'],
                  value: '${metrics['sleep']} h',
                  progress: 0.75,
                  color: const Color(0xFF60A5FA),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF475569)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF97316).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.bolt_rounded,
                        color: Color(0xFFF97316),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _t['sections']['physical']['energy'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white54,
                          ),
                        ),
                        Text(
                          _t['sections']['physical']['high'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _t['sections']['physical']['recommendation'],
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white38,
                      ),
                    ),
                    Text(
                      _t['sections']['physical']['heavyWorkout'],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF34D399),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar({
    required String label,
    required String value,
    required double progress,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: color.withOpacity(0.8)),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFF475569),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkin(Map<String, dynamic> metrics) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFBE123C).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFFB7185).withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.water_drop_rounded,
                      color: Color(0xFFFCA5A5),
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _t['sections']['skin']['title'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFCA5A5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    const Text(
                      '82',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      '/100',
                      style: TextStyle(fontSize: 20, color: Color(0xFFFCA5A5)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _t['sections']['skin']['barrier'],
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFCA5A5),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.face_rounded, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          _t['sections']['skin']['scan'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  icon: Icons.wb_sunny_rounded,
                  label: _t['sections']['skin']['uv'],
                  value: '3',
                  subtitle: 'Medium',
                  color: const Color(0xFFFBBF24),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  icon: Icons.water_drop_rounded,
                  label: _t['sections']['skin']['moisture'],
                  value: '72%',
                  subtitle: 'Good',
                  color: const Color(0xFF60A5FA),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B).withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF475569)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _t['sections']['skin']['routine'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 12),
                ..._skinRoutineSteps.map((item) {
                  final isCompleted = _skinRoutineState[item] ?? false;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        setState(() {
                          _skinRoutineState[item] = !isCompleted;
                        });
                      },
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isCompleted
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFF475569),
                              ),
                              color: isCompleted
                                  ? const Color(0xFF10B981)
                                  : Colors.transparent,
                            ),
                            child: isCompleted
                                ? const Icon(
                                    Icons.check,
                                    size: 14,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item,
                              style: TextStyle(
                                fontSize: 14,
                                color: isCompleted
                                    ? Colors.white54
                                    : Colors.white,
                                decoration: isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String label,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF475569)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 4),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: color,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.white54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF475569)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    final tabs = [
      {'id': 0, 'icon': Icons.home_rounded, 'label': _t['tabs']['home']},
      {
        'id': 1,
        'icon': Icons.psychology_rounded,
        'label': _t['tabs']['mental'],
      },
      {
        'id': 2,
        'icon': Icons.favorite_rounded,
        'label': _t['tabs']['physical'],
      },
      {'id': 3, 'icon': Icons.face_rounded, 'label': _t['tabs']['skin']},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.9),
        border: Border(
          top: BorderSide(color: const Color(0xFF1E293B), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: tabs.map((tab) {
          final isActive = _activeTab == tab['id'];
          final colors = [
            Colors.white,
            const Color(0xFF818CF8),
            const Color(0xFF34D399),
            const Color(0xFFFB7185),
          ];
          return GestureDetector(
            onTap: () => setState(() => _activeTab = tab['id'] as int),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.white.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    tab['icon'] as IconData,
                    size: 22,
                    color: isActive ? colors[tab['id'] as int] : Colors.white54,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tab['label'] as String,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: isActive
                          ? colors[tab['id'] as int]
                          : Colors.white54,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAIFAB() {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset + 64),
      child: FloatingActionButton(
        onPressed: () => setState(() => _showAI = true),
        backgroundColor: const Color(0xFF6366F1),
        child: const Icon(Icons.chat_bubble_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildAIModal() {
    return Container(
      color: const Color(0xFF0F172A).withOpacity(0.95),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF0F172A),
              border: Border(
                bottom: BorderSide(color: Color(0xFF1E293B), width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.psychology_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _t['ai']['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => setState(() => _showAI = false),
                  icon: const Icon(Icons.close_rounded, color: Colors.white54),
                ),
              ],
            ),
          ),
          // Messages
          Expanded(
            child: ListView(
              controller: _aiScrollController,
              padding: const EdgeInsets.all(16),
              children: [
                _buildAIMessage(_t['ai']['greeting'], isUser: false),
                ..._aiService.messages.map(
                  (msg) => _buildAIMessage(msg.text, isUser: msg.isUser),
                ),
              ],
            ),
          ),
          // Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF0F172A),
              border: Border(
                top: BorderSide(color: Color(0xFF1E293B), width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _aiInputController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: _t['ai']['placeholder'],
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: const Color(0xFF1E293B),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: Color(0xFF475569)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: Color(0xFF475569)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: Color(0xFF6366F1)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _handleSendAI(),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _handleSendAI,
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIMessage(String text, {required bool isUser}) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF6366F1) : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12).copyWith(
            topRight: isUser ? const Radius.circular(4) : null,
            topLeft: !isUser ? const Radius.circular(4) : null,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: isUser ? Colors.white : Colors.white70,
          ),
        ),
      ),
    );
  }
}
