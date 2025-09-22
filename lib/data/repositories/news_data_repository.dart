import 'dart:convert';

import 'package:newsily/data/models/news_data_model.dart';
import 'package:newsily/data/web_services/news_web_services.dart';

// TODO: I haave an Error hier;
class NewsDataRepository {
  final NewsWebServices newsWebServices;

  NewsDataRepository({required this.newsWebServices});
  late NewsData response;
  late List<Articles> articles;
  Future<List<Articles>> getArticles(String modelUrl) async {
    final news = await newsWebServices.getResponse(modelUrl);
    response = NewsData.fromJson(jsonDecode(news));
    articles = response.articles!.toList();
    return articles;
  }
}
