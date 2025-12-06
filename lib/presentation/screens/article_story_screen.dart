import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:newsily/data/models/news_data_model.dart';
import 'package:newsily/data/models/story_converter.dart';
import 'package:newsily/helper/handle_bookmark_press.dart';
import 'package:newsily/helper/share_function.dart';
import 'package:newsily/helper/url_luncher_function.dart';

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

class ArticleStoryScreenState extends State<ArticleStoryScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late PageController _storyPageController;
  late AnimationController _animationController;
  late List<ArticleStory> _stories;
  int _currentStoryIndex = 0;
  int _currentItemIndex = 0;
  bool _isPaused = false;
  bool _issaved = false;

  bool _showFullDescription = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _stories = convertArticlesToStories(widget.articles);
    _currentStoryIndex = widget.initialArticleIndex.clamp(
      0,
      _stories.length - 1,
    );
    _currentItemIndex = widget.initialItemIndex.clamp(
      0,
      _stories[_currentStoryIndex].items.length - 1,
    );

    _pageController = PageController(initialPage: _currentItemIndex);
    _storyPageController = PageController(initialPage: _currentStoryIndex);

    _animationController =
        AnimationController(vsync: this, duration: _getCurrentItem().duration)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _nextItem();
            }
          });

    _startAnimation();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _animationController.removeStatusListener((status) {});
    _animationController.dispose();

    // Check if controllers are still attached before disposing
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

  StoryItem _getCurrentItem() {
    if (_currentStoryIndex >= _stories.length) {
      _currentStoryIndex = _stories.length - 1;
    }
    if (_currentItemIndex >= _stories[_currentStoryIndex].items.length) {
      _currentItemIndex = _stories[_currentStoryIndex].items.length - 1;
    }
    return _stories[_currentStoryIndex].items[_currentItemIndex];
  }

  Articles _getCurrentArticle() {
    return _stories[_currentStoryIndex].article;
  }

  void _startAnimation() {
    if (_isDisposed) return;

    final currentItem = _getCurrentItem();
    _animationController.duration = currentItem.duration;

    if (!_isPaused && _animationController.status != AnimationStatus.forward) {
      _animationController.forward();
    }
  }

  void _nextItem() async {
    if (_isDisposed) return;

    final currentStory = _stories[_currentStoryIndex];

    // Check if we can go to next item in current story
    if (_currentItemIndex + 1 < currentStory.items.length) {
      setState(() {
        _currentItemIndex++;
        _showFullDescription = false;
      });

      try {
        if (_pageController.hasClients) {
          await _pageController.animateToPage(
            _currentItemIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      } catch (_) {}

      _animationController.reset();
      _startAnimation();
    } else {
      // Go to next story
      _nextStory();
    }
  }

  void _previousItem() async {
    if (_isDisposed) return;

    if (_currentItemIndex - 1 >= 0) {
      setState(() {
        _currentItemIndex--;
        _showFullDescription = false;
      });

      try {
        if (_pageController.hasClients) {
          await _pageController.animateToPage(
            _currentItemIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      } catch (_) {}

      _animationController.reset();
      _startAnimation();
    } else if (_currentStoryIndex - 1 >= 0) {
      _previousStory();
    }
  }

  void _nextStory() async {
    if (_isDisposed) return;

    if (_currentStoryIndex + 1 < _stories.length) {
      setState(() {
        _currentStoryIndex++;
        _currentItemIndex = 0;
        _showFullDescription = false;
      });

      try {
        if (_storyPageController.hasClients) {
          await _storyPageController.animateToPage(
            _currentStoryIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      } catch (_) {}

      try {
        if (_pageController.hasClients) {
          _pageController.jumpToPage(0);
        }
      } catch (_) {}

      _animationController.reset();
      _startAnimation();
    } else {
      // Last story completed, exit
      _exitStoryViewer();
    }
  }

  void _previousStory() async {
    if (_isDisposed) return;

    if (_currentStoryIndex - 1 >= 0) {
      setState(() {
        _currentStoryIndex--;
        _currentItemIndex = _stories[_currentStoryIndex].items.length - 1;
        _showFullDescription = false;
      });

      try {
        if (_storyPageController.hasClients) {
          await _storyPageController.animateToPage(
            _currentStoryIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      } catch (_) {}

      try {
        if (_pageController.hasClients) {
          _pageController.jumpToPage(_currentItemIndex);
        }
      } catch (_) {}

      _animationController.reset();
      _startAnimation();
    }
  }

  //TODO: I schould modify this schit here and meke it respnsive withe save
  //TODO: articles bloc
  void _toggleSave() {
    if (_isDisposed) return;

    setState(() {
      _issaved = !_issaved;
    });
  }

  void _togglePause() {
    if (_isDisposed) return;

    setState(() {
      _isPaused = !_isPaused;
    });

    if (_isPaused) {
      _animationController.stop();
    } else {
      _animationController.forward();
    }
  }

  void _toggleDescription() {
    if (_isDisposed) return;
    setState(() {
      _showFullDescription = !_showFullDescription;
    });
  }

  void _exitStoryViewer() {
    if (_isDisposed) return;

    // Stop animation first
    _animationController.stop();

    // Delay to ensure UI is stable before popping
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_stories.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'No stories available',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final currentStory = _stories[_currentStoryIndex];
    final article = _getCurrentArticle();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content area with PageView
            Positioned.fill(
              child: PageView.builder(
                controller: _pageController,
                physics:
                    const NeverScrollableScrollPhysics(), // Disable manual swipe
                itemCount: currentStory.items.length,
                itemBuilder: (context, index) {
                  final item = currentStory.items[index];
                  return _buildContent(item);
                },

                onPageChanged: (index) {
                  if (_isDisposed) return;
                  setState(() {
                    _currentItemIndex = index;
                    _showFullDescription = false;
                  });
                  _animationController.reset();
                  _startAnimation();
                },
              ),
            ),

            // Stories PageView (for horizontal story navigation)
            Positioned.fill(
              child: PageView.builder(
                controller: _storyPageController,
                itemCount: _stories.length,
                itemBuilder: (context, index) {
                  return Container(); // Empty container, just for navigation
                },
                onPageChanged: (index) {
                  if (_isDisposed) return;
                  setState(() {
                    _currentStoryIndex = index;
                    _currentItemIndex = 0;
                    _showFullDescription = false;
                  });
                  _pageController.jumpToPage(0);
                  _animationController.reset();
                  _startAnimation();
                },
              ),
            ),

            // Progress Indicators
            _buildProgressIndicators(currentStory),

            // Top Bar with Article Info
            _buildTopBar(article),

            // Gesture Detectors for Navigation
            _buildGestureDetectors(),

            // Close Button
            _buildCloseButton(),

            // Bottom Controls
            _buildBottomControls(article),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(StoryItem item) {
    switch (item.type) {
      case 'image':
        return _buildImageContent(item);
      case 'text':
        return _buildTextContent(item);
      case 'content':
        return _buildContentPage(item);
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
                  Colors.black.withValues(alpha: .8),
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

  Widget _buildTextContent(StoryItem item) {
    return Container(
      color: _getBackgroundColor(),
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
                onTap: _toggleDescription,
                child: Text(
                  item.description!,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                    height: 1.5,
                  ),
                  maxLines: _showFullDescription ? 20 : 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            const SizedBox(height: 20),
            if (!_showFullDescription &&
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

  Widget _buildContentPage(StoryItem item) {
    return Container(
      color: _getBackgroundColor(),
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

  Color _getBackgroundColor() {
    final colors = [
      const Color(0xFF1a1a2e),
      const Color(0xFF16213e),
      const Color(0xFF0f3460),
      const Color(0xFF222831),
    ];
    return colors[_currentItemIndex % colors.length];
  }

  Widget _buildProgressIndicators(ArticleStory story) {
    return Positioned(
      top: MediaQuery.of(context).padding.top,
      left: 16,
      right: 16,
      child: Column(
        children: [
          // Story progress (between stories)
          Row(
            children: _stories.asMap().entries.map((entry) {
              int index = entry.key;
              return Expanded(
                child: Container(
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    color: index < _currentStoryIndex
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
            children: story.items.asMap().entries.map((entry) {
              int index = entry.key;

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

                      // Progress
                      if (index < _currentItemIndex)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        )
                      else if (index == _currentItemIndex)
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              width:
                                  MediaQuery.of(context).size.width *
                                  _animationController.value /
                                  story.items.length,
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

  Widget _buildTopBar(Articles article) {
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
              '${_currentStoryIndex + 1}/${_stories.length}',
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

  Widget _buildBottomControls(Articles article) {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 20,
      left: 0,
      right: 0,
      child: Column(
        children: [
          // Page indicator
          Text(
            '${_currentItemIndex + 1}/${_stories[_currentStoryIndex].items.length}',
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
                onTap: () {
                  _openFullArticle(article);
                },
              ),

              // Share
              _buildControlButton(
                icon: Icons.share,
                label: 'Share',
                onTap: () {
                  _shareArticle(article);
                },
              ),

              // Pause/Play
              _buildControlButton(
                icon: _isPaused ? Icons.play_arrow : Icons.pause,
                label: _isPaused ? 'Play' : 'Pause',
                onTap: _togglePause,
              ),

              //TODO: I schould modify this schit here and meke it respnsive withe save
              //TODO: articles bloc
              // Bookmark/Save
              _buildControlButton(
                icon: _issaved ? Icons.bookmark : Icons.bookmark_border,
                label: _issaved ? 'Saved' : 'Save',
                onTap: () {
                  _toggleSave();
                  _saveArticle(article);
                },
              ),

              // More options
              _buildControlButton(
                icon: Icons.more_vert,
                label: 'More',
                onTap: () {
                  _showArticleOptions(article);
                },
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

  Widget _buildGestureDetectors() {
    return Row(
      children: [
        // Left side tap for previous
        Expanded(
          child: GestureDetector(
            onTap: _previousItem,
            onLongPress: () {
              if (_isDisposed) return;
              setState(() {
                _isPaused = true;
              });
              _animationController.stop();
            },
            onLongPressEnd: (details) {
              if (_isDisposed) return;
              setState(() {
                _isPaused = false;
              });
              _animationController.forward();
            },
          ),
        ),

        // Center area for pause/play
        Expanded(
          child: GestureDetector(
            onTap: _togglePause,
            child: Container(color: Colors.transparent),
          ),
        ),

        // Right side tap for next
        Expanded(
          child: GestureDetector(
            onTap: _nextItem,
            onLongPress: () {
              if (_isDisposed) return;
              setState(() {
                _isPaused = true;
              });
              _animationController.stop();
            },
            onLongPressEnd: (details) {
              if (_isDisposed) return;
              setState(() {
                _isPaused = false;
              });
              _animationController.forward();
            },
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
        onPressed: _exitStoryViewer,
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

  _articleNotOpned() {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Could not open the article"),
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



//Todo: I schould fix the saving button UiKitView;
//Todo: Also I schould add a coppy button in social data in the about page;