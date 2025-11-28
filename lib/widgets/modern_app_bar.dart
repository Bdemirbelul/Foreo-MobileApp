import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ModernAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;

  const ModernAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF1A1A1A), const Color(0xFF0A0A0A)]
              : [const Color(0xFFFFFFFF), const Color(0xFFF8F9FA)],
        ),
        border: Border(
          bottom: BorderSide(
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
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              if (showBackButton)
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: isDark ? AppTheme.white : AppTheme.black,
                    size: 20,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              Expanded(
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: isDark
                        ? [AppTheme.white, AppTheme.white.withOpacity(0.8)]
                        : [AppTheme.black, AppTheme.black.withOpacity(0.8)],
                  ).createShader(bounds),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isDark ? AppTheme.white : AppTheme.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20);
}
