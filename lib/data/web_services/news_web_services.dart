import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:newsily/constants/constant_strings.dart';
import 'package:newsily/data/database/business_data.dart';
import 'package:newsily/data/models/news_data_model.dart';

class NewsWebServices {
  static final String _apiKey = dotenv.env['API_KEY']!;
  BusinessData businessData = BusinessData();

  Future<List<Articles>> getResponse(String modelUrl) async {
    try {
      http.Response response = await http.get(
        Uri.parse("$baseUrl$modelUrl$_apiKey"),
      );
      
      if (response.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(response.body);
        
        // Properly escape the JSON string for SQLite
        String escapedJson = jsonEncode(body).replaceAll("'", "''");
        
        // Use parameterized query to prevent SQL injection
        await businessData.insertdata(
          '''
          INSERT INTO buisness_news 
          (response_data, last_updated) 
          VALUES (?, ?)
          ''',
          [escapedJson, DateTime.now().toIso8601String()]
        );

        if (body['articles'] != null) {
          return (body['articles'] as List)
              .map((article) => Articles.fromJson(article))
              .toList();
        }
        return [];
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: ${e.toString()}');
      return [];
    }
  }
}
