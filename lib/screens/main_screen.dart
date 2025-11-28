import 'package:flutter/material.dart';
import 'package:foreo_app/l10n/generated/app_localizations.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';
import 'physical_health_screen.dart';
import 'mental_health_screen.dart';
import 'skin_health_screen.dart';
import 'settings_screen.dart';
import 'chat_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Widget> screens = [
      const DashboardScreen(),
      const PhysicalHealthScreen(),
      const MentalHealthScreen(),
      const SkinHealthScreen(),
      const ChatScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    const Color(0xFF0A0A0A).withOpacity(0.95),
                    const Color(0xFF1A1A1A).withOpacity(0.95),
                  ]
                : [
                    const Color(0xFFFFFFFF).withOpacity(0.95),
                    const Color(0xFFF8F9FA).withOpacity(0.95),
                  ],
          ),
          border: Border(
            top: BorderSide(
              color: isDark
                  ? AppTheme.white.withOpacity(0.1)
                  : AppTheme.black.withOpacity(0.1),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: (isDark ? Colors.white : Colors.black).withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          indicatorColor: isDark
              ? AppTheme.white.withOpacity(0.2)
              : AppTheme.black.withOpacity(0.1),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.dashboard_outlined,
                color: isDark
                    ? AppTheme.white.withOpacity(0.6)
                    : AppTheme.black.withOpacity(0.6),
              ),
              selectedIcon: Icon(
                Icons.dashboard_rounded,
                color: isDark ? AppTheme.white : AppTheme.black,
              ),
              label: l10n.dashboard,
            ),
            NavigationDestination(
              icon: Icon(
                Icons.favorite_outline,
                color: isDark
                    ? AppTheme.white.withOpacity(0.6)
                    : AppTheme.black.withOpacity(0.6),
              ),
              selectedIcon: Icon(
                Icons.favorite_rounded,
                color: isDark ? AppTheme.white : AppTheme.black,
              ),
              label: l10n.physicalHealth,
            ),
            NavigationDestination(
              icon: Icon(
                Icons.psychology_outlined,
                color: isDark
                    ? AppTheme.white.withOpacity(0.6)
                    : AppTheme.black.withOpacity(0.6),
              ),
              selectedIcon: Icon(
                Icons.psychology_rounded,
                color: isDark ? AppTheme.white : AppTheme.black,
              ),
              label: l10n.mentalHealth,
            ),
            NavigationDestination(
              icon: Icon(
                Icons.face_outlined,
                color: isDark
                    ? AppTheme.white.withOpacity(0.6)
                    : AppTheme.black.withOpacity(0.6),
              ),
              selectedIcon: Icon(
                Icons.face_rounded,
                color: isDark ? AppTheme.white : AppTheme.black,
              ),
              label: l10n.skinHealth,
            ),
            NavigationDestination(
              icon: Icon(
                Icons.chat_bubble_outline,
                color: isDark
                    ? AppTheme.white.withOpacity(0.6)
                    : AppTheme.black.withOpacity(0.6),
              ),
              selectedIcon: Icon(
                Icons.chat_bubble_rounded,
                color: isDark ? AppTheme.white : AppTheme.black,
              ),
              label: 'AI Chat',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.settings_outlined,
                color: isDark
                    ? AppTheme.white.withOpacity(0.6)
                    : AppTheme.black.withOpacity(0.6),
              ),
              selectedIcon: Icon(
                Icons.settings_rounded,
                color: isDark ? AppTheme.white : AppTheme.black,
              ),
              label: l10n.settings,
            ),
          ],
        ),
      ),
    );
  }
}
