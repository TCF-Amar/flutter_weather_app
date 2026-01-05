import 'package:flutter/material.dart';
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
        color: Colors.grey[600],
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
          ? Icon(icon, color: Colors.blue[600], size: 24)
          : null,
      title: AppText(text: title, fontSize: 16, bold: false),
      trailing:
          trailing ??
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
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
    return ListTile(
      title: AppText(text: title, fontSize: 16, bold: false),
      trailing: SizedBox(
        width: 160,
        height: 40,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            children: options
                .map((option) => _buildToggleOption(option))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleOption(ToggleOption option) {
    return Expanded(
      child: GestureDetector(
        onTap: option.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            gradient: option.isSelected
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 8, 107, 255),
                      Color.fromARGB(255, 128, 158, 203),
                    ],
                  )
                : null,
            borderRadius: BorderRadius.circular(100),
            boxShadow: option.isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: AppText(
              text: option.label,
              fontSize: 14,
              bold: option.isSelected,
              color: option.isSelected ? Colors.white : Colors.grey[600],
            ),
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
