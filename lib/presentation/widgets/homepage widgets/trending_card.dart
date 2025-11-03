import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/data/models/news_data_model.dart';
import 'package:newsily/helper/save_function.dart';
import 'package:newsily/presentation/screens/article_description.dart';
import 'package:newsily/presentation/widgets/homepage%20widgets/handlebookmarkpress.dart';
import 'package:newsily/presentation/widgets/homepage%20widgets/schowartiklemoremenufunc.dart';

Widget buildTrendingCard(BuildContext context, Articles article) {
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
              child: article.urlToImage != null
                  ? Image.network(
                      article.urlToImage ?? "",
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 150,
                          color: Colors.grey[300],
                          alignment: Alignment.center,
                          child: const Icon(Icons.broken_image, size: 60),
                        );
                      },
                    )
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
          Builder(
            builder: (context) => IconButton(
              onPressed: () => showArticleMoreMenu(
                context,
                article: article,
                isbookmarked: ,
                onShare: () {
                  shareArticle(context, title: "${article.title}", url: "${article.url}");
                },
                onSave: () => handleBookmarkPress(context, article),
              ),
              icon: const Icon(Icons.more_vert, size: 18),
            ),
          ),
        ],
      ),
    ),
  );
}
