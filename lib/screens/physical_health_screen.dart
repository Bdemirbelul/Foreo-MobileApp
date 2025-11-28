import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foreo_app/l10n/generated/app_localizations.dart';
import '../services/app_state.dart';
import '../widgets/health_chart.dart';
import '../models/health_metric.dart';
import '../theme/app_theme.dart';
import '../widgets/modern_app_bar.dart';

enum _PhysicalReadiness { recovery, balanced, peak }

class _WorkoutDayPlan {
  const _WorkoutDayPlan({
    required this.day,
    required this.focus,
    required this.activities,
    this.isRest = false,
    this.targetMinutes,
    this.coachNote,
  });

  final String day;
  final String focus;
  final List<String> activities;
  final bool isRest;
  final int? targetMinutes;
  final String? coachNote;

  _WorkoutDayPlan copyWith({
    String? day,
    String? focus,
    List<String>? activities,
    bool? isRest,
    int? targetMinutes,
    String? coachNote,
  }) {
    return _WorkoutDayPlan(
      day: day ?? this.day,
      focus: focus ?? this.focus,
      activities: activities ?? this.activities,
      isRest: isRest ?? this.isRest,
      targetMinutes: targetMinutes ?? this.targetMinutes,
      coachNote: coachNote ?? this.coachNote,
    );
  }
}

class PhysicalHealthScreen extends StatefulWidget {
  const PhysicalHealthScreen({super.key});

  @override
  State<PhysicalHealthScreen> createState() => _PhysicalHealthScreenState();
}

