import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/logic/cubit/fetch%20data/fetch_cubit.dart';
import 'package:newsily/logic/cubit/fetch%20data/fetch_state.dart';
import 'package:newsily/logic/cubit/save_articles.dart/bookmarks_cubit.dart';
import 'package:newsily/presentation/screens/article_description.dart';
import 'package:newsily/presentation/widgets/home_page_skeleton.dart';
import 'package:newsily/presentation/widgets/suggesion_banner.dart';
import 'package:newsily/presentation/widgets/top_stories_section.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../data/models/news_data_model.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final PageController _pageController = PageController(viewportFraction: 0.88);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Newsily",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<FetchCubit, FetchState>(
        builder: (context, state) {
          if (state is DataLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DataError) {
            return Center(child: Text(state.errortext));
          } else if (state is DataLoaded) {
            final latestNews = state.generalNews ?? [];
            final topStories = state.businessNews ?? [];

            if (latestNews.isEmpty) {
              return const Center(child: Text("No news available"));
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<FetchCubit>().getArticles();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ==== BREAKING NEWS ====
                      const Text(
                        "Breaking News",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      SizedBox(
                        height: 280,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: latestNews.length > 4
                              ? 4
                              : latestNews.length,
                          itemBuilder: (context, index) {
                            final article = latestNews[index];
                            return _buildBreakingCard(context, article, index);
                          },
                        ),
                      ),

                      const SizedBox(height: 12),
                      Center(
                        child: SmoothPageIndicator(
                          controller: _pageController,
                          count: latestNews.length > 4 ? 4 : latestNews.length,
                          effect: ExpandingDotsEffect(
                            dotHeight: 8,
                            dotWidth: 8,
                            activeDotColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            dotColor: Colors.grey.withValues(alpha: 0.3),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ==== TOP STORIES ====
                      const Text(
                        "Top Stories",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),

                      buildTopStoriesSection(context, topStories),

                      const SizedBox(height: 24),

                      // ==== OPTIONAL: Suggestion Section ====
                      buildSuggestionBanner(context),
                    ],
                  ),
                ),
              ),
            );
          }
          return HomePageSkeleton();
        },
      ),
    );
  }

  // ======= Breaking News Card =======
  Widget _buildBreakingCard(BuildContext context, Articles article, int index) {
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
                        IconButton(
                          icon: Icon(
                            
                            handlebookmarkicon(context, article)?Icons.bookmark_border:Icons.bookmark,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _handleBookmarkPress(context, article);
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
}

Future<bool?> handlebookmarkicon(
  BuildContext context,
  Articles article,
) async {
  if (!context.mounted) return null;

  final bookmarksCubit = context.read<BookmarksCubit>();
  final isBookmarked = await bookmarksCubit.isBookmarked(article);

  if (!context.mounted) return null;

  if (isBookmarked) {
    return true;
  } else {
    return false;
  }
}
