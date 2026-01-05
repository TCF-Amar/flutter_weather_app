import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/core/constants/app_colors.dart';
import 'package:weather_app/src/models/news_model.dart';
import 'package:weather_app/src/views/widgets/app_text.dart';

class NewsCard extends StatelessWidget {
  final NewsModel news;

  const NewsCard({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(text: "News", fontSize: 22, bold: true),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              context.push('/news', extra: news);
            },
            child: Container(
              margin: const EdgeInsets.only(top: 0),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey.withValues(alpha: 0.3),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Hero(
                      tag: news.id,
                      child: Image.network(
                        news.imageUrl,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// Title
                  AppText(
                    text: news.title,
                    fontSize: 18,
                    bold: true,
                    maxLines: 2,
                    color: AppColors.black,
                  ),

                  const SizedBox(height: 8),

                  /// Footer
                  Row(
                    children: [
                      AppText(
                        text: news.time,
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                      const Spacer(),
                      Text(
                        'By ${news.author}',
                        style: const TextStyle(color: AppColors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
