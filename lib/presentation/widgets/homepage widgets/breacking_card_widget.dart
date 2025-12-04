import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/data/models/news_data_model.dart';
import 'package:newsily/helper/themes.dart';
import 'package:newsily/logic/cubit/save_articles/bookmarks_cubit.dart';
import 'package:newsily/logic/cubit/save_articles/bookmarks_state.dart';
import 'package:newsily/presentation/screens/article_description.dart';
import 'package:newsily/presentation/widgets/homepage%20widgets/handlebookmarkpress.dart';

Widget buildBreakingCard(BuildContext context, Articles article, int index) {
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
    child: Hero(
      tag: "${article.url}-$index",
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        color: theme.colorScheme.surface,
        surfaceTintColor: theme.colorScheme.surface,
        shadowColor: theme.colorScheme.shadow,
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
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
                      borderRadius: BorderRadius.circular(20),
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
            // Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      theme.colorScheme.scrim.withValues(alpha: 0.9),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            // Breaking news badge
            if (index == 0) // First card is breaking news
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.breakingNewsColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'BREAKING',
                    style: TextStyle(
                      color: theme.colorScheme.onTertiary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            // Text
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title ?? "No title available",
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          article.source?.name ?? "Unknown",
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Spacer(),
                      BlocBuilder<BookmarksCubit, BookmarksState>(
                        builder: (context, state) {
                          return FutureBuilder<bool>(
                            future: context.read<BookmarksCubit>().isBookmarked(
                              article,
                            ),
                            builder: (context, snapshot) {
                              final isBookmarked = snapshot.data ?? false;
                              return IconButton(
                                icon: Icon(
                                  isBookmarked
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: isBookmarked
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onPrimary,
                                ),
                                onPressed: () =>
                                    handleBookmarkPress(context, article),
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
          ],
        ),
      ),
    ),
  );
}
