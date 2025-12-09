// story_state.dart
import 'package:equatable/equatable.dart';
import 'package:newsily/data/models/story_converter.dart';

abstract class StoryState extends Equatable {
  const StoryState();

  @override
  List<Object?> get props => [];
}

class StoryInitial extends StoryState {
  const StoryInitial();
}

class StoryLoading extends StoryState {
  const StoryLoading();
}

class StoryLoaded extends StoryState {
  final List<ArticleStory> stories;
  final int currentStoryIndex;
  final int currentItemIndex;
  final bool isPaused;
  final bool isSaved;
  final bool showFullDescription;
  final double progress;
  final String? errorMessage;

  const StoryLoaded({
    required this.stories,
    required this.currentStoryIndex,
    required this.currentItemIndex,
    required this.isPaused,
    required this.isSaved,
    required this.showFullDescription,
    required this.progress,
    this.errorMessage,
  });

  StoryItem get currentItem {
    return stories[currentStoryIndex].items[currentItemIndex];
  }

  ArticleStory get currentStory {
    return stories[currentStoryIndex];
  }

  bool get hasNextItem => currentItemIndex + 1 < currentStory.items.length;
  bool get hasPreviousItem => currentItemIndex - 1 >= 0;
  bool get hasNextStory => currentStoryIndex + 1 < stories.length;
  bool get hasPreviousStory => currentStoryIndex - 1 >= 0;

  StoryLoaded copyWith({
    List<ArticleStory>? stories,
    int? currentStoryIndex,
    int? currentItemIndex,
    bool? isPaused,
    bool? isSaved,
    bool? showFullDescription,
    double? progress,
    String? errorMessage,
  }) {
    return StoryLoaded(
      stories: stories ?? this.stories,
      currentStoryIndex: currentStoryIndex ?? this.currentStoryIndex,
      currentItemIndex: currentItemIndex ?? this.currentItemIndex,
      isPaused: isPaused ?? this.isPaused,
      isSaved: isSaved ?? this.isSaved,
      showFullDescription: showFullDescription ?? this.showFullDescription,
      progress: progress ?? this.progress,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        stories,
        currentStoryIndex,
        currentItemIndex,
        isPaused,
        isSaved,
        showFullDescription,
        progress,
        errorMessage,
      ];
}

class StoryError extends StoryState {
  final String message;
  const StoryError(this.message);

  @override
  List<Object?> get props => [message];
}