import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/logic/cubit/fetch%20data/fetch_cubit.dart';
import 'package:newsily/logic/cubit/fetch%20data/fetch_state.dart';
import 'package:newsily/presentation/widgets/homepage%20widgets/carousel_widget.dart';
import 'package:newsily/presentation/widgets/homepage%20widgets/featured_card.dart';
import 'package:newsily/presentation/widgets/homepage%20widgets/home_page_skeleton.dart';
import 'package:newsily/presentation/widgets/homepage%20widgets/suggesion_banner.dart';
import 'package:newsily/presentation/widgets/homepage%20widgets/top_stories_section.dart';
import 'package:newsily/presentation/widgets/homepage%20widgets/trending_card.dart';
import '../../data/models/news_data_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();
  List<Articles> _cachedLatestNews = [];

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildSearchResults(BuildContext context, List<Articles> results) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Results"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _searchController.clear();
            context.read<FetchCubit>().performSearch('');
          },
        ),
      ),
      body: results.isEmpty
          ? const Center(child: Text("No results found"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final article = results[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      article.title ?? 'No title',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      article.description ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      // TODO: Navigate to detail page
                      // Navigator.push(...);
                    },
                  ),
                );
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
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
            // 🔍 NEW: Check if user is searching
            if (state.searchQuery.isNotEmpty) {
              return _buildSearchResults(context, state.searchResults);
            }
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
              // ==== SEARCH BAR ====
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search news...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            context.read<FetchCubit>().performSearch('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (query) {
                  _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 0), () {
                    context.read<FetchCubit>().performSearch(query);
                  });
                },
                onSubmitted: (query) {
                  context.read<FetchCubit>().performSearch(query);
                },
              ),
              const SizedBox(height: 24),

              // ==== BREAKING NEWS ====
              const Text(
                "Breaking News",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              CarouselWidget(
                news: latestNews.take(4).toList(),
                itemCount: latestNews.length > 4 ? 4 : latestNews.length,
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

              //  TRENDING NOW (Vertical List)
              if (state.technologyNews != null) ...[
                const Text(
                  "Trending Now",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 12),
                ...state.technologyNews!
                    .take(5)
                    .map((article) => buildTrendingCard(context, article)),
                const SizedBox(height: 32),
              ],
              //  FEATURED REPORTS / EDITOR'S PICKS
              if (state.healthNews!.isNotEmpty) ...[
                const Text(
                  "Editor's Picks",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...state.sportsNews!
                    .take(2)
                    .map((article) => buildFeaturedCard(context, article)),
                const SizedBox(height: 32),
              ],

              // ==== Suggestion Section ====
              buildSuggestionBanner(context),
            ],
          ),
        ),
      ),
    );
  }
}

