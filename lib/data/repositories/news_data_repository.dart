import 'package:newsily/constants/constant_enum.dart';
import 'package:newsily/data/models/news_data_model.dart';
import 'package:newsily/data/web_services/news_web_services.dart';

class NewsDataRepository {
  final NewsWebServices newsWebServices;
  NewsDataRepository({required this.newsWebServices});

  // tommorow schould I make some changes inside thise file for stor data inside
  //databse after getting it from the server and you waht else schould you do ma
  //fuck you

  Future handleCases(Enum category) async {
    switch (category) {
      case Category.technology:
        return await getArticles("top-headlines?category=technology&apiKey=");
      case Category.business:
        return await getArticles("top-headlines?category=business&apiKey=");

      case Category.entertainment:
        return await getArticles(
          "top-headlines?category=entertainment&apiKey=",
        );

      case Category.health:
        return await getArticles("top-headlines?category=health&apiKey=");

      case Category.science:
        return await getArticles("top-headlines?category=science&apiKey=");

      case Category.sports:
        return await getArticles("top-headlines?category=sports&apiKey=");

      case Category.general:
        return await getArticles("top-headlines?category=general&apiKey=");
    }
  }

  Future<List<Articles>> getArticles(String modelUrl) async {
    try {
      final articles = await newsWebServices.getResponse(modelUrl);
      // final response = NewsData.fromJson();
      print("=========================================");
      // print(response.articles);
      return articles ;
    } catch (e) {
      print('Error fetching articles: $e');
      return [];
    }
  }
}
