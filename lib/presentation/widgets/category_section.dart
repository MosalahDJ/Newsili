import 'package:flutter/material.dart';
import 'package:newsily/data/models/news_data_model.dart';
import 'news_card.dart';

class CategorySection extends StatelessWidget {
  final String title;
  final List<Articles> articles;

  const CategorySection({
    super.key,
    required this.title,
    required this.articles,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),TextButton(
  onPressed: () {
    
      Navigator.pushNamed(
        context,
        "/category",
        arguments: {
          "category": title,
          "articles": articles,
        },
      );
  },
  child: const Text("See All"),
),

          ],
        ),
        SizedBox(
          height: 260,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.85),
            itemCount: articles.length > 4 ? 4 : articles.length,
            itemBuilder: (context, index) {
              return NewsCard(article: articles[index], i: index);
            },
          ),
        ),
      ],
    );
  }
}
