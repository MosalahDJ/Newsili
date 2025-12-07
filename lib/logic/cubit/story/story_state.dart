import 'package:newsily/data/models/story_converter.dart';

abstract class StoryState {
  const StoryState();
}

class StoryInitial extends StoryState {
  const StoryInitial();
}

class StoryLoaded extends StoryState {
  final List<ArticleStory> stories;
  final int currentStoryIndex;
  final int currentItemIndex;
  final bool isPaused;
  final bool isSaved;
  final bool showFullDescription;
  final double progress; // Add progress value (0.0 to 1.0)

  const StoryLoaded({
    required this.stories,
    required this.currentStoryIndex,
    required this.currentItemIndex,
    required this.isPaused,
    required this.isSaved,
    required this.showFullDescription,
    required this.progress,
  });

  StoryLoaded copyWith({
    List<ArticleStory>? stories,
    int? currentStoryIndex,
    int? currentItemIndex,
    bool? isPaused,
    bool? isSaved,
    bool? showFullDescription,
    double? progress,
  }) {
    return StoryLoaded(
      stories: stories ?? this.stories,
      currentStoryIndex: currentStoryIndex ?? this.currentStoryIndex,
      currentItemIndex: currentItemIndex ?? this.currentItemIndex,
      isPaused: isPaused ?? this.isPaused,
      isSaved: isSaved ?? this.isSaved,
      showFullDescription: showFullDescription ?? this.showFullDescription,
      progress: progress ?? this.progress,
    );
  }
}

class StoryError extends StoryState {
  final String message;
  const StoryError(this.message);
}
