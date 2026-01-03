import 'package:flutter/material.dart';
import 'package:weather_app/src/models/news_model.dart';
import 'package:weather_app/src/views/widgets/app_text.dart';

class NewsScreen extends StatelessWidget {
  final NewsModel news;

  const NewsScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News'), centerTitle: true),
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
                    color: Colors.black,
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      AppText(
                        text: news.time,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'By ${news.author}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// Description
                  AppText(
                    text: news.description,
                    fontSize: 16,
                    color: Colors.black87,
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
