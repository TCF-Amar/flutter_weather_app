import 'package:flutter/material.dart';
import 'package:weather_app/core/constants/app_colors.dart';
import 'package:weather_app/core/theme/theme_extensions.dart';
import 'package:weather_app/src/models/news_model.dart';
import 'package:weather_app/src/views/widgets/app_scaffold.dart';
import 'package:weather_app/src/views/widgets/app_text.dart';

class NewsScreen extends StatelessWidget {
  final NewsModel news;

  const NewsScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'News',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Hero Image
            Hero(
              tag: news.id,
              child: Image.network(
                news.imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: news.title,
                    fontSize: 22,
                    bold: true,
                    // color: AppColors.black,
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      AppText(
                        text: news.time,
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'By ${news.author}',
                        style: const TextStyle(color: AppColors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// Description
                  Text(
                    news.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: context.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          text: "News",
                          fontSize: 16,
                          color: AppColors.grey,
                        ),
                        const SizedBox(width: 10),
                        Row(
                          children: [
                            Icon(Icons.share, size: 20, color: AppColors.grey),
                            const SizedBox(width: 10),
                            AppText(
                              text: "Share it",
                              fontSize: 16,
                              color: AppColors.grey,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
