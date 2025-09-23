
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
  final List<Articles>? news;

  const DataLoaded(this.news);
}

final class DataError extends FetchState {
  final String errortext;
  const DataError(this.errortext);
}
