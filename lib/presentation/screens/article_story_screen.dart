import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/data/models/news_data_model.dart';
import 'package:newsily/data/models/story_converter.dart';
import 'package:newsily/helper/handle_bookmark_press.dart';
import 'package:newsily/helper/share_function.dart';
import 'package:newsily/helper/url_luncher_function.dart';
import 'package:newsily/logic/cubit/story/story_cubit.dart';
import 'package:newsily/logic/cubit/story/story_state.dart';

class ArticleStoryScreen extends StatefulWidget {
  final List<Articles> articles;
  final int initialArticleIndex;
  final int initialItemIndex;

  const ArticleStoryScreen({
    super.key,
    required this.articles,
    this.initialArticleIndex = 0,
    this.initialItemIndex = 0,
  });

  @override
  ArticleStoryScreenState createState() => ArticleStoryScreenState();
}

class ArticleStoryScreenState extends State<ArticleStoryScreen> {
  late PageController _pageController;
  late PageController _storyPageController;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _storyPageController = PageController();
  }

  @override
  void dispose() {
    _isDisposed = true;

    try {
      if (_pageController.hasClients) {
        _pageController.dispose();
      }
    } catch (_) {}

    try {
      if (_storyPageController.hasClients) {
        _storyPageController.dispose();
      }
    } catch (_) {}

    super.dispose();
  }

  void _syncPageControllers(StoryLoaded state) {
    // Sync story page controller
    if (_storyPageController.hasClients &&
        _storyPageController.page?.round() != state.currentStoryIndex) {
      _storyPageController.jumpToPage(state.currentStoryIndex);
    }

    // Sync item page controller
    if (_pageController.hasClients &&
        _pageController.page?.round() != state.currentItemIndex) {
      _pageController.jumpToPage(state.currentItemIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Create the cubit once when the provider is created
      create: (context) => StoryCubit()
        ..initialize(
          articles: widget.articles,
          initialArticleIndex: widget.initialArticleIndex,
          initialItemIndex: widget.initialItemIndex,
        ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: BlocListener<StoryCubit, StoryState>(
            listener: (context, state) {
              // Sync PageControllers when state changes
              if (state is StoryLoaded && !_isDisposed) {
                _syncPageControllers(state);
              }
            },
            child: BlocBuilder<StoryCubit, StoryState>(
              builder: (context, state) {
                if (state is StoryError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }

                if (state is! StoryLoaded) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                return _buildStoryView(context, state);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoryView(BuildContext context, StoryLoaded state) {
    final cubit = context.read<StoryCubit>();
    final currentStory = state.stories[state.currentStoryIndex];
    final article = currentStory.article;

    return Stack(
      children: [
        // Main content area with PageView
        Positioned.fill(
          child: PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: currentStory.items.length,
            itemBuilder: (context, index) {
              final item = currentStory.items[index];
              return _buildContent(item, state);
            },

            onPageChanged: (index) {
              if (_isDisposed) return;
            },
          ),
        ),

        // Stories PageView (for horizontal story navigation)
        Positioned.fill(
          child: PageView.builder(
            controller: _storyPageController,
            itemCount: state.stories.length,
            itemBuilder: (context, index) => Container(),
            onPageChanged: (index) {
              if (_isDisposed) return;
              // FIXED: Use jumpToStory instead of initialize
              cubit.jumpToStory(index);
            },
          ),
        ),

        // Progress Indicators
        _buildProgressIndicators(context, state),

        // Top Bar with Article Info
        _buildTopBar(article, state),

        // Gesture Detectors for Navigation
        _buildGestureDetectors(context, cubit, state),

        // Close Button
        _buildCloseButton(),

        // Bottom Controls
        _buildBottomControls(article, state, cubit),
      ],
    );
  }

  Widget _buildContent(StoryItem item, StoryLoaded state) {
    switch (item.type) {
      case 'image':
        return _buildImageContent(item);
      case 'text':
        return _buildTextContent(item, state);
      case 'content':
        return _buildContentPage(item, state);
      default:
        return Container(color: Colors.black);
    }
  }

  Widget _buildImageContent(StoryItem item) {
    return Stack(
      children: [
        if (item.imageUrl != null && item.imageUrl!.isNotEmpty)
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: item.imageUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey[900]),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[900],
                child: const Icon(Icons.broken_image, color: Colors.white54),
              ),
            ),
          ),

        // Gradient overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.8),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.3),
                ],
              ),
            ),
          ),
        ),

        // Article title overlay
        Positioned(
          bottom: 120,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.title != null)
                Text(
                  item.title!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 10),
              if (item.author != null)
                Text(
                  'By ${item.author}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextContent(StoryItem item, StoryLoaded state) {
    return Container(
      color: _getBackgroundColor(state),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (item.title != null)
              Text(
                item.title!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            const SizedBox(height: 30),
            if (item.description != null)
              GestureDetector(
                // FIXED: Use toggleDescription instead of initialize
                onTap: () => context.read<StoryCubit>().toggleDescription(),
                child: Text(
                  item.description!,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                    height: 1.5,
                  ),
                  maxLines: state.showFullDescription ? 20 : 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            const SizedBox(height: 20),
            if (!state.showFullDescription &&
                item.description != null &&
                item.description!.length > 150)
              Text(
                'Tap to read more...',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentPage(StoryItem item, StoryLoaded state) {
    return Container(
      color: _getBackgroundColor(state),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item.title!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 20),
            if (item.content != null)
              Text(
                _cleanContent(item.content!),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  height: 1.6,
                ),
              ),
            const SizedBox(height: 30),
            _buildArticleMeta(item),
          ],
        ),
      ),
    );
  }

  String _cleanContent(String content) {
    return content.replaceAll(RegExp(r'\[.*?\]'), '');
  }

  Color _getBackgroundColor(StoryLoaded state) {
    final colors = [
      const Color(0xFF1a1a2e),
      const Color(0xFF16213e),
      const Color(0xFF0f3460),
      const Color(0xFF222831),
    ];
    return colors[state.currentItemIndex % colors.length];
  }

  Widget _buildProgressIndicators(BuildContext context, StoryLoaded state) {
    final currentStory = state.stories[state.currentStoryIndex];

    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 16,
      right: 16,
      child: Column(
        children: [
          // Story progress (between stories)
          Row(
            children: state.stories.asMap().entries.map((entry) {
              int index = entry.key;
              return Expanded(
                child: Container(
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    color: index < state.currentStoryIndex
                        ? Colors.white
                        : index == state.currentStoryIndex
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          // Page progress (within current story)
          Row(
            children: currentStory.items.asMap().entries.map((entry) {
              int index = entry.key;
              final isCurrentItem = index == state.currentItemIndex;
              final isCompleted = index < state.currentItemIndex;

              return Expanded(
                child: Container(
                  height: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Stack(
                    children: [
                      // Background
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      // Progress bar
                      if (isCompleted)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        )
                      else if (isCurrentItem)
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 50),
                              width: constraints.maxWidth * state.progress,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(Articles article, StoryLoaded state) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 60,
      left: 16,
      right: 16,
      child: Row(
        children: [
          // Source/Publisher info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.article_outlined, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Text(
                  article.source?.name ?? 'News Source',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const Spacer(),

          // Story counter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${state.currentStoryIndex + 1}/${state.stories.length}',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),

          const SizedBox(width: 8),

          // Time info
          if (article.publishedAt != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _formatTime(article.publishedAt!),
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomControls(
    Articles article,
    StoryLoaded state,
    StoryCubit cubit,
  ) {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 20,
      left: 0,
      right: 0,
      child: Column(
        children: [
          // Page indicator
          Text(
            '${state.currentItemIndex + 1}/${state.stories[state.currentStoryIndex].items.length}',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Open Full Article
              _buildControlButton(
                icon: Icons.launch,
                label: 'Read Full',
                onTap: () => _openFullArticle(article),
              ),

              // Share
              _buildControlButton(
                icon: Icons.share,
                label: 'Share',
                onTap: () => _shareArticle(article),
              ),

              // Pause/Play - FIXED: Use togglePause
              _buildControlButton(
                icon: state.isPaused ? Icons.play_arrow : Icons.pause,
                label: state.isPaused ? 'Play' : 'Pause',
                onTap: () => cubit.togglePause(),
              ),

              //Todo: I schould make some changes here for make the save func
              //work perfectly and just in the selected story not all stories
              // Bookmark/Save - FIXED: Use toggleSave
              _buildControlButton(
                icon: state.isSaved ? Icons.bookmark : Icons.bookmark_border,
                label: state.isSaved ? 'Saved' : 'Save',
                onTap: () {
                  cubit.toggleSave();
                  _saveArticle(article);
                },
              ),

              // More options
              _buildControlButton(
                icon: Icons.more_vert,
                label: 'More',
                onTap: () => _showArticleOptions(article),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 10)),
      ],
    );
  }

  Widget _buildArticleMeta(StoryItem item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.author != null)
            Row(
              children: [
                Icon(Icons.person_outline, color: Colors.white70, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Author: ${item.author}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          if (item.sourceName != null) const SizedBox(height: 8),
          if (item.sourceName != null)
            Row(
              children: [
                Icon(Icons.source_outlined, color: Colors.white70, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Source: ${item.sourceName}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          if (item.publishedAt != null) const SizedBox(height: 8),
          if (item.publishedAt != null)
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.white70, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _formatDetailedTime(item.publishedAt!),
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildGestureDetectors(
    BuildContext context,
    StoryCubit cubit,
    StoryLoaded state,
  ) {
    return Row(
      children: [
        // Left side tap for previous
        Expanded(
          child: GestureDetector(
            onTap: () => cubit.previousItem(),
            onLongPress: () => cubit.pause(),
            onLongPressEnd: (details) => cubit.resume(),
          ),
        ),

        // Center area for pause/play
        Expanded(
          child: GestureDetector(
            onTap: () => cubit.togglePause(),
            child: Container(color: Colors.transparent),
          ),
        ),

        // Right side tap for next
        Expanded(
          child: GestureDetector(
            onTap: () => cubit.nextItem(),
            onLongPress: () => cubit.pause(),
            onLongPressEnd: (details) => cubit.resume(),
          ),
        ),
      ],
    );
  }

  Widget _buildCloseButton() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 8,
      child: IconButton(
        icon: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.black54,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  String _formatTime(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 30) {
        return '${difference.inDays}d ago';
      } else {
        final formatter = DateFormat(
          'MMM d',
          Localizations.localeOf(context).toString(),
        );
        return formatter.format(date);
      }
    } catch (e) {
      return '';
    }
  }

  String _formatDetailedTime(DateTime date) {
    final formatter = DateFormat(
      'MMMM d, yyyy • h:mm a',
      Localizations.localeOf(context).toString(),
    );
    return formatter.format(date);
  }

  void _openFullArticle(Articles article) async {
    final success = await tryOpenArticleUrl(article.url!);
    if (!success && context.mounted) {
      _articleNotOpned();
    }
  }

  void _articleNotOpned() {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Could not open the article"),
        backgroundColor: theme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _shareArticle(Articles article) {
    shareArticle(
      context,
      title: article.title ?? 'Check out this article',
      url: article.url ?? '',
    );
  }

  void _saveArticle(Articles article) {
    handleBookmarkPress(context, article);
  }

  void _showArticleOptions(Articles article) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.translate, color: Colors.white),
                title: const Text(
                  'Translate',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.text_fields, color: Colors.white),
                title: const Text(
                  'Text Size',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.report, color: Colors.white),
                title: const Text(
                  'Report Article',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
