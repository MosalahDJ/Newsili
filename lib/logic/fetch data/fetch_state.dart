
import 'package:flutter/material.dart';

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
  final Map? data;

  const DataLoaded(this.data);
}

final class DataError extends FetchState {
  final String errortext;
  const DataError(this.errortext);
}
