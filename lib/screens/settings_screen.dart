import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foreo_app/l10n/generated/app_localizations.dart';
import '../services/app_state.dart';
import '../widgets/modern_app_bar.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appState = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: ModernAppBar(title: l10n.settings),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // User Info Card
          if (appState.userEmail != null)
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          AppTheme.darkGray.withOpacity(0.8),
                          AppTheme.darkGray.withOpacity(0.6),
                        ]
                      : [
                          AppTheme.lightGray.withOpacity(0.8),
                          AppTheme.lightGray.withOpacity(0.6),
                        ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? AppTheme.white.withOpacity(0.1)
                      : AppTheme.black.withOpacity(0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isDark ? Colors.white : Colors.black).withOpacity(
                      0.05,
                    ),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [
                                AppTheme.white.withOpacity(0.2),
                                AppTheme.white.withOpacity(0.1),
                              ]
                            : [
                                AppTheme.black.withOpacity(0.1),
                                AppTheme.black.withOpacity(0.05),
                              ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      color: isDark ? AppTheme.white : AppTheme.black,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppTheme.white.withOpacity(0.6)
                                : AppTheme.black.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          appState.userEmail ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppTheme.white : AppTheme.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          // Settings Options
          _buildModernListTile(
            context: context,
            icon: Icons.language_rounded,
            title: l10n.language,
            subtitle: _getLanguageName(appState.locale, l10n),
            onTap: () => _showLanguageDialog(context, l10n, appState),
            isDark: isDark,
          ),
          const SizedBox(height: 8),
          _buildModernListTile(
            context: context,
            icon: Icons.palette_rounded,
            title: l10n.theme,
            subtitle: _getThemeName(appState.themeMode, l10n),
            onTap: () => _showThemeDialog(context, l10n, appState),
            isDark: isDark,
          ),
          const SizedBox(height: 8),
          _buildModernListTile(
            context: context,
            icon: Icons.info_outline_rounded,
            title: l10n.about,
            subtitle: '${l10n.version} 1.0.0',
            onTap: null,
            isDark: isDark,
          ),
          const SizedBox(height: 32),
          // Logout Button
          Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [const Color(0xFF2A2A2A), const Color(0xFF1A1A1A)]
                    : [const Color(0xFF000000), const Color(0xFF2A2A2A)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? Colors.white : Colors.black).withOpacity(
                    0.3,
                  ),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () => _handleLogout(context, appState),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.logout_rounded, color: AppTheme.white),
                  const SizedBox(width: 12),
                  const Text(
                    'Sign Out',
                    style: TextStyle(
                      color: AppTheme.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernListTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.darkGray.withOpacity(0.5)
            : AppTheme.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppTheme.white.withOpacity(0.1)
              : AppTheme.black.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.white : Colors.black).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      AppTheme.white.withOpacity(0.1),
                      AppTheme.white.withOpacity(0.05),
                    ]
                  : [
                      AppTheme.black.withOpacity(0.05),
                      AppTheme.black.withOpacity(0.02),
                    ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: isDark ? AppTheme.white : AppTheme.black),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDark ? AppTheme.white : AppTheme.black,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isDark
                ? AppTheme.white.withOpacity(0.6)
                : AppTheme.black.withOpacity(0.6),
          ),
        ),
        trailing: onTap != null
            ? Icon(
                Icons.chevron_right_rounded,
                color: isDark
                    ? AppTheme.white.withOpacity(0.6)
                    : AppTheme.black.withOpacity(0.6),
              )
            : null,
        onTap: onTap,
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context, AppState appState) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await appState.logout();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  void _showLanguageDialog(
    BuildContext context,
    AppLocalizations l10n,
    AppState appState,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<Locale>(
              title: Text(l10n.english),
              value: const Locale('en'),
              groupValue: appState.locale,
              onChanged: (value) {
                if (value != null) {
                  appState.setLocale(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<Locale>(
              title: Text(l10n.spanish),
              value: const Locale('es'),
              groupValue: appState.locale,
              onChanged: (value) {
                if (value != null) {
                  appState.setLocale(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<Locale>(
              title: Text(l10n.turkish),
              value: const Locale('tr'),
              groupValue: appState.locale,
              onChanged: (value) {
                if (value != null) {
                  appState.setLocale(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<Locale>(
              title: Text(l10n.polish),
              value: const Locale('pl'),
              groupValue: appState.locale,
              onChanged: (value) {
                if (value != null) {
                  appState.setLocale(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(
    BuildContext context,
    AppLocalizations l10n,
    AppState appState,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.theme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: Text(l10n.light),
              value: ThemeMode.light,
              groupValue: appState.themeMode,
              onChanged: (value) {
                if (value != null) {
                  appState.setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.dark),
              value: ThemeMode.dark,
              groupValue: appState.themeMode,
              onChanged: (value) {
                if (value != null) {
                  appState.setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.system),
              value: ThemeMode.system,
              groupValue: appState.themeMode,
              onChanged: (value) {
                if (value != null) {
                  appState.setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getLanguageName(Locale locale, AppLocalizations l10n) {
    switch (locale.languageCode) {
      case 'en':
        return l10n.english;
      case 'es':
        return l10n.spanish;
      case 'tr':
        return l10n.turkish;
      case 'pl':
        return l10n.polish;
      default:
        return l10n.english;
    }
  }

  String _getThemeName(ThemeMode mode, AppLocalizations l10n) {
    switch (mode) {
      case ThemeMode.light:
        return l10n.light;
      case ThemeMode.dark:
        return l10n.dark;
      case ThemeMode.system:
        return l10n.system;
    }
  }
}
