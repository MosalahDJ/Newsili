import 'dart:convert';

import 'package:newsily/data/models/news_data_model.dart';
import 'package:newsily/data/web_services/news_web_services.dart';

class NewsDataRepository {
  final NewsWebServices newsWebServices;

  NewsDataRepository({required this.newsWebServices});

  Future<List<Articles>> getArticles(String modelUrl) async {
    try {
      final news = await newsWebServices.getResponse(modelUrl);
      final response = NewsData.fromJson(jsonDecode(news));
      final articles = response.articles ?? [];
      
      // Option 1: Get the last article as a Map
      Map<String, dynamic>? jsonMap;
      for (var article in articles) {
        jsonMap = article.toJson(); // This is already a Map
      }

      print("Last article as Map: $jsonMap");
      
      // Option 2: Get all articles as a List of Maps
      List<Map<String, dynamic>> allArticlesAsMap = [];
      for (var article in articles) {
        allArticlesAsMap.add(article.toJson());
      }
      
      // Option 3: Using map() function (more concise)
      List<Map<String, dynamic>> allArticlesMaps = articles
          .map((article) => article.toJson())
          .toList();

      print("Total articles: ${articles.length}");
      print("First article map: ${allArticlesMaps.isNotEmpty ? allArticlesMaps.first : 'No articles'}");
      
      return articles;
    } catch (e) {
      print('Error fetching articles: $e');
      return []; // Return empty list on error
    }
  }
}