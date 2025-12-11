import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:newsily/helper/url_luncher_function.dart';
import 'package:newsily/logic/cubit/save_articles/bookmarks_cubit.dart';
import 'package:newsily/logic/cubit/save_articles/bookmarks_state.dart';
import 'package:newsily/presentation/widgets/homepage%20widgets/handlebookmarkpress.dart';
import '../../data/models/news_data_model.dart';

class ArticleDescriptionPage extends StatelessWidget {
  final Articles article;
  const ArticleDescriptionPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDate = article.publishedAt != null
        ? DateFormat(
            'yMMMd • HH:mm',
          ).format(DateTime.parse(article.publishedAt!))
        : "Unknown date";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Article Details"),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        surfaceTintColor: theme.colorScheme.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === Hero Image ===
            Hero(
              tag: "${article.url}-${article.publishedAt}",
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage == null
                      ? ""
                      : article.urlToImage!,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorWidget: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
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
            const SizedBox(height: 16),

            // === Source and Date ===
            Row(
              children: [
                Icon(Icons.language, color: theme.colorScheme.secondary),
                const SizedBox(width: 6),
                SizedBox(
                  width: 200,
                  child: Text(
                    article.source?.name ?? "Unknown Source",
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  formattedDate,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // === Title ===
            Text(
              article.title ?? "No title available",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.3,
                color: theme.colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 10),

            // === Author ===
            if (article.author != null)
              Text(
                "By ${article.author}",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.primary,
                ),
              ),

            const SizedBox(height: 16),

            // === Description ===
            if (article.description != null)
              Text(
                article.description!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                  color: theme.colorScheme.onSurface,
                ),
              ),

            const SizedBox(height: 12),

            // === Full Content ===
            if (article.content != null)
              Text(
                article.content!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                  color: theme.colorScheme.onSurface,
                ),
              ),

            const SizedBox(height: 24),

            // === Visit Source Button ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final success = await tryOpenArticleUrl(article.url!);
                    if (!success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Could not open the article"),
                          backgroundColor: theme.colorScheme.error,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    }
                  },
                  icon: Icon(
                    Icons.open_in_new,
                    color: theme.colorScheme.onPrimary,
                  ),
                  label: Text(
                    "Read full article",
                    style: TextStyle(color: theme.colorScheme.onPrimary),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                BlocBuilder<BookmarksCubit, BookmarksState>(
                  builder: (context, state) {
                    return FutureBuilder<bool>(
                      future: context.read<BookmarksCubit>().isBookmarked(
                        article,
                      ),
                      builder: (context, snapshot) {
                        final isBookmarked = snapshot.data ?? false;
                        return ElevatedButton.icon(
                          onPressed: () =>
                              handleBookmarkPress(context, article),
                          icon: Icon(
                            isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: 
                                theme.colorScheme.primary
                          ),
                          label: Text(
                            isBookmarked ? "Saved" : "Save",
                            style: TextStyle(
                              color: 
                                  theme.colorScheme.primary
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                theme.colorScheme.surfaceContainerHighest,
                            foregroundColor: theme.colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: theme.colorScheme.outline,
                                width: 1,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
