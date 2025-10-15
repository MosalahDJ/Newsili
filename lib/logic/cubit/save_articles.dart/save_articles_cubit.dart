import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:newsily/data/models/news_data_model.dart';

part 'save_articles_state.dart';

class SaveArticlesCubit extends Cubit<SaveArticlesState> {
  SaveArticlesCubit() : super(SaveArticlesInitial());
  addArticle(){
    
  }
}
