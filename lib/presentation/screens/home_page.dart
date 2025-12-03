import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/logic/cubit/fetch%20data/fetch_cubit.dart';
import 'package:newsily/logic/cubit/fetch%20data/fetch_state.dart';
import 'package:newsily/presentation/screens/search_page.dart';
import 'package:newsily/presentation/widgets/homepage%20widgets/carousel_widget.dart';
import 'package:newsily/presentation/widgets/homepage%20widgets/featured_card.dart';
import 'package:newsily/presentation/widgets/homepage%20widgets/home_page_skeleton.dart';
import 'package:newsily/presentation/widgets/homepage%20widgets/suggesion_banner.dart';
import 'package:newsily/presentation/widgets/homepage%20widgets/top_stories_section.dart';
import 'package:newsily/presentation/widgets/homepage%20widgets/trending_card.dart';
import 'package:newsily/presentation/widgets/search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

    return RefreshIndicator(
      onRefresh: () async => context.read<FetchCubit>().getArticles(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==== SEARCH BAR (NAVIGATIONAL) ====
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchPage()),
                  );
                },
                borderRadius: BorderRadius.circular(30),
                child: Hero(
                  tag: "search-bar-hero",
                  child: Material(
                    type: MaterialType.transparency,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: const MySearchBar(isButton: true),
                    ),
                  ),
                ),
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
