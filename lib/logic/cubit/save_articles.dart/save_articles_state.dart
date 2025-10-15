part of 'save_articles_cubit.dart';

@immutable
sealed class SaveArticlesState {}



final class SaveArticlesInitial extends SaveArticlesState {
  final List<Articles> savedArticles = [];
}
