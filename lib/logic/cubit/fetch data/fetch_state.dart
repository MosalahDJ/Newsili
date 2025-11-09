import 'package:flutter/material.dart';
import 'package:newsily/data/models/news_data_model.dart';

@immutable
sealed class FetchState {
  const FetchState();
}

final class Initialdata extends FetchState {
  const Initialdata();
}

final class DataLoading extends FetchState {
  const DataLoading();
}

final class DataLoaded extends FetchState {
  final List<Articles>? businessNews;
  final List<Articles>? entertainmentNews;
  final List<Articles>? generalNews;
  final List<Articles>? healthNews;
  final List<Articles>? scienceNews;
  final List<Articles>? sportsNews;
  final List<Articles>? technologyNews;
  final String? searchQuery;
  final List<Articles>? searchResults;
  const DataLoaded( {
    this.businessNews,
    this.entertainmentNews,
    this.generalNews,
    this.healthNews,
    this.scienceNews,
    this.sportsNews,
    this.technologyNews,
    this.searchResults = const <Articles>[],
    this.searchQuery = "",
  });

  List<Articles> get allArticles => [
        ...?businessNews,
        ...?entertainmentNews,
        ...?generalNews,
        ...?healthNews,
        ...?scienceNews,
        ...?sportsNews,
        ...?technologyNews,
      ];
}

final class DataError extends FetchState {
  final String errortext;
  const DataError(this.errortext);
}
