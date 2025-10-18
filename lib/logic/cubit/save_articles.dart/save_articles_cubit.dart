import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/data/models/news_data_model.dart';

part 'save_articles_state.dart';

class SaveArticlesCubit extends Cubit<SaveArticlesState> {
  SaveArticlesCubit() : super(SaveArticlesInitial());
  // to morrow I schould solve the problem of using  a list of initial artikles
  getArtikles() {}
  addArticle() {}
}

//schould I do something for solve this problem even I will re stdy the blockkurs
