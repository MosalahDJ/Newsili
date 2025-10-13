import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/data/models/news_data_model.dart';
import 'package:newsily/logic/cubit/fetch%20data/fetch_cubit.dart';
import 'package:newsily/logic/cubit/fetch%20data/fetch_state.dart';
import 'package:newsily/presentation/widgets/categories_page_skeletonizer.dart';
import 'package:newsily/presentation/widgets/news_card.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> categories = const [
    "General",
    "Business",
    "Entertainment",
    "Health",
    "Science",
    "Sports",
    "Technology",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text(
            "Categories",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          centerTitle: true,
          elevation: 2,
          backgroundColor: theme.colorScheme.surface,
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            automaticIndicatorColorAdjustment: true,
            labelColor: Colors.grey[700],
            unselectedLabelColor: Colors.grey[700],
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            overlayColor: WidgetStateProperty.all(
              Colors.transparent,
            ), // cleaner look
            tabs: categories
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Tab(text: e),
                  ),
                )
                .toList(),
          ),
        ),
        body: BlocBuilder<FetchCubit, FetchState>(
          builder: (context, state) {
            // 🔴 Error State
            if (state is DataError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "Something went wrong:\n${state.errortext}",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }

            // 🟢 Loaded State
            if (state is DataLoaded) {
              final sections = {
                "General": state.generalNews,
                "Business": state.businessNews,
                "Entertainment": state.entertainmentNews,
                "Health": state.healthNews,
                "Science": state.scienceNews,
                "Sports": state.sportsNews,
                "Technology": state.technologyNews,
              };

              return RefreshIndicator(
                onRefresh: () async => context.read<FetchCubit>().getArticles(),
                color: theme.colorScheme.primary,
                backgroundColor: isDark
                    ? theme.colorScheme.surfaceContainerHighest
                    : Colors.white,
                child: TabBarView(
                  controller: _tabController,
                  physics: const BouncingScrollPhysics(),
                  children: categories.map((cat) {
                    final articles = sections[cat] ?? [];
                    if (articles.isEmpty) {
                      return Center(
                        child: Text(
                          "No articles available for $cat",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.hintColor,
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      itemCount: articles.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => Navigator.pushNamed(
                            context,
                            "/article",
                            arguments: articles,
                          ),
                          child: NewsCard(article: articles[index], i: index),
                        );
                      },
                    );
                  }).toList(),
                ),
              );
            }

            // 🩶 Loading Skeleton
            return const CategoriesPageSkeleton();
          },
        ),
      ),
    );
  }
}
