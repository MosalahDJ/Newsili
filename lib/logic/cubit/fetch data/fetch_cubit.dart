import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/constants/constant_enum.dart';
import 'package:newsily/data/models/news_data_model.dart';
import 'package:newsily/data/repositories/news_data_repository.dart';
import 'package:newsily/logic/cubit/fetch%20data/fetch_state.dart';

class FetchCubit extends Cubit<FetchState> {
  final NewsDataRepository newsDataRepository;
  FetchCubit(this.newsDataRepository) : super(Initialdata());

  getArticles() async {
    try {
      List<Articles> businessNews = await newsDataRepository.handleCases(
        Category.business,
      );
      List<Articles> entertainmentNews = await newsDataRepository.handleCases(
        Category.entertainment,
      );
      List<Articles> generalNews = await newsDataRepository.handleCases(
        Category.general,
      );
      List<Articles> healthNews = await newsDataRepository.handleCases(
        Category.health,
      );
      List<Articles> scienceNews = await newsDataRepository.handleCases(
        Category.science,
      );
      List<Articles> technologyNews = await newsDataRepository.handleCases(
        Category.technology,
      );
      List<Articles> sportsNews = await newsDataRepository.handleCases(
        Category.sports,
      );
      emit(
        DataLoaded(
          businessNews: businessNews,
          entertainmentNews: entertainmentNews,
          generalNews: generalNews,
          healthNews: healthNews,
          scienceNews: scienceNews,
          sportsNews: sportsNews,
          technologyNews: technologyNews,
        ),
      );
    } catch (e) {
      emit(DataError("$e"));
    }
  }

  void performSearch(String query) {
    if (state is! DataLoaded) return;

    final dataState = state as DataLoaded;
    final normalized = query.trim().toLowerCase();

    final results = normalized.isEmpty
        ? const <Articles>[]
        : dataState.allArticles.where((article) {
            final title = article.title?.toLowerCase() ?? '';
            final desc = article.description?.toLowerCase() ?? '';
            final content = article.content?.toLowerCase() ?? '';
            return title.contains(normalized) ||
                desc.contains(normalized) ||
                content.contains(normalized);
          }).toList();

    emit(dataState.copyWith(searchQuery: query, searchResults: results));
  }
}
