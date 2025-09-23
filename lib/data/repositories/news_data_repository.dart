import 'dart:convert';

import 'package:newsily/data/models/news_data_model.dart';
import 'package:newsily/data/web_services/news_web_services.dart';

class NewsDataRepository {
  final NewsWebServices newsWebServices;

  NewsDataRepository({required this.newsWebServices});

  Future<List<Articles>> getArticles(String modelUrl) async {
    try {
      final news = await newsWebServices.getResponse(modelUrl);
      print("===========================response================================");
      
      final response = NewsData.fromJson(jsonDecode(news));
      print("$response");
      print("===========================================================");

      print("===========================articles================================");
      
      // Check if articles exist and handle null case
      final articles = response.articles ?? [];
      print("$articles");
      print("===========================================================");

      return articles;
      
    } catch (e) {
      print('Error fetching articles: $e');
      return []; // Return empty list on error
    }
  }
}