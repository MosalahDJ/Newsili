import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/data/models/news_data_model.dart';
import 'package:newsily/logic/cubit/save_articles.dart/bookmarks_cubit.dart';
import 'package:newsily/logic/cubit/save_articles.dart/bookmarks_state.dart';
import 'package:newsily/presentation/screens/article_description.dart';

Widget buildBreakingCard(BuildContext context, Articles article, int index) {
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.network(
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
                        Colors.black.withValues(alpha: 0.1),
                        Colors.black.withValues(alpha: 0.7),
                      ],
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
                      style: const TextStyle(
                        color: Colors.white,
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
                        Text(
                          article.source?.name ?? "",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        const Spacer(),
                        BlocBuilder<BookmarksCubit, BookmarksState>(
                          builder: (context, state) {
                            return FutureBuilder<bool>(
                              future: context
                                  .read<BookmarksCubit>()
                                  .isBookmarked(article),
                              builder: (context, snapshot) {
                                final isBookmarked = snapshot.data ?? false;
                                return IconButton(
                                  icon: Icon(
                                    isBookmarked
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color: Colors.white,
                                  ),
                                  onPressed: () =>
                                      _handleBookmarkPress(context, article),
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


void _handleBookmarkPress(BuildContext context, Articles article) async {
    if (!context.mounted) return;

    final bookmarksCubit = context.read<BookmarksCubit>();
    final isBookmarked = await bookmarksCubit.isBookmarked(article);

    if (!context.mounted) return;

    if (isBookmarked) {
      bookmarksCubit.removeBookmark(article);
    } else {
      bookmarksCubit.addBookmark(article);
    }
  }