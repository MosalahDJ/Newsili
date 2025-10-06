import 'package:flutter/material.dart';
import 'package:newsily/data/models/news_data_model.dart';

class NewsCard extends StatelessWidget {
  final Articles article;
  final int i;

  const NewsCard({super.key, required this.article, required this.i});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/detail", arguments: article);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            article.urlToImage == null
                ? Image.asset(
                    "lib/assets/images/helper_images/no_image.jpg",
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    "${article.urlToImage}",
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${article.title}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "${article.source!.name}",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
