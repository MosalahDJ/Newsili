import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/data/repositories/news_data_repository.dart';
import 'package:newsily/logic/cubit/fetch%20data/fetch_state.dart';

class FetchCubit extends Cubit<FetchState> {
  final NewsDataRepository newsDataRepository;
  FetchCubit(this.newsDataRepository) : super(Initialdata());

  getArticles(modelUrl) {
    newsDataRepository.getArticles(modelUrl);
  }
}
