import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/data/models/news_data_model.dart';
import 'package:newsily/data/models/story_converter.dart';
import 'story_state.dart';

abstract class StoryEvent {}

class StoryInitialize extends StoryEvent {
  final List<Articles> articles;
  final int initialArticleIndex;
  final int initialItemIndex;

  StoryInitialize({
    required this.articles,
    required this.initialArticleIndex,
    required this.initialItemIndex,
  });
}

class StoryNextItem extends StoryEvent {}

class StoryPreviousItem extends StoryEvent {}

class StoryNextStory extends StoryEvent {}

class StoryPreviousStory extends StoryEvent {}

class StoryTogglePause extends StoryEvent {}

class StoryToggleSave extends StoryEvent {}

class StoryToggleDescription extends StoryEvent {}

class StoryGoTo extends StoryEvent {
  final int storyIndex;
  final int itemIndex;

  StoryGoTo({required this.storyIndex, required this.itemIndex});
}

class StoryCubit extends Bloc<StoryEvent, StoryState> {
  Timer? _autoAdvanceTimer;
  Duration _currentItemDuration = const Duration(seconds: 5);
  bool _isInitialized = false;

  StoryCubit() : super(const StoryInitial()) {
    on<StoryInitialize>(_onInitialize);
    on<StoryNextItem>(_onNextItem);
    on<StoryPreviousItem>(_onPreviousItem);
    on<StoryNextStory>(_onNextStory);
    on<StoryPreviousStory>(_onPreviousStory);
    on<StoryTogglePause>(_onTogglePause);
    on<StoryToggleSave>(_onToggleSave);
    on<StoryToggleDescription>(_onToggleDescription);
    on<StoryGoTo>(_onGoTo);
  }

  void _onInitialize(StoryInitialize event, Emitter<StoryState> emit) {
    final stories = convertArticlesToStories(event.articles);

    if (stories.isEmpty) {
      emit(StoryError('No stories available'));
      return;
    }

    final clampedStoryIndex = event.initialArticleIndex.clamp(
      0,
      stories.length - 1,
    );
    final clampedItemIndex = event.initialItemIndex.clamp(
      0,
      stories[clampedStoryIndex].items.length - 1,
    );

    _isInitialized = true;
    emit(
      StoryLoaded(
        stories: stories,
        currentStoryIndex: clampedStoryIndex,
        currentItemIndex: clampedItemIndex,
        isPaused: false,
        isSaved: false,
        showFullDescription: false,
        progress: 0.0,
      ),
    );

    _startAutoAdvance(emit);
  }

  void _startAutoAdvance(Emitter<StoryState> emit) {
    if (state is! StoryLoaded) return;
    final loadedState = state as StoryLoaded;
    if (loadedState.isPaused || !_isInitialized) return;

    final currentItem = _getCurrentItem(loadedState);
    _currentItemDuration = currentItem.duration;

    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = Timer.periodic(const Duration(milliseconds: 50), (
      timer,
    ) {
      if (state is! StoryLoaded) {
        timer.cancel();
        return;
      }

      final currentState = state as StoryLoaded;
      final elapsed = timer.tick * 50; // milliseconds
      final progress = elapsed / _currentItemDuration.inMilliseconds;

      if (progress >= 1.0) {
        timer.cancel();
        add(StoryNextItem());
      } else {
        emit(currentState.copyWith(progress: progress));
      }
    });
  }

  StoryItem _getCurrentItem(StoryLoaded state) {
    return state.stories[state.currentStoryIndex].items[state.currentItemIndex];
  }

  void _onNextItem(StoryNextItem event, Emitter<StoryState> emit) {
    if (state is! StoryLoaded) return;
    final loadedState = state as StoryLoaded;

    final currentStory = loadedState.stories[loadedState.currentStoryIndex];

    // Check if we can go to next item in current story
    if (loadedState.currentItemIndex + 1 < currentStory.items.length) {
      emit(
        loadedState.copyWith(
          currentItemIndex: loadedState.currentItemIndex + 1,
          showFullDescription: false,
          progress: 0.0,
        ),
      );
      _startAutoAdvance(emit);
    } else {
      add(StoryNextStory());
    }
  }

