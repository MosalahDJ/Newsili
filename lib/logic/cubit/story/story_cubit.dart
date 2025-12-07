// story_cubit.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/data/models/news_data_model.dart';
import 'package:newsily/data/models/story_converter.dart';
import 'story_state.dart';

class StoryCubit extends Cubit<StoryState> {
  StoryCubit({
    required List<Articles> articles,
    required int initialArticleIndex,
    required int initialItemIndex,
  }) : super(const StoryInitial()) {
    _initialize(articles, initialArticleIndex, initialItemIndex);
  }

  Timer? _autoAdvanceTimer;
  Duration? _currentItemDuration;

  void _initialize(
    List<Articles> articles,
    int initialArticleIndex,
    int initialItemIndex,
  ) {
    final stories = convertArticlesToStories(articles);
    
    if (stories.isEmpty) {
      emit(StoryError('No stories available'));
      return;
    }

    final clampedStoryIndex = initialArticleIndex.clamp(0, stories.length - 1);
    final clampedItemIndex = initialItemIndex.clamp(
      0,
      stories[clampedStoryIndex].items.length - 1,
    );

    emit(StoryLoaded(
      stories: stories,
      currentStoryIndex: clampedStoryIndex,
      currentItemIndex: clampedItemIndex,
      isPaused: false,
      isSaved: false,
      showFullDescription: false,
    ));

    _startAutoAdvance();
  }

  void _startAutoAdvance() {
    if (state is! StoryLoaded) return;
    final loadedState = state as StoryLoaded;
    if (loadedState.isPaused) return;

    final currentItem = _getCurrentItem(loadedState);
    _currentItemDuration = currentItem.duration;
    
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = Timer(_currentItemDuration!, () {
      nextItem();
    });
  }

  void _pauseAutoAdvance() {
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = null;
  }

  StoryItem _getCurrentItem(StoryLoaded state) {
    return state.stories[state.currentStoryIndex].items[state.currentItemIndex];
  }

  Articles _getCurrentArticle(StoryLoaded state) {
    return state.stories[state.currentStoryIndex].article;
  }

  void togglePause() {
    if (state is! StoryLoaded) return;
    final loadedState = state as StoryLoaded;

    final newIsPaused = !loadedState.isPaused;
    
    if (newIsPaused) {
      _pauseAutoAdvance();
    } else {
      _startAutoAdvance();
    }

    emit(loadedState.copyWith(isPaused: newIsPaused));
  }

  void toggleSave() {
    if (state is! StoryLoaded) return;
    final loadedState = state as StoryLoaded;
    
    emit(loadedState.copyWith(isSaved: !loadedState.isSaved));
  }

  void toggleDescription() {
    if (state is! StoryLoaded) return;
    final loadedState = state as StoryLoaded;
    
    emit(loadedState.copyWith(
      showFullDescription: !loadedState.showFullDescription,
    ));
  }

  void nextItem() {
    if (state is! StoryLoaded) return;
    final loadedState = state as StoryLoaded;
    
    final currentStory = loadedState.stories[loadedState.currentStoryIndex];

    // Check if we can go to next item in current story
    if (loadedState.currentItemIndex + 1 < currentStory.items.length) {
      emit(loadedState.copyWith(
        currentItemIndex: loadedState.currentItemIndex + 1,
        showFullDescription: false,
      ));
      _startAutoAdvance();
    } else {
      nextStory();
    }
  }

  void previousItem() {
    if (state is! StoryLoaded) return;
    final loadedState = state as StoryLoaded;
    
    if (loadedState.currentItemIndex - 1 >= 0) {
      emit(loadedState.copyWith(
        currentItemIndex: loadedState.currentItemIndex - 1,
        showFullDescription: false,
      ));
      _startAutoAdvance();
    } else if (loadedState.currentStoryIndex - 1 >= 0) {
      previousStory();
    }
  }

  void nextStory() {
    if (state is! StoryLoaded) return;
    final loadedState = state as StoryLoaded;
    
    if (loadedState.currentStoryIndex + 1 < loadedState.stories.length) {
      emit(loadedState.copyWith(
        currentStoryIndex: loadedState.currentStoryIndex + 1,
        currentItemIndex: 0,
        showFullDescription: false,
      ));
      _startAutoAdvance();
    }
    // Last story completed - UI will handle exit
  }

  void previousStory() {
    if (state is! StoryLoaded) return;
    final loadedState = state as StoryLoaded;
    
    if (loadedState.currentStoryIndex - 1 >= 0) {
      final previousStory = loadedState.stories[loadedState.currentStoryIndex - 1];
      
      emit(loadedState.copyWith(
        currentStoryIndex: loadedState.currentStoryIndex - 1,
        currentItemIndex: previousStory.items.length - 1,
        showFullDescription: false,
      ));
      _startAutoAdvance();
    }
  }

  void goToStory(int storyIndex, int itemIndex) {
    if (state is! StoryLoaded) return;
    final loadedState = state as StoryLoaded;
    
    if (storyIndex >= 0 && storyIndex < loadedState.stories.length) {
      final targetStory = loadedState.stories[storyIndex];
      final clampedItemIndex = itemIndex.clamp(0, targetStory.items.length - 1);
      
      emit(loadedState.copyWith(
        currentStoryIndex: storyIndex,
        currentItemIndex: clampedItemIndex,
        showFullDescription: false,
      ));
      _startAutoAdvance();
    }
  }

  @override
  Future<void> close() {
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = null;
    return super.close();
  }
}