class _PhysicalHealthScreenState extends State<PhysicalHealthScreen> {
  String _selectedPeriod = 'week';
  final _plannerFormKey = GlobalKey<FormState>();
  final _ageController = TextEditingController(text: '30');
  final _waterController = TextEditingController(text: '2200');
  final _durationController = TextEditingController(text: '45');
  bool _plannerGenerated = false;
  List<_WorkoutDayPlan> _plannerResults = [];
  int _plannerAge = 30;
  int _plannerWater = 2200;
  int _plannerMinutes = 45;
  _PhysicalReadiness? _plannerReadiness;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final appState = context.read<AppState>();
      _generatePlanner(appState);
    });
  }

  @override
  void dispose() {
    _ageController.dispose();
    _waterController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  _PhysicalReadiness _computeReadiness(AppState appState) {
    final hrv = _latestValue(appState.hrvData, 70);
    final sleep = _latestValue(appState.sleepData, 6.0);
    final steps = _latestValue(appState.stepsData, 5000);

    double normalize(double value, double min, double max) {
      if ((max - min) == 0) return 0;
      return ((value - min) / (max - min)).clamp(0, 1);
    }

    final readinessScore =
        (0.4 * normalize(hrv, 60, 110)) +
        (0.35 * normalize(sleep, 5.5, 8.5)) +
        (0.25 * normalize(steps, 4000, 11000));

    if (readinessScore >= 0.75) return _PhysicalReadiness.peak;
    if (readinessScore >= 0.5) return _PhysicalReadiness.balanced;
    return _PhysicalReadiness.recovery;
  }

  double _latestValue(List<HealthMetric> data, double fallback) {
    if (data.isEmpty) return fallback;
    return data.last.value ?? fallback;
  }

  Color _readinessColor(_PhysicalReadiness readiness) {
    switch (readiness) {
      case _PhysicalReadiness.peak:
        return const Color(0xFF34D399);
      case _PhysicalReadiness.balanced:
        return const Color(0xFFFACC15);
      case _PhysicalReadiness.recovery:
        return const Color(0xFF60A5FA);
    }
  }

  String _readinessLabel(_PhysicalReadiness readiness) {
    switch (readiness) {
      case _PhysicalReadiness.peak:
        return 'Yüksek enerji';
      case _PhysicalReadiness.balanced:
        return 'Dengeli';
      case _PhysicalReadiness.recovery:
        return 'Toparlanma modu';
    }
  }

  String _readinessRecommendation(_PhysicalReadiness readiness) {
    switch (readiness) {
      case _PhysicalReadiness.peak:
        return 'You can push heavy intensity today';
      case _PhysicalReadiness.balanced:
        return 'Aim for moderate intensity plus mobility';
      case _PhysicalReadiness.recovery:
        return 'Prioritize light movement & active recovery';
    }
  }

  String _readinessDescription(_PhysicalReadiness readiness) {
    switch (readiness) {
      case _PhysicalReadiness.peak:
        return 'Your metrics are peaking, so we planned a performance-ready week.';
      case _PhysicalReadiness.balanced:
        return 'Expect a balanced mix of load and recovery that matches your rhythm.';
      case _PhysicalReadiness.recovery:
        return 'Sleep and HRV call for recovery, so stay consistent but gentle.';
    }
  }

  void _generatePlanner(AppState appState, {bool fromUser = false}) {
    if (fromUser && !(_plannerFormKey.currentState?.validate() ?? false)) {
      return;
    }
    final age = int.parse(_ageController.text);
    final water = int.parse(_waterController.text);
    final minutes = int.parse(_durationController.text);
    final readiness = _computeReadiness(appState);
    final plan = _buildAdaptivePlan(readiness, age, water, minutes);

    setState(() {
      _plannerGenerated = true;
      _plannerResults = plan;
      _plannerAge = age;
      _plannerWater = water;
      _plannerMinutes = minutes;
      _plannerReadiness = readiness;
    });
  }

  Widget _buildStatChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white.withOpacity(0.04),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Text(value, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    String? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        filled: true,
        fillColor: Colors.white.withOpacity(0.04),
        labelStyle: const TextStyle(color: Colors.white70),
        suffixStyle: const TextStyle(color: Colors.white60),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF6366F1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
    );
  }

  Widget _buildSummaryChip(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.04),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
          Text(value, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildPlanTile(_WorkoutDayPlan plan, Color accent) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        color: Colors.white.withOpacity(0.02),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                plan.day,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  plan.focus,
                  style: TextStyle(
                    color: accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          if (plan.targetMinutes != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: accent.withOpacity(0.12),
              ),
              child: Text(
                'Hedef süre: ${plan.targetMinutes} dk',
                style: TextStyle(
                  color: accent,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          for (final activity in plan.activities)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(
                    plan.isRest ? Icons.self_improvement : Icons.check_circle,
                    size: 18,
                    color: accent.withOpacity(0.8),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      activity,
                      style: TextStyle(
                        color: plan.isRest
                            ? Colors.white.withOpacity(0.7)
                            : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (plan.coachNote != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white.withOpacity(0.04),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 18, color: accent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      plan.coachNote!,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<_WorkoutDayPlan> _buildWeeklyPlan(_PhysicalReadiness readiness) {
    switch (readiness) {
      case _PhysicalReadiness.peak:
        return [
          const _WorkoutDayPlan(
            day: 'Pazartesi',
            focus: 'Güç',
            activities: ['45 dk tam vücut kuvvet', '10 dk core & mobilite'],
          ),
          const _WorkoutDayPlan(
            day: 'Salı',
            focus: 'Kardiyo',
            activities: ['30 dk interval koşu', '15 dk nefes egzersizi'],
          ),
          const _WorkoutDayPlan(
            day: 'Çarşamba',
            focus: 'Aktif dinlenme',
            activities: ['20 dk yoga akışı', '30 dk tempolu yürüyüş'],
            isRest: true,
          ),
          const _WorkoutDayPlan(
            day: 'Perşembe',
            focus: 'HIIT',
            activities: ['6x tabata döngüsü', '10 dk kuvvet bandı'],
          ),
          const _WorkoutDayPlan(
            day: 'Cuma',
            focus: 'Güç',
            activities: ['Üst vücut + core', '12 dk esneme'],
          ),
          const _WorkoutDayPlan(
            day: 'Cumartesi',
            focus: 'Dayanıklılık',
            activities: ['60 dk outdoor aktivite', '5 dk refleksiyon'],
          ),
          const _WorkoutDayPlan(
            day: 'Pazar',
            focus: 'Restoratif',
            activities: ['Yin yoga', 'Uzun nefes çalışması'],
            isRest: true,
          ),
        ];
      case _PhysicalReadiness.balanced:
        return [
          const _WorkoutDayPlan(
            day: 'Pazartesi',
            focus: 'Fonksiyonel',
            activities: ['35 dk fonksiyonel kuvvet', '8 dk foam roller'],
          ),
          const _WorkoutDayPlan(
            day: 'Salı',
            focus: 'Cardio Flow',
            activities: ['25 dk düşük yoğunluk', '15 dk mobility'],
          ),
          const _WorkoutDayPlan(
            day: 'Çarşamba',
            focus: 'Reset',
            activities: ['Hafif yoga', '10 dk meditasyon'],
            isRest: true,
          ),
          const _WorkoutDayPlan(
            day: 'Perşembe',
            focus: 'Kuvvet',
            activities: ['Vücut ağırlığı devresi', 'Core stabilizasyon'],
          ),
          const _WorkoutDayPlan(
            day: 'Cuma',
            focus: 'Ritim',
            activities: ['30 dk hızlı yürüyüş', '5 dk box breathing'],
          ),
          const _WorkoutDayPlan(
            day: 'Cumartesi',
            focus: 'Keyifli hareket',
            activities: ['Dans / pilates', 'Kısa esneme serisi'],
          ),
          const _WorkoutDayPlan(
            day: 'Pazar',
            focus: 'Aktif dinlenme',
            activities: ['Doğa yürüyüşü', 'Şükran günlüğü'],
            isRest: true,
          ),
        ];
      case _PhysicalReadiness.recovery:
        return [
          const _WorkoutDayPlan(
            day: 'Pazartesi',
            focus: 'Recovery',
            activities: ['20 dk nefes & mobilite', 'Erken uyku planı'],
            isRest: true,
          ),
          const _WorkoutDayPlan(
            day: 'Salı',
            focus: 'Hafif yürüyüş',
            activities: ['20-30 dk rahat tempo', '5 dk esneme'],
          ),
          const _WorkoutDayPlan(
            day: 'Çarşamba',
            focus: 'Yin yoga',
            activities: ['Nazik yoga dizisi', 'Gün sonunda sıcak duş'],
            isRest: true,
          ),
          const _WorkoutDayPlan(
            day: 'Perşembe',
            focus: 'Core aktivasyon',
            activities: ['15 dk nefes + core', 'Kısa meditasyon'],
          ),
          const _WorkoutDayPlan(
            day: 'Cuma',
            focus: 'Mobilite',
            activities: ['Fasya açma serisi', 'Erken yatış'],
            isRest: true,
          ),
          const _WorkoutDayPlan(
            day: 'Cumartesi',
            focus: 'Rahat aktivite',
            activities: ['Bisiklet / yüzme (düşük tempo)', '10 dk esneme'],
          ),
          const _WorkoutDayPlan(
            day: 'Pazar',
            focus: 'Tam dinlenme',
            activities: ['Gevşeme egzersizleri', 'Uyku hazırlığı'],
            isRest: true,
          ),
        ];
    }
  }

  List<_WorkoutDayPlan> _buildAdaptivePlan(
    _PhysicalReadiness readiness,
    int age,
    int waterMl,
    int desiredMinutes,
  ) {
    final hydrationTarget = _hydrationTargetMl(age);
    final hydrationDelta = waterMl - hydrationTarget;
    final basePlan = _buildWeeklyPlan(readiness);

    return basePlan.map((day) {
      final personalizedMinutes = _personalizedMinutes(
        desiredMinutes,
        day.isRest,
        readiness,
        age,
      );
      final updatedActivities = [
        ...day.activities,
        'Target duration: $personalizedMinutes min focused work',
        if (hydrationDelta < 0 && !day.isRest)
          'Post-session: add +${(-hydrationDelta).clamp(250, 1500)} ml water',
      ];
      final noteParts = <String>[];
      if (age >= 45 && !day.isRest) {
        noteParts.add('Add 5 min of joint mobility care');
      }
      if (readiness == _PhysicalReadiness.recovery && !day.isRest) {
        noteParts.add('Keep effort around RPE 6/10');
      }
      if (hydrationDelta < 0) {
        noteParts.add('Daily hydration target: ${hydrationTarget} ml');
      }

      return _WorkoutDayPlan(
        day: day.day,
        focus:
            '${day.focus} • ${_effortTag(desiredMinutes, day.isRest, readiness)}',
        activities: updatedActivities,
        isRest: day.isRest,
        targetMinutes: personalizedMinutes,
        coachNote: noteParts.isEmpty ? null : noteParts.join(' • '),
      );
    }).toList();
  }

  int _personalizedMinutes(
    int desiredMinutes,
    bool isRest,
    _PhysicalReadiness readiness,
    int age,
  ) {
    double multiplier = isRest ? 0.5 : 1.0;
    switch (readiness) {
      case _PhysicalReadiness.peak:
        multiplier += isRest ? 0 : 0.15;
        break;
      case _PhysicalReadiness.balanced:
        multiplier += 0;
        break;
      case _PhysicalReadiness.recovery:
        multiplier -= isRest ? 0 : 0.2;
        break;
    }
    if (age >= 50) {
      multiplier -= 0.1;
    } else if (age <= 25 && !isRest) {
      multiplier += 0.05;
    }

    final rawMinutes = (desiredMinutes * multiplier).round();
    final minMinutes = isRest ? 15 : 25;
    final maxMinutes = isRest ? 60 : 90;
    return rawMinutes.clamp(minMinutes, maxMinutes);
  }

  int _hydrationTargetMl(int age) {
    if (age < 30) return 2600;
    if (age < 50) return 2400;
    return 2200;
  }

  String _hydrationFeedback(int waterMl, int age) {
    final target = _hydrationTargetMl(age);
    if (waterMl >= target) {
      return 'Hydration looks great — recovery signals will stay strong.';
    }
    final deficit = target - waterMl;
    final rounded = ((deficit / 250).ceil()) * 250;
    return 'Try adding approximately +$rounded ml water to stabilize energy.';
  }

  String _effortTag(
    int desiredMinutes,
    bool isRest,
    _PhysicalReadiness readiness,
  ) {
    if (isRest) return 'Recovery';
    if (desiredMinutes >= 60 && readiness != _PhysicalReadiness.recovery) {
      return 'Long session';
    }
    if (desiredMinutes <= 30) {
      return 'Short & intense';
    }
    return 'Moderate tempo';
  }

  Widget _buildRecommendationCard(
    BuildContext context,
    AppLocalizations l10n,
    AppState appState,
  ) {
    final readiness = _computeReadiness(appState);
    final accent = _readinessColor(readiness);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF475569)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.bolt_rounded, color: accent),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.energy,
                    style: textTheme.bodySmall?.copyWith(color: Colors.white54),
                  ),
                  Text(
                    _readinessLabel(readiness),
                    style: textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Icon(
                Icons.analytics_outlined,
                color: Colors.white.withOpacity(0.6),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Recommendation',
            style: textTheme.bodySmall?.copyWith(color: Colors.white38),
          ),
          Text(
            _readinessRecommendation(readiness),
            style: textTheme.bodyMedium?.copyWith(
              color: accent,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Use the planner below to enter age, daily water, and target duration for a personalized weekly routine.',
                  style: textTheme.bodySmall?.copyWith(color: Colors.white54),
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.touch_app_outlined,
                size: 16,
                color: Colors.white54,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlannerSection(BuildContext context, AppState appState) {
    final readiness = _plannerReadiness ?? _computeReadiness(appState);
    final accent = _readinessColor(readiness);
    final hrv = _latestValue(appState.hrvData, 0).toStringAsFixed(0);
    final sleep = _latestValue(appState.sleepData, 0).toStringAsFixed(1);
    final steps = _latestValue(appState.stepsData, 0).toStringAsFixed(0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Form(
        key: _plannerFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, color: accent),
                const SizedBox(width: 8),
                Text(
                  'Personal workout planner',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Tell us your age, daily hydration and target workout duration. FOREO adapts the weekly plan instantly.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildStatChip('HRV', '$hrv ms'),
                _buildStatChip('Sleep', '$sleep h'),
                _buildStatChip('Steps', '$steps'),
              ],
            ),
            const SizedBox(height: 16),
            _buildNumberField(
              controller: _ageController,
              label: 'Age',
              suffix: 'yrs',
              validator: (value) {
                final parsed = int.tryParse(value ?? '');
                if (parsed == null || parsed < 16 || parsed > 90) {
                  return 'Enter a valid age between 16-90';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            _buildNumberField(
              controller: _waterController,
              label: 'Daily water intake',
              suffix: 'ml',
              validator: (value) {
                final parsed = int.tryParse(value ?? '');
                if (parsed == null || parsed < 1000 || parsed > 5000) {
                  return 'Enter 1000-5000 ml';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            _buildNumberField(
              controller: _durationController,
              label: 'Desired daily workout time',
              suffix: 'min',
              validator: (value) {
                final parsed = int.tryParse(value ?? '');
                if (parsed == null || parsed < 20 || parsed > 120) {
                  return 'Enter 20-120 minutes';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            if (!_plannerGenerated)
              Text(
                'Enter your details and tap generate to unlock a tailored plan.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.white70),
              ),
            if (!_plannerGenerated) const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _generatePlanner(appState, fromUser: true),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Generate my weekly plan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlannerResults(AppState appState) {
    final readiness = _plannerReadiness ?? _computeReadiness(appState);
    final accent = _readinessColor(readiness);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1120),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: !_plannerGenerated
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Weekly plan preview',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  'Your personalized plan will appear here after you tap "Generate".',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your weekly plan',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildSummaryChip(
                      'Age',
                      '$_plannerAge',
                      Icons.cake_outlined,
                    ),
                    _buildSummaryChip(
                      'Water',
                      '$_plannerWater ml',
                      Icons.local_drink_outlined,
                    ),
                    _buildSummaryChip(
                      'Daily time',
                      '$_plannerMinutes min',
                      Icons.timer_outlined,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _hydrationFeedback(_plannerWater, _plannerAge),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: accent),
                ),
                const SizedBox(height: 8),
                Text(
                  _readinessDescription(_plannerReadiness ?? readiness),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                ..._plannerResults.map(
                  (plan) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildPlanTile(plan, accent),
                  ),
                ),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: ModernAppBar(
        title: l10n.physicalHealth,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => appState.refreshHealthData(),
            tooltip: l10n.syncNow,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildPeriodSelector(context, l10n),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRecommendationCard(context, l10n, appState),
                  const SizedBox(height: 24),
                  _buildPlannerSection(context, appState),
                  const SizedBox(height: 16),
                  _buildPlannerResults(appState),
                  const SizedBox(height: 24),
                  _buildMetricSection(
                    context,
                    l10n.hrv,
                    appState.hrvData,
                    Icons.favorite,
                  ),
                  const SizedBox(height: 24),
                  _buildMetricSection(
                    context,
                    l10n.heartRate,
                    appState.heartRateData,
                    Icons.monitor_heart,
                  ),
                  const SizedBox(height: 24),
                  _buildMetricSection(
                    context,
                    l10n.steps,
                    appState.stepsData,
                    Icons.directions_walk,
                  ),
                  const SizedBox(height: 24),
                  _buildMetricSection(
                    context,
                    l10n.sleep,
                    appState.sleepData,
                    Icons.bedtime,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector(BuildContext context, AppLocalizations l10n) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.transparent : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppTheme.white : AppTheme.black,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildPeriodButton(context, l10n.today, 'day'),
          const SizedBox(width: 8),
          _buildPeriodButton(context, l10n.thisWeek, 'week'),
          const SizedBox(width: 8),
          _buildPeriodButton(context, l10n.thisMonth, 'month'),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(BuildContext context, String label, String value) {
    final isSelected = _selectedPeriod == value;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPeriod = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? AppTheme.white : AppTheme.black)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? AppTheme.white : AppTheme.black,
              width: 1,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected
                  ? (isDark ? AppTheme.black : AppTheme.white)
                  : (isDark ? AppTheme.white : AppTheme.black),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricSection(
    BuildContext context,
    String title,
    List<HealthMetric> data,
    IconData icon,
  ) {
    final now = DateTime.now();
    DateTime startDate;
    switch (_selectedPeriod) {
      case 'day':
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case 'week':
        startDate = now.subtract(const Duration(days: 7));
        break;
      case 'month':
        startDate = now.subtract(const Duration(days: 30));
        break;
      default:
        startDate = now.subtract(const Duration(days: 7));
    }

    final filteredData = data
        .where((d) => d.timestamp.isAfter(startDate))
        .toList();

    if (filteredData.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              children: [
                Icon(icon, size: 48),
                const SizedBox(height: 16),
                Text(
                  'No data available',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final values = filteredData.map((d) => d.value!).toList();
    final avg = values.reduce((a, b) => a + b) / values.length;
    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(context, 'Avg', avg.toStringAsFixed(1)),
                _buildStatItem(context, 'Min', min.toStringAsFixed(1)),
                _buildStatItem(context, 'Max', max.toStringAsFixed(1)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: HealthChart(
                data: values,
                timestamps: filteredData.map((d) => d.timestamp).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
