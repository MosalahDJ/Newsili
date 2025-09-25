import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:newsily/constants/constant_strings.dart';
import 'package:newsily/data/database/business_data.dart';

class NewsWebServices {
  static final String _apiKey = dotenv.env['API_KEY']!;
  BusinessData businessData = BusinessData.instance;

  getResponse(String modelUrl) async {
    try {
      http.Response response = await http.get(
        Uri.parse("$baseUrl$modelUrl$_apiKey"),
      );
      if (response.statusCode == 200) {
        Map body = jsonDecode(response.body);
        businessData.insertNews(body["articles"]);
        List<Map> articles = await businessData.getNews();
        print("===================articles========================");
        print(articles);
        print("===================articles========================");

        return articles;
      } else {
        return {"Error": response.statusCode};
      }
    } catch (e) {
      return {"Error": e.toString()};
    }
  }
}
