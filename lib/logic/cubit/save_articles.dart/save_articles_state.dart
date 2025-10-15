part of 'save_articles_cubit.dart';

@immutable
sealed class SaveArticlesState {
  const SaveArticlesState();
}

final class SaveArticlesInitial extends SaveArticlesState {
  const SaveArticlesInitial();
}

final class SaveArticlesloading extends SaveArticlesState {
  const SaveArticlesloading();
}

final class SaveArticlesLoaded extends SaveArticlesState {
  final List<Articles>? savedArticles;
  const SaveArticlesLoaded({this.savedArticles});
}

final class SaveArticlesError extends SaveArticlesState {
  final String? errorText;
  const SaveArticlesError({this.errorText});
}
