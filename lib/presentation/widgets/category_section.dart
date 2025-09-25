import 'package:flutter/material.dart';
import 'package:newsily/constants/constant_enum.dart';
import 'package:newsily/data/models/news_data_model.dart';
import 'news_card.dart';

class CategorySection extends StatelessWidget {
  final String title;
  final List<Articles> businessNews;
  final List<Articles> entertainmentNews;
  final List<Articles> generalNews;
  final List<Articles> healthNews;
  final List<Articles> scienceNews;
  final List<Articles> sportsNews;
  final List<Articles> technologyNews;
  final Category category;

  const CategorySection({
    super.key,
    required this.title,
    required this.businessNews,
    required this.entertainmentNews,
    required this.generalNews,
    required this.healthNews,
    required this.scienceNews,
    required this.sportsNews,
    required this.technologyNews,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    late int itemCount;
    late List<Articles> articles;

    switch (category) {
      case Category.technology:
        itemCount = technologyNews.length;
        articles = technologyNews;
      case Category.business:
        itemCount = businessNews.length;

      case Category.entertainment:
        itemCount = entertainmentNews.length;

      case Category.health:
        itemCount = healthNews.length;

      case Category.science:
        itemCount = scienceNews.length;

      case Category.sports:
        itemCount = sportsNews.length;

      case Category.general:
        itemCount = generalNews.length;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "/category", arguments: title);
              },
              child: Text("See All"),
            ),
          ],
        ),
        SizedBox(
          height: 260,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.85),
            itemCount: itemCount > 4 ? 4 : itemCount,
            itemBuilder: (context, index) {
              return NewsCard(article: articles, i: index);
            },
          ),
        ),
      ],
    );
  }
}