  void _onPreviousItem(StoryPreviousItem event, Emitter<StoryState> emit) {
    if (state is! StoryLoaded) return;
    final loadedState = state as StoryLoaded;

    if (loadedState.currentItemIndex - 1 >= 0) {
      emit(
        loadedState.copyWith(
          currentItemIndex: loadedState.currentItemIndex - 1,
          showFullDescription: false,
          progress: 0.0,
        ),
      );
      _startAutoAdvance(emit);
    } else if (loadedState.currentStoryIndex - 1 >= 0) {
      add(StoryPreviousStory());
    }
  }

  void _onNextStory(StoryNextStory event, Emitter<StoryState> emit) {
    if (state is! StoryLoaded) return;
    final loadedState = state as StoryLoaded;

    if (loadedState.currentStoryIndex + 1 < loadedState.stories.length) {
      emit(
        loadedState.copyWith(
          currentStoryIndex: loadedState.currentStoryIndex + 1,
          currentItemIndex: 0,
          showFullDescription: false,
          progress: 0.0,
        ),
      );
      _startAutoAdvance(emit);
    }
  }

  void _onPreviousStory(StoryPreviousStory event, Emitter<StoryState> emit) {
    if (state is! StoryLoaded) return;
    final loadedState = state as StoryLoaded;

    if (loadedState.currentStoryIndex - 1 >= 0) {
      final previousStory =
          loadedState.stories[loadedState.currentStoryIndex - 1];

      emit(
        loadedState.copyWith(
          currentStoryIndex: loadedState.currentStoryIndex - 1,
          currentItemIndex: previousStory.items.length - 1,
          showFullDescription: false,
          progress: 0.0,
        ),
      );
      _startAutoAdvance(emit);
    }
  }

  void _onTogglePause(StoryTogglePause event, Emitter<StoryState> emit) {
    if (state is! StoryLoaded) return;
    final loadedState = state as StoryLoaded;

    final newIsPaused = !loadedState.isPaused;

    if (newIsPaused) {
      _autoAdvanceTimer?.cancel();
      _autoAdvanceTimer = null;
    } else {
      _startAutoAdvance(emit);
    }

    emit(loadedState.copyWith(isPaused: newIsPaused));
  }

  void _onToggleSave(StoryToggleSave event, Emitter<StoryState> emit) {
    if (state is! StoryLoaded) return;
    final loadedState = state as StoryLoaded;

    emit(loadedState.copyWith(isSaved: !loadedState.isSaved));
  }

  void _onToggleDescription(
    StoryToggleDescription event,
    Emitter<StoryState> emit,
  ) {
    if (state is! StoryLoaded) return;
    final loadedState = state as StoryLoaded;

    emit(
      loadedState.copyWith(
        showFullDescription: !loadedState.showFullDescription,
      ),
    );
  }

  void _onGoTo(StoryGoTo event, Emitter<StoryState> emit) {
    if (state is! StoryLoaded) return;
    final loadedState = state as StoryLoaded;

    if (event.storyIndex >= 0 &&
        event.storyIndex < loadedState.stories.length) {
      final targetStory = loadedState.stories[event.storyIndex];
      final clampedItemIndex = event.itemIndex.clamp(
        0,
        targetStory.items.length - 1,
      );

      emit(
        loadedState.copyWith(
          currentStoryIndex: event.storyIndex,
          currentItemIndex: clampedItemIndex,
          showFullDescription: false,
          progress: 0.0,
        ),
      );
      _startAutoAdvance(emit);
    }
  }

  @override
  Future<void> close() {
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = null;
    return super.close();
  }
}
