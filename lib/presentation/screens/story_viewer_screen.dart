// screens/story_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:newsily/data/models/story_data_model.dart';

class StoryScreen extends StatefulWidget {
  final List<Story> stories;
  final int initialStoryIndex;
  final int initialItemIndex;

  const StoryScreen({
    super.key,
    required this.stories,
    this.initialStoryIndex = 0,
    this.initialItemIndex = 0,
  });

  @override
  StoryScreenState createState() => StoryScreenState();
}

class StoryScreenState extends State<StoryScreen> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late PageController _storyPageController;
  late Timer _timer;
  late AnimationController _animationController;
  int _currentStoryIndex = 0;
  int _currentItemIndex = 0;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _currentStoryIndex = widget.initialStoryIndex;
    _currentItemIndex = widget.initialItemIndex;
    
    _pageController = PageController(initialPage: _currentItemIndex);
    _storyPageController = PageController(initialPage: _currentStoryIndex);
    
    _animationController = AnimationController(
      vsync: this,
      duration: _getCurrentItem().duration,
    )..addListener(() {
        if (_animationController.isCompleted) {
          _nextItem();
        }
      });

    _startAnimation();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    _storyPageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  StoryItem _getCurrentItem() {
    return widget.stories[_currentStoryIndex].items[_currentItemIndex];
  }

  void _startAnimation() {
    _animationController.duration = _getCurrentItem().duration;
    if (!_isPaused) {
      _animationController.forward();
    }
  }

  void _nextItem() {
    final currentStory = widget.stories[_currentStoryIndex];
    
    if (_currentItemIndex + 1 < currentStory.items.length) {
      setState(() {
        _currentItemIndex++;
      });
      _pageController.animateToPage(
        _currentItemIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _animationController.reset();
      _startAnimation();
    } else if (_currentStoryIndex + 1 < widget.stories.length) {
      _nextStory();
    } else {
      Navigator.pop(context);
    }
  }

  void _previousItem() {
    if (_currentItemIndex - 1 >= 0) {
      setState(() {
        _currentItemIndex--;
      });
      _pageController.animateToPage(
        _currentItemIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _animationController.reset();
      _startAnimation();
    } else if (_currentStoryIndex - 1 >= 0) {
      _previousStory();
    }
  }

  void _nextStory() {
    if (_currentStoryIndex + 1 < widget.stories.length) {
      setState(() {
        _currentStoryIndex++;
        _currentItemIndex = 0;
      });
      _storyPageController.animateToPage(
        _currentStoryIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _pageController.jumpToPage(0);
      _animationController.reset();
      _startAnimation();
    } else {
      Navigator.pop(context);
    }
  }

  void _previousStory() {
    if (_currentStoryIndex - 1 >= 0) {
      setState(() {
        _currentStoryIndex--;
        _currentItemIndex = widget.stories[_currentStoryIndex].items.length - 1;
      });
      _storyPageController.animateToPage(
        _currentStoryIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _pageController.jumpToPage(_currentItemIndex);
      _animationController.reset();
      _startAnimation();
    }
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
    
    if (_isPaused) {
      _animationController.stop();
    } else {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStory = widget.stories[_currentStoryIndex];
    final currentItem = _getCurrentItem();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Story Content
          _buildContent(currentItem),
          
          // Progress Indicators
          _buildProgressIndicators(currentStory),
          
          // Top Bar with User Info
          _buildTopBar(currentStory),
          
          // Bottom Controls
          _buildBottomControls(),
          
          // Gesture Detectors for Navigation
          _buildGestureDetectors(),
          
          // Close Button
          _buildCloseButton(),
        ],
      ),
    );
  }

  Widget _buildContent(StoryItem item) {
    if (item.type == 'image') {
      return Positioned.fill(
        child: CachedNetworkImage(
          imageUrl: item.contentUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[900],
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[900],
            child: const Icon(Icons.error, color: Colors.white),
          ),
        ),
      );
    } else {
      return Container(
        color: Colors.black,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              item.text ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
  }

  Widget _buildProgressIndicators(Story story) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 50,
      left: 16,
      right: 16,
      child: Row(
        children: story.items.asMap().entries.map((entry) {
          int index = entry.key;
          StoryItem item = entry.value;
          
          return Expanded(
            child: Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(1),
              ),
              child: Stack(
                children: [
                  // Background
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  
                  // Progress
                  if (index < _currentItemIndex)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    )
                  else if (index == _currentItemIndex)
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(1),
                          ),
                          width: MediaQuery.of(context).size.width *
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
    );
  }

  Widget _buildTopBar(Story story) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: CachedNetworkImageProvider(story.userAvatarUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  story.userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _formatTime(story.publishedAt),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Show options menu
              _showOptionsMenu();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 20,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Reply Button
          _buildControlButton(
            icon: Icons.reply,
            onTap: () {
              _showReplyDialog();
            },
          ),
          
          // Like Button
          _buildControlButton(
            icon: Icons.favorite_border,
            onTap: () {
              // Handle like
            },
          ),
          
          // Pause/Play Button
          _buildControlButton(
            icon: _isPaused ? Icons.play_arrow : Icons.pause,
            onTap: _togglePause,
          ),
          
          // Share Button
          _buildControlButton(
            icon: Icons.share,
            onTap: () {
              _shareStory();
            },
          ),
          
          // Save Button
          _buildControlButton(
            icon: Icons.bookmark_border,
            onTap: () {
              // Save story
            },
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
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
              setState(() {
                _isPaused = true;
              });
              _animationController.stop();
            },
            onLongPressEnd: (details) {
              setState(() {
                _isPaused = false;
              });
              _animationController.forward();
            },
          ),
        ),
        
        // Right side tap for next
        Expanded(
          child: GestureDetector(
            onTap: _nextItem,
            onLongPress: () {
              setState(() {
                _isPaused = true;
              });
              _animationController.stop();
            },
            onLongPressEnd: (details) {
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
      right: 8,
      child: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.close, color: Colors.white, size: 24),
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _showOptionsMenu() {
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
                leading: const Icon(Icons.flag, color: Colors.white),
                title: const Text(
                  'Report',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Handle report
                },
              ),
              ListTile(
                leading: const Icon(Icons.block, color: Colors.white),
                title: const Text(
                  'Block User',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Handle block
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications_off, color: Colors.white),
                title: const Text(
                  'Mute Story',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Handle mute
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showReplyDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: const BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'Send Message',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Add quick replies or message input
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[900],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      maxLines: 5,
                      minLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _shareStory() {
    //TODO: Implement sharing functionality
  }
}