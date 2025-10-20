import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/data/database/saved_artikles.dart';
import 'package:newsily/data/models/news_data_model.dart';
import 'package:newsily/logic/cubit/save_articles.dart/bookmarks_state.dart';

class BookmarksCubit extends Cubit<BookmarksState> {
  BookmarksCubit() : super(BookmarksInitial());

  /// Load saved articles (from local DB or memory)
  void loadBookmarks() async {
    emit(BookmarksLoading());
    try {
      // Get the raw data from database
      List<Map<String, dynamic>> rawArticles = await SavedArtikles.instance
          .getAllSavedArticles();

      // Convert the raw data to Articles objects
      List<Articles> articles = rawArticles
          .map(
            (articleMap) => Articles(
              source: Source(name: articleMap['source']),
              title: articleMap['title'],
              description: articleMap['description'],
              url: articleMap['article_id'],
              urlToImage: articleMap['imageUrl'],
              publishedAt: articleMap['publishedAt'],
              content: articleMap['content'],
            ),
          )
          .toList();

      emit(BookmarksLoaded(articles));
    } catch (e) {
      emit(BookmarksError("Failed to load bookmarks: ${e.toString()}"));
    }
  }

  /// Add an article to bookmarks
  void addBookmark(Articles article) async {
    await SavedArtikles.instance.saveArticle(article);
    loadBookmarks(); // Reload bookmarks after adding
  }

  /// Remove an article from bookmarks
  void removeBookmark(Articles article) async {
    await SavedArtikles.instance.removeArticle(article.url!);
    loadBookmarks(); // Reload bookmarks after removing
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
