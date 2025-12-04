import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newsily/data/models/news_data_model.dart';
import 'package:newsily/helper/share_function.dart';
import 'package:newsily/presentation/screens/article_description.dart';
import 'package:newsily/presentation/widgets/homepage%20widgets/handlebookmarkpress.dart';
import 'package:newsily/presentation/widgets/homepage%20widgets/schowartiklemoremenufunc.dart';

Widget buildTrendingCard(BuildContext context, Articles article) {
  final theme = Theme.of(context);

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ArticleDescriptionPage(article: article),
        ),
      );
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 100,
              height: 70,
              child: CachedNetworkImage(
                imageUrl: article.urlToImage ?? "",
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorWidget: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title ?? 'Untitled',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    article.source?.name ?? 'Unknown',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Builder(
            builder: (context) => IconButton(
              onPressed: () => showArticleMoreMenu(
                context,
                article: article,
                onShare: () {
                  shareArticle(
                    context,
                    title: "${article.title}",
                    url: "${article.url}",
                  );
                },
                onSave: () => handleBookmarkPress(context, article),
              ),
              icon: Icon(
                Icons.more_vert,
                size: 18,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
