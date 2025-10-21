import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/logic/cubit/fetch%20data/fetch_cubit.dart';
import 'package:newsily/logic/cubit/fetch%20data/fetch_state.dart';
import 'package:newsily/logic/cubit/save_articles.dart/bookmarks_cubit.dart';
import 'package:newsily/logic/cubit/save_articles.dart/bookmarks_state.dart';
import 'package:newsily/presentation/screens/article_description.dart';
import 'package:newsily/presentation/widgets/home_page_skeleton.dart';
import 'package:newsily/presentation/widgets/suggesion_banner.dart';
import 'package:newsily/presentation/widgets/top_stories_section.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../data/models/news_data_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _currentPage = 0;
  List<Articles> _cachedLatestNews = [];

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
        buildWhen: (previous, current) {
          // Only rebuild when data actually changes
          if (current is DataLoaded) {
            final newNews = current.generalNews ?? [];
            if (listEquals(_cachedLatestNews, newNews)) {
              return false;
            }
            _cachedLatestNews = newNews;
            return true;
          }
          return true;
        },
        builder: (context, state) {
          if (state is DataLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DataError) {
            return Center(child: Text(state.errortext));
          } else if (state is DataLoaded) {
            return _buildContent(context, state);
          }
          return const HomePageSkeleton();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, DataLoaded state) {
    final latestNews = state.generalNews ?? [];
    final topStories = state.businessNews ?? [];

    if (latestNews.isEmpty) {
      return const Center(child: Text("No news available"));
    }

    return RefreshIndicator(
      onRefresh: () async => context.read<FetchCubit>().getArticles(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==== BREAKING NEWS ====
              const Text(
                "Breaking News",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              _buildCarousel(latestNews.take(4).toList()),

              const SizedBox(height: 12),
              _buildPageIndicator(
                latestNews.length > 4 ? 4 : latestNews.length,
              ),

              const SizedBox(height: 30),

              // ==== TOP STORIES ====
              const Text(
                "Top Stories",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
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

  Widget _buildCarousel(List<Articles> news) {
    return SizedBox(
      height: 280,
      child: CarouselSlider.builder(
        carouselController: _carouselController,
        itemCount: news.length,
        itemBuilder: (context, index, realIndex) {
          return _buildBreakingCard(context, news[index], index);
        },
        options: CarouselOptions(
          height: 250,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 500),
          autoPlayCurve: Curves.easeInOut,
          pauseAutoPlayOnTouch: true,
          aspectRatio: 16 / 9,
          viewportFraction: 0.8,
          enlargeCenterPage: true,
          onPageChanged: (index, reason) {
            setState(() => _currentPage = index);
          },
        ),
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

  Widget _buildPageIndicator(int itemCount) {
    return Center(
      child: AnimatedSmoothIndicator(
        activeIndex: _currentPage,
        count: itemCount,
        effect: ExpandingDotsEffect(
          dotHeight: 8,
          dotWidth: 8,
          activeDotColor: Theme.of(context).colorScheme.primary,
          dotColor: Colors.grey.withOpacity(0.3),
        ),
      ),
    );
  }
}
