import 'package:flutter/material.dart';
import 'package:weather_app/core/constants/app_colors.dart';
import 'package:weather_app/core/theme/theme_extensions.dart';
import 'package:weather_app/src/views/widgets/app_text.dart';

class SettingsSectionHeader extends StatelessWidget {
  final String title;
  const SettingsSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: AppText(
        text: title.toUpperCase(),
        fontSize: 13,
        bold: true,
        color: context.labelMedium?.color,
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  final Widget child;
  const SettingsCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.onSurface.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class SettingsItem extends StatelessWidget {
  final IconData? icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsItem({
    super.key,
    this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon != null
          ? Icon(icon, color: AppColors.blue, size: 24)
          : null,
      title: AppText(text: title, fontSize: 16, bold: false),
      trailing:
          trailing ??
          const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey),
      onTap: onTap,
    );
  }
}

class SettingsToggle extends StatelessWidget {
  final String title;
  final List<ToggleOption> options;

  const SettingsToggle({super.key, required this.title, required this.options});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = options.indexWhere((element) => element.isSelected);

    return ListTile(
      title: AppText(text: title, fontSize: 16),
      trailing: SizedBox(
        width: 160,
        height: 40,
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: context.onSurface.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Stack(
            children: [
              ///  Sliding Indicator
              AnimatedAlign(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                alignment: selectedIndex == 0
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Container(
                  width: 74,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [context.gradient1, context.gradient2],
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),

              /// Buttons
              Row(
                children: options.map((option) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: option.onTap,
                      behavior: HitTestBehavior.opaque,
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: option.isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: option.isSelected
                                ? AppColors.white
                                : context.onSurface,
                          ),
                          child: Text(option.label),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ToggleOption {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  ToggleOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
}
