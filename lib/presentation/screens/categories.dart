import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/data/models/news_data_model.dart';
import 'package:newsily/logic/cubit/fetch%20data/fetch_cubit.dart';
import 'package:newsily/logic/cubit/fetch%20data/fetch_state.dart';
import 'package:newsily/presentation/widgets/categories_page_skeletonizer.dart';
import '../widgets/category_section.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          "Categories",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
      ),
      body: BlocBuilder<FetchCubit, FetchState>(
        builder: (context, state) {
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

          if (state is DataLoaded) {
            final sections = [
              {"title": "General", "articles": state.generalNews},
              {"title": "Business", "articles": state.businessNews},
              {"title": "Entertainment", "articles": state.entertainmentNews},
              {"title": "Health", "articles": state.healthNews},
              {"title": "Science", "articles": state.scienceNews},
              {"title": "Sports", "articles": state.sportsNews},
              {"title": "Technology", "articles": state.technologyNews},
            ];

            return RefreshIndicator(
              onRefresh: () async {
                context.read<FetchCubit>().getArticles();
              },
              color: theme.colorScheme.primary,
              backgroundColor: isDark
                  ? theme.colorScheme.surfaceContainerHighest
                  : Colors.white,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                itemCount: sections.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final item = sections[index];
                  final title = item["title"] as String;
                  final articles = item["articles"] as List<Articles>;

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: articles.isNotEmpty
                        ? Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.grey.shade900
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(8),
                            child: CategorySection(
                              title: title,
                              articles: articles,
                            ),
                          )
                        : Container(
                            height: 150,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              "No articles available for $title",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.hintColor,
                              ),
                            ),
                          ),
                  );
                },
              ),
            );
          }

          /// 🩶 Skeleton when loading
          return const CategoriesPageSkeleton();
        },
      ),
    );
  }
}
