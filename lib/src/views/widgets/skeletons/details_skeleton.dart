import 'package:flutter/material.dart';
import 'package:weather_app/core/constants/app_colors.dart';
import 'package:weather_app/core/theme/theme_extensions.dart';

class DetailsSkeleton extends StatefulWidget {
  const DetailsSkeleton({super.key});

  @override
  State<DetailsSkeleton> createState() => _DetailsSkeletonState();
}

class _DetailsSkeletonState extends State<DetailsSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// HEADER SKELETON
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height * 0.6,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.42,
              padding: const EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [context.gradient1, context.gradient2],
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  /// Top bar skeleton
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_back_ios_new,
                          color: AppColors.white,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return Container(
                                height: 20,
                                decoration: BoxDecoration(
                                  color: AppColors.white.withOpacity(
                                    _animation.value,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.bookmark_outline,
                          color: AppColors.white,
                        ),
                        const Icon(Icons.share, color: AppColors.white),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Weather icon skeleton
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(_animation.value),
                          shape: BoxShape.circle,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  /// Weather text skeleton
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Container(
                        width: 120,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(_animation.value),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 8),

                  /// Date skeleton
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Container(
                        width: 100,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(_animation.value),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          /// HOURLY TABS CARD SKELETON
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.background,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: context.shadowColor,
                    offset: const Offset(0, 1),
                    blurRadius: 1,
                  ),
                ],
              ),
              child: Column(
                children: [
                  /// Tabs skeleton
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(3, (index) {
                      return AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Container(
                            width: 80,
                            height: 16,
                            decoration: BoxDecoration(
                              color: context.onSurface.withOpacity(
                                _animation.value * 0.3,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        },
                      );
                    }),
                  ),

                  const SizedBox(height: 16),

                  /// Hourly items skeleton
                  SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(5, (index) {
                        return AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 40,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: context.onSurface.withOpacity(
                                      _animation.value * 0.3,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: context.onSurface.withOpacity(
                                      _animation.value * 0.3,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: 35,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: context.onSurface.withOpacity(
                                      _animation.value * 0.3,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// DETAILS SECTION SKELETON
          Positioned(
            top: MediaQuery.of(context).size.height * 0.56,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).size.height * 0.1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// "Details" title skeleton
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Container(
                      width: 80,
                      height: 20,
                      decoration: BoxDecoration(
                        color: context.onSurface.withOpacity(
                          _animation.value * 0.3,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                /// Details grid skeleton
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.5,
                        ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: context.isDark
                                  ? context.onBackground.withOpacity(0.01)
                                  : context.surface,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: context.shadowColor,
                                  blurRadius: 1,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 60,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: context.onSurface.withOpacity(
                                      _animation.value * 0.3,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                Container(
                                  width: 80,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: context.onSurface.withOpacity(
                                      _animation.value * 0.3,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
