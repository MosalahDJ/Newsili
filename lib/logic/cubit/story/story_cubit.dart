// story_cubit.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/data/models/news_data_model.dart';
import 'package:newsily/data/models/story_converter.dart';
import 'story_state.dart';

class StoryCubit extends Cubit<StoryState> {
  Timer? _autoAdvanceTimer;
  Duration _currentItemDuration = const Duration(seconds: 5);
  bool _isInitialized = false;
  Timer? _progressTimer;

  StoryCubit() : super(const StoryInitial());

  // INITIALIZATION
  void initialize({
    required List<Articles> articles,
    int initialArticleIndex = 0,
    int initialItemIndex = 0,
  }) {
    try {
      final stories = convertArticlesToStories(articles);

      if (stories.isEmpty) {
        emit(StoryError('No stories available'));
        return;
      }

      final clampedStoryIndex = initialArticleIndex.clamp(
        0,
        stories.length - 1,
      );
      final clampedItemIndex = initialItemIndex.clamp(
        0,
        stories[clampedStoryIndex].items.length - 1,
      );

      _isInitialized = true;

      final newState = StoryLoaded(
        stories: stories,
        currentStoryIndex: clampedStoryIndex,
        currentItemIndex: clampedItemIndex,
        isPaused: false,
        isSaved: false,
        showFullDescription: false,
        progress: 0.0,
      );

      emit(newState);
      _startAutoAdvance(newState);
    } catch (e) {
      emit(StoryError('Failed to initialize stories: ${e.toString()}'));
    }
  }

  // ========== NAVIGATION METHODS ==========

  void nextItem() {
    final currentState = state;
    if (currentState is! StoryLoaded) return;

    if (currentState.hasNextItem) {
      // Go to next item in current story
      final newState = currentState.copyWith(
        currentItemIndex: currentState.currentItemIndex + 1,
        showFullDescription: false,
        progress: 0.0,
      );
      emit(newState);
      _startAutoAdvance(newState);
    } else {
      // Go to next story
      nextStory();
    }
  }

  void previousItem() {
    final currentState = state;
    if (currentState is! StoryLoaded) return;

    if (currentState.hasPreviousItem) {
      // Go to previous item in current story
      final newState = currentState.copyWith(
        currentItemIndex: currentState.currentItemIndex - 1,
        showFullDescription: false,
        progress: 0.0,
      );
      emit(newState);
      _startAutoAdvance(newState);
    } else if (currentState.hasPreviousStory) {
      // Go to previous story, last item
      final previousStory =
          currentState.stories[currentState.currentStoryIndex - 1];
      final newState = currentState.copyWith(
        currentStoryIndex: currentState.currentStoryIndex - 1,
        currentItemIndex: previousStory.items.length - 1,
        showFullDescription: false,
        progress: 0.0,
      );
      emit(newState);
      _startAutoAdvance(newState);
    }
  }

  void nextStory() {
    final currentState = state;
    if (currentState is! StoryLoaded) return;

    if (currentState.hasNextStory) {
      final newState = currentState.copyWith(
        currentStoryIndex: currentState.currentStoryIndex + 1,
        currentItemIndex: 0,
        showFullDescription: false,
        progress: 0.0,
      );
      emit(newState);
      _startAutoAdvance(newState);
    }
  }

  void previousStory() {
    final currentState = state;
    if (currentState is! StoryLoaded) return;

    if (currentState.hasPreviousStory) {
      final previousStory =
          currentState.stories[currentState.currentStoryIndex - 1];
      final newState = currentState.copyWith(
        currentStoryIndex: currentState.currentStoryIndex - 1,
        currentItemIndex: previousStory.items.length - 1,
        showFullDescription: false,
        progress: 0.0,
      );
      emit(newState);
      _startAutoAdvance(newState);
    }
  }

  void goTo(int storyIndex, int itemIndex) {
    final currentState = state;
    if (currentState is! StoryLoaded) return;

    // Don't do anything if we're already at this position
    if (currentState.currentStoryIndex == storyIndex &&
        currentState.currentItemIndex == itemIndex) {
      return;
    }

    if (storyIndex >= 0 && storyIndex < currentState.stories.length) {
      final targetStory = currentState.stories[storyIndex];
      final clampedItemIndex = itemIndex.clamp(0, targetStory.items.length - 1);

      final newState = currentState.copyWith(
        currentStoryIndex: storyIndex,
        currentItemIndex: clampedItemIndex,
        showFullDescription: false,
        progress: 0.0,
      );
      emit(newState);
      _startAutoAdvance(newState);
    }
  }

  void jumpToStory(int storyIndex) {
    goTo(storyIndex, 0);
  }

  // ========== CONTROL METHODS ==========

