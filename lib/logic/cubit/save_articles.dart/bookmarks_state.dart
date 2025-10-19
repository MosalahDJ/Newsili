import 'package:newsily/data/models/news_data_model.dart';

abstract class BookmarksState {
  const BookmarksState();

  List<Object?> get props => [];
}

class BookmarksInitial extends BookmarksState {}

class BookmarksLoading extends BookmarksState {}

class BookmarksLoaded extends BookmarksState {
  final List<Articles> savedArticles;

  const BookmarksLoaded(this.savedArticles);

  @override
  List<Object?> get props => [savedArticles];
}

class BookmarksError extends BookmarksState {
  final String message;

  const BookmarksError(this.message);

  @override
  List<Object?> get props => [message];
}
