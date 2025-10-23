
  // 📚 Featured Card — Larger, with excerpt
  import 'package:flutter/material.dart';
import 'package:newsily/data/models/news_data_model.dart';

Widget buildFeaturedCard(BuildContext context, Articles article) {
    return GestureDetector(
      onTap: () {
        // TODO
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.hardEdge,
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: article.urlToImage != null
                  ? Image.network(article.urlToImage!, fit: BoxFit.cover)
                  : Container(color: Colors.grey[300]),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title ?? 'Untitled',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  if (article.description != null)
                    Text(
                      article.description!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        article.source?.name ?? '',
                        style: Theme.of(
                          context,
                        ).textTheme.labelSmall?.copyWith(color: Colors.grey),
                      ),
                      const Spacer(),
                      // _BookmarkButton(article: article),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

