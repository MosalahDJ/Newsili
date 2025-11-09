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
  final String searchQuery;
  final List<Articles> searchResults;

  const DataLoaded({
    this.businessNews,
    this.entertainmentNews,
    this.generalNews,
    this.healthNews,
    this.scienceNews,
    this.sportsNews,
    this.technologyNews,
    this.searchQuery = '',
    this.searchResults = const <Articles>[],
  });

  // ✅ 1. Add copyWith — essential for immutability
  DataLoaded copyWith({
    List<Articles>? businessNews,
    List<Articles>? entertainmentNews,
    List<Articles>? generalNews,
    List<Articles>? healthNews,
    List<Articles>? scienceNews,
    List<Articles>? sportsNews,
    List<Articles>? technologyNews,
    String? searchQuery,
    List<Articles>? searchResults,
  }) {
    return DataLoaded(
      businessNews: businessNews ?? this.businessNews,
      entertainmentNews: entertainmentNews ?? this.entertainmentNews,
      generalNews: generalNews ?? this.generalNews,
      healthNews: healthNews ?? this.healthNews,
      scienceNews: scienceNews ?? this.scienceNews,
      sportsNews: sportsNews ?? this.sportsNews,
      technologyNews: technologyNews ?? this.technologyNews,
      searchQuery: searchQuery ?? this.searchQuery,
      searchResults: searchResults ?? this.searchResults,
    );
  }

  // ✅ 2. Override props — ESSENTIAL for Bloc to detect changes
  @override
  List<Object?> get props => [
        businessNews,
        entertainmentNews,
        generalNews,
        healthNews,
        scienceNews,
        sportsNews,
        technologyNews,
        searchQuery,        // 🔥 MUST include these two
        searchResults,      // 🔥
      ];

  // Keep your getter — perfect as-is
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
