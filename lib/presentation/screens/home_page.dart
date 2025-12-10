import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/helper/themes.dart';
import 'package:newsily/logic/cubit/fetch_data/fetch_cubit.dart';
import 'package:newsily/logic/cubit/fetch_data/fetch_state.dart';
import 'package:newsily/logic/cubit/them/them_cubit.dart';
import 'package:newsily/presentation/screens/search_page.dart';
import 'package:newsily/presentation/widgets/homepage%20widgets/carousel_widget.dart';
import 'package:newsily/presentation/widgets/homepage%20widgets/featured_card.dart';
import 'package:newsily/presentation/widgets/homepage%20widgets/home_page_skeleton.dart';
import 'package:newsily/presentation/widgets/homepage%20widgets/suggesion_banner.dart';
import 'package:newsily/presentation/widgets/homepage%20widgets/top_stories_section.dart';
import 'package:newsily/presentation/widgets/homepage%20widgets/trending_card.dart';
import 'package:newsily/presentation/widgets/schow_exit_confirmation_dialogue.dart';
import 'package:newsily/presentation/widgets/search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (!didPop) {
          await showExitConfirmationDialog(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          actions: [
            IconButton(
              icon: Icon(
                Icons.brightness_6,
                color: theme.colorScheme.onSurface,
              ),
              onPressed: () {
                context.read<ThemeCubit>().toggle();
              },
            ),
          ],
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 35,
                height: 35,
                child: Image.asset(
                  'lib/assets/images/newsily_logo/newsily_logo_png.png',
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                "Newsily",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          centerTitle: false,
          backgroundColor: theme.colorScheme.surface,
          foregroundColor: theme.colorScheme.onSurface,
          surfaceTintColor: theme.colorScheme.surface,
        ),
        body: BlocBuilder<FetchCubit, FetchState>(
          builder: (context, state) {
            if (state is DataLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
              );
            } else if (state is DataError) {
              return Center(
                child: Text(
                  state.errortext,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              );
            } else if (state is DataLoaded) {
              return _buildContent(context, state);
            }
            return const HomePageSkeleton();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, DataLoaded state) {
    final theme = Theme.of(context);
    final latestNews = state.generalNews ?? [];
    final topStories = state.businessNews ?? [];

    return RefreshIndicator(
      onRefresh: () async => context.read<FetchCubit>().getArticles(),
      color: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.surface,
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
              Text(
                "Breaking News",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),

              CarouselWidget(
                news: latestNews.take(4).toList(),
                itemCount: latestNews.length > 4 ? 4 : latestNews.length,
              ),

              const SizedBox(height: 30),

              // ==== TOP STORIES ====
              Text(
                "Top Stories",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),

              buildTopStoriesSection(context, topStories),

              const SizedBox(height: 24),

              //  TRENDING NOW (Vertical List)
              if (state.technologyNews != null) ...[
                Text(
                  "Trending Now",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: theme.technologyColor, // Using category color
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
                Text(
                  "Editor's Picks",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
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
