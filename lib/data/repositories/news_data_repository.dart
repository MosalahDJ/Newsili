import 'dart:convert';
import 'package:newsily/constants/constant_Enums.dart';
import 'package:newsily/data/models/news_data_model.dart';
import 'package:newsily/data/web_services/news_web_services.dart';

class NewsDataRepository {
  final NewsWebServices newsWebServices;

  NewsDataRepository({required this.newsWebServices});

  Future handleCases(Enum category) async {
    switch (category) {
      case Category.technology:
        await getArticles("top-headlines?category=technology&apiKey=");
        break;
      case Category.business:
        await getArticles("top-headlines?category=business&apiKey=");
        break;
      case Category.entertainment:
        await getArticles("top-headlines?category=entertainment&apiKey=");
        break;
      case Category.health:
        await getArticles("top-headlines?category=health&apiKey=");
        break;
      case Category.science:
        await getArticles("top-headlines?category=science&apiKey=");
        break;
      case Category.sports:
        await getArticles("top-headlines?category=sports&apiKey=");
        break;
      case Category.general:
        await getArticles("top-headlines?category=sports&apiKey=");
        break;
      default:
        await getArticles("top-headlines?category=general&apiKey=");
    }
  }

  Future<List<Articles>> getArticles(String modelUrl) async {
    try {
      final news = await newsWebServices.getResponse(modelUrl);
      final response = NewsData.fromJson(jsonDecode(news));
      return response.articles ?? [];
    } catch (e) {
      print('Error fetching articles: $e');
      return [];
    }
  }
}
