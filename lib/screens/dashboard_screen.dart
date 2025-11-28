import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foreo_app/l10n/generated/app_localizations.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/metric_card.dart';
import '../widgets/health_chart.dart';
import '../widgets/modern_app_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appState = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);

    final hrvToday = appState.hrvData
        .where((d) => d.timestamp.isAfter(todayStart))
        .toList();
    final hrToday = appState.heartRateData
        .where((d) => d.timestamp.isAfter(todayStart))
        .toList();
    final stepsToday = appState.stepsData
        .where((d) => d.timestamp.isAfter(todayStart))
        .toList();
    final sleepToday = appState.sleepData
        .where((d) => d.timestamp.isAfter(todayStart))
        .toList();

    final avgHRV = hrvToday.isNotEmpty
        ? hrvToday.map((d) => d.value!).reduce((a, b) => a + b) / hrvToday.length
        : null;
    final avgHR = hrToday.isNotEmpty
        ? hrToday.map((d) => d.value!).reduce((a, b) => a + b) / hrToday.length
        : null;
    final totalSteps = stepsToday.isNotEmpty
        ? stepsToday.map((d) => d.value!).reduce((a, b) => a + b).toInt()
        : null;
    final totalSleep = sleepToday.isNotEmpty
        ? sleepToday.map((d) => d.value!).reduce((a, b) => a + b)
        : null;

    return Scaffold(
      appBar: ModernAppBar(
        title: l10n.appTitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => appState.refreshHealthData(),
            tooltip: l10n.syncNow,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => appState.refreshHealthData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.today,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  MetricCard(
                    title: l10n.hrv,
                    value: avgHRV?.toStringAsFixed(0),
                    unit: 'ms',
                    icon: Icons.favorite,
                  ),
                  MetricCard(
                    title: l10n.heartRate,
                    value: avgHR?.toStringAsFixed(0),
                    unit: 'bpm',
                    icon: Icons.monitor_heart,
                  ),
                  MetricCard(
                    title: l10n.steps,
                    value: totalSteps?.toString(),
                    unit: '',
                    icon: Icons.directions_walk,
                  ),
                  MetricCard(
                    title: l10n.sleep,
                    value: totalSleep?.toStringAsFixed(1),
                    unit: 'h',
                    icon: Icons.bedtime,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                l10n.thisWeek,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
              ),
              const SizedBox(height: 16),
              _buildWeeklyCharts(context, l10n, appState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyCharts(
    BuildContext context,
    AppLocalizations l10n,
    AppState appState,
  ) {
    final weekStart = DateTime.now().subtract(const Duration(days: 7));

    final hrvWeek = appState.hrvData
        .where((d) => d.timestamp.isAfter(weekStart))
        .toList();
    final stepsWeek = appState.stepsData
        .where((d) => d.timestamp.isAfter(weekStart))
        .toList();

    return Column(
      children: [
        if (hrvWeek.isNotEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.hrv,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: HealthChart(
                      data: hrvWeek.map((d) => d.value!).toList(),
                      timestamps: hrvWeek.map((d) => d.timestamp).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 16),
        if (stepsWeek.isNotEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.steps,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: HealthChart(
                      data: stepsWeek.map((d) => d.value!).toList(),
                      timestamps: stepsWeek.map((d) => d.timestamp).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
