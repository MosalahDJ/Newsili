import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/data/models/news_data_model.dart';
import 'package:newsily/logic/cubit/save_articles.dart/save_articles_state.dart';

class BookmarksCubit extends Cubit<BookmarksState> {
  BookmarksCubit() : super(BookmarksInitial());

  final List<Articles> _savedArticles = [];

  /// Load saved articles (from local DB or memory)
  void loadBookmarks() async {
    emit(BookmarksLoading());

    try {
      // TODO: Load from local storage (Hive, SharedPreferences, etc.)
      await Future.delayed(const Duration(milliseconds: 300));
      emit(BookmarksLoaded(List.from(_savedArticles)));
    } catch (e) {
      emit(BookmarksError("Failed to load bookmarks"));
    }
  }

  /// Add an article to bookmarks
  void addBookmark(Articles article) {
    if (!_savedArticles.contains(article)) {
      _savedArticles.add(article);
      emit(BookmarksLoaded(List.from(_savedArticles)));
    }
  }

  /// Remove an article from bookmarks
  void removeBookmark(Articles article) {
    _savedArticles.removeWhere((a) => a.url == article.url);
    emit(BookmarksLoaded(List.from(_savedArticles)));
  }

  /// Check if an article is saved
  bool isBookmarked(Articles article) {
    return _savedArticles.any((a) => a.url == article.url);
  }

  /// Clear all bookmarks
  void clearBookmarks() {
    _savedArticles.clear();
    emit(BookmarksLoaded([]));
  }
}
