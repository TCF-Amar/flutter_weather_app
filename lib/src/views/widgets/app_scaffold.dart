import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/src/views/widgets/animated_text.dart';
import 'package:weather_app/core/constants/app_colors.dart';

class AppScaffold extends StatelessWidget {
  /// The main content of the page
  final Widget body;

  /// Title text for the app bar
  final String? title;

  /// Custom title widget (overrides title text)
  final Widget? titleWidget;

  /// Whether to show the back button
  final bool showBackButton;

  /// Custom back button action
  final VoidCallback? onBackPressed;

  /// Actions to display in the app bar
  final List<Widget>? actions;

  /// Whether to center the title
  final bool centerTitle;

  /// Background color of the scaffold
  final Color? backgroundColor;

  /// App bar background color
  final Color? appBarColor;

  /// Whether to use animated text for title
  final bool useAnimatedTitle;

  /// Font size for the title
  final double titleFontSize;

  /// Title text color
  final Color? titleColor;

  /// Whether to show the app bar
  final bool showAppBar;

  /// Custom app bar (overrides all app bar settings)
  final PreferredSizeWidget? customAppBar;

  /// Floating action button
  final Widget? floatingActionButton;

  /// Bottom navigation bar
  final Widget? bottomNavigationBar;

  /// Drawer
  final Widget? drawer;

  /// End drawer
  final Widget? endDrawer;

  final VoidCallback? onMenuTab;
  final bool isDrawerOpen;

  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.titleWidget,
    this.showBackButton = true,
    this.onBackPressed,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.appBarColor,
    this.useAnimatedTitle = false,
    this.titleFontSize = 20,
    this.titleColor,
    this.showAppBar = true,
    this.customAppBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.onMenuTab,
    this.isDrawerOpen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: customAppBar ?? (showAppBar ? _buildAppBar(context) : null),
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: appBarColor ?? AppColors.transparent,
      centerTitle: centerTitle,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.textPrimary,
              ),
              onPressed:
                  onBackPressed ??
                  () {
                    if (context.canPop()) {
                      context.pop();
                    }
                  },
            )
          : isDrawerOpen
          ? IconButton(
              icon: const Icon(Icons.close, color: AppColors.textPrimary),
              onPressed: () {
                onMenuTab!();
              },
            )
          : IconButton(
              icon: const Icon(Icons.menu, color: AppColors.textPrimary),
              onPressed: onMenuTab,
            ),
      title: _buildTitle(),
      actions: actions,
    );
  }

  Widget? _buildTitle() {
    // Custom title widget takes precedence
    if (titleWidget != null) {
      return titleWidget;
    }

    // No title
    if (title == null) {
      return null;
    }

    // Animated title
    if (useAnimatedTitle) {
      return AnimatedText(
        text: title!,
        fontSize: titleFontSize,
        color: titleColor ?? AppColors.textLight,
        fontWeight: FontWeight.bold,
      );
    }

    // Regular title
    return Text(
      title!,
      style: TextStyle(
        fontSize: titleFontSize,
        color: titleColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
