import 'package:newsily/data/models/news_data_model.dart';
import 'package:newsily/data/web_services/news_web_services.dart';

class NewsDataRepository {
  final NewsWebServices newsWebServices;

  NewsDataRepository({required this.newsWebServices});

  Future<NewsData> getAllNews(String modelUrl) async {
    final news = await newsWebServices.getAllNews(modelUrl);
    return NewsData.fromJson(news);
  }
}
