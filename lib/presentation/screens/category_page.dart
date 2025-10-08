import 'package:flutter/material.dart';
import 'package:newsily/data/models/news_data_model.dart';
import '../widgets/news_card.dart';

class CategoryPage extends StatelessWidget {
  final String category;
  final List<Articles> articles;
  final int categoryIndex;
  const CategoryPage({
    required this.category,
    required this.articles,
    super.key,
    required this.categoryIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          category,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: articles.isEmpty
          ? const Center(child: Text("No articles available"))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return Hero(
                  tag: "$index category page",
                  child: NewsCard(article: articles[index], i: categoryIndex,));
              },
            ),
    );
  }
}
