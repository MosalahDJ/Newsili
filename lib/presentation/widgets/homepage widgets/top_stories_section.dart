import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newsily/data/models/news_data_model.dart';
import 'package:newsily/presentation/screens/article_description.dart';

Widget buildTopStoriesSection(BuildContext context, List<Articles> topStories) {
  final theme = Theme.of(context);
  
  return SizedBox(
    height: 140,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: topStories.length > 10 ? 10 : topStories.length,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (context, index) {
        final article = topStories[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ArticleDescriptionPage(article: article),
              ),
            );
          },
          child: Hero(
            tag: "${article.url}-top-$index",
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: article.urlToImage ?? "",
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          height: 150,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.broken_image,
                            size: 60,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          theme.colorScheme.scrim.withOpacity(0.9),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      article.title ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}