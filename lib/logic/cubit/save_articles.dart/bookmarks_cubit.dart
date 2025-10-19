import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/data/database/saved_artikles.dart';
import 'package:newsily/data/models/news_data_model.dart';
import 'package:newsily/logic/cubit/save_articles.dart/bookmarks_state.dart';

class BookmarksCubit extends Cubit<BookmarksState> {
  BookmarksCubit() : super(BookmarksInitial());

  /// Load saved articles (from local DB or memory)
  void loadBookmarks() async {
    emit(BookmarksLoading());
    //TODO: schould I fix the problem hier  I must have a list of Articles
    try {
      List<Articles> articles = await SavedArtikles.instance
          .getAllSavedArticles();
      emit(BookmarksLoaded());
    } catch (e) {
      emit(BookmarksError("Failed to load bookmarks"));
    }
  }

  /// Add an article to bookmarks
  void addBookmark(Articles article) {
    SavedArtikles.instance.saveArticle(article);
    emit(BookmarksLoaded([]));
  }

  /// Remove an article from bookmarks
  void removeBookmark(Articles article) {
    SavedArtikles.instance.removeArticle(article.url!);
    emit(BookmarksLoaded([]));
  }

  /// Check if an article is saved
  Future<bool> isBookmarked(Articles article) async {
    return await SavedArtikles.instance.isArticleSaved(article.url!);
  }

  /// Clear all bookmarks
  void clearBookmarks() {
    emit(BookmarksLoaded([]));
  }
}

// tomorrow schould I use this cubit in the interface