  void togglePause() {
    final currentState = state;
    if (currentState is! StoryLoaded) return;

    final newIsPaused = !currentState.isPaused;

    if (newIsPaused) {
      _stopAutoAdvance();
      _stopProgressTimer();
    } else {
      _startAutoAdvance(currentState);
    }

    emit(currentState.copyWith(isPaused: newIsPaused));
  }

  void pause() {
    final currentState = state;
    if (currentState is! StoryLoaded || currentState.isPaused) return;

    _stopAutoAdvance();
    _stopProgressTimer();
    emit(currentState.copyWith(isPaused: true));
  }

  void resume() {
    final currentState = state;
    if (currentState is! StoryLoaded || !currentState.isPaused) return;

    _startAutoAdvance(currentState);
    emit(currentState.copyWith(isPaused: false));
  }

  void toggleSave() {
    final currentState = state;
    if (currentState is! StoryLoaded) return;

    emit(currentState.copyWith(isSaved: !currentState.isSaved));
  }

  void toggleDescription() {
    final currentState = state;
    if (currentState is! StoryLoaded) return;

    emit(
      currentState.copyWith(
        showFullDescription: !currentState.showFullDescription,
      ),
    );
  }

  void showFullDescription() {
    final currentState = state;
    if (currentState is! StoryLoaded || currentState.showFullDescription) {
      return;
    }

    emit(currentState.copyWith(showFullDescription: true));
  }

  void hideFullDescription() {
    final currentState = state;
    if (currentState is! StoryLoaded || !currentState.showFullDescription) {
      return;
    }

    emit(currentState.copyWith(showFullDescription: false));
  }

  // ========== AUTO ADVANCE & PROGRESS ==========

  void _startAutoAdvance(StoryLoaded state) {
    if (state.isPaused || !_isInitialized) return;

    final currentItem = state.currentItem;
    _currentItemDuration = currentItem.duration;

    _stopAutoAdvance();
    _stopProgressTimer();

    // Start progress timer
    _progressTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      final currentState = this.state;
      if (currentState is! StoryLoaded) {
        timer.cancel();
        return;
      }

      final elapsed = timer.tick * 50; // milliseconds
      final progress = elapsed / _currentItemDuration.inMilliseconds;

      if (progress >= 1.0) {
        timer.cancel();
        nextItem();
      } else {
        emit(currentState.copyWith(progress: progress));
      }
    });

    // Start auto advance timer
    _autoAdvanceTimer = Timer(_currentItemDuration, () {
      nextItem();
    });
  }

  void _stopAutoAdvance() {
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = null;
  }

  void _stopProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer = null;
  }

  void resetProgress() {
    final currentState = state;
    if (currentState is! StoryLoaded) return;

    emit(currentState.copyWith(progress: 0.0));
    _stopAutoAdvance();
    _stopProgressTimer();
    _startAutoAdvance(currentState);
  }

  void setProgress(double progress) {
    final currentState = state;
    if (currentState is! StoryLoaded) return;

    final clampedProgress = progress.clamp(0.0, 1.0);
    emit(currentState.copyWith(progress: clampedProgress));
  }

  // ========== HELPER METHODS ==========

  bool get isPlaying {
    final currentState = state;
    return currentState is StoryLoaded && !currentState.isPaused;
  }

  bool get isLastItem {
    final currentState = state;
    if (currentState is! StoryLoaded) return false;

    return !currentState.hasNextItem && !currentState.hasNextStory;
  }

  bool get isFirstItem {
    final currentState = state;
    if (currentState is! StoryLoaded) return false;

    return currentState.currentItemIndex == 0 &&
        currentState.currentStoryIndex == 0;
  }

  void updateStories(List<Articles> articles) {
    final currentState = state;
    if (currentState is StoryLoaded) {
      final newStories = convertArticlesToStories(articles);

      // Try to preserve current position
      int newStoryIndex = 0;
      int newItemIndex = 0;

      if (currentState.currentStory.article.url != null) {
        for (int i = 0; i < newStories.length; i++) {
          if (newStories[i].article.url ==
              currentState.currentStory.article.url) {
            newStoryIndex = i;
            // Try to find the same item
            final currentItemId = currentState.currentItem.id;
            for (int j = 0; j < newStories[i].items.length; j++) {
              if (newStories[i].items[j].id == currentItemId) {
                newItemIndex = j;
                break;
              }
            }
            break;
          }
        }
      }

      final newState = currentState.copyWith(
        stories: newStories,
        currentStoryIndex: newStoryIndex,
        currentItemIndex: newItemIndex,
        progress: 0.0,
      );

      emit(newState);
      _startAutoAdvance(newState);
    } else {
      initialize(articles: articles);
    }
  }

  // DISPOSE

  @override
  Future<void> close() {
    _stopAutoAdvance();
    _stopProgressTimer();
    return super.close();
  }
}
