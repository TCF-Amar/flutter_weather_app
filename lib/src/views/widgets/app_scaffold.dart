import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/src/views/widgets/animated_text.dart';
import 'package:weather_app/core/constants/app_colors.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final Widget? titleWidget;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? appBarColor;
  final bool useAnimatedTitle;
  final double titleFontSize;
  final Color? titleColor;
  final bool showAppBar;
  final PreferredSizeWidget? customAppBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
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
