
// 🔥 Trending Card — Compact vertical list
import 'package:flutter/material.dart';
import 'package:newsily/data/models/news_data_model.dart';

Widget buildTrendingCard(BuildContext context, Articles article) {
  return GestureDetector(
    onTap: () {
      // TODO
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
              child: article.urlToImage != null
                  ? Image.network(article.urlToImage!, fit: BoxFit.cover)
                  : Container(color: Colors.grey[300]),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title ?? 'Untitled',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  article.source?.name ?? '',
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // todo
            },
            icon: const Icon(Icons.more_vert, size: 18),
          ),
        ],
      ),
    ),
  );
}
