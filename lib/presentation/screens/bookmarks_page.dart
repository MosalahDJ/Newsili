import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/data/models/news_data_model.dart';
import 'package:newsily/logic/cubit/save_articles.dart/bookmarks_cubit.dart';
import 'package:newsily/logic/cubit/save_articles.dart/bookmarks_state.dart';
import 'package:newsily/presentation/widgets/home_page_skeleton.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  @override
  void initState() {
    super.initState();
    context.read<BookmarksCubit>().loadBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<BookmarksCubit, BookmarksState>(
        builder: (context, state) {
          if (state is BookmarksLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookmarksError) {
            return Center(child: Text(state.message));
          } else if (state is BookmarksLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<BookmarksCubit>().loadBookmarks();
              },
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: _buildContent(context, state.savedArticles),
                ),
              ),
            );
          }
          return HomePageSkeleton();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Articles> articles) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: articles.length, // Replace with actual count
      itemBuilder: (context, index) {
        return _BookmarkCard(
          title: articles[index].title!,
          description: articles[index].description,
          date: DateTime.now(),
        );
      },
    );
  }
}

// Reusable card (keep for when you add real items)
class _BookmarkCard extends StatelessWidget {
  final String title;
  final String? description;
  final DateTime date;

  const _BookmarkCard({
    required this.title,
    this.description,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(
                description!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                _formatDate(date),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.difference(now).inDays == 0) return 'Today';
    return '${date.month}/${date.day}';
  }
}
