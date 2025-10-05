import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:newsily/constants/constant_enum.dart';
import 'package:newsily/constants/constant_strings.dart';
import 'package:newsily/data/database/business_data.dart';
import 'package:newsily/data/database/entertainment_data.dart';
import 'package:newsily/data/database/general_data.dart';
import 'package:newsily/data/database/health_data.dart';
import 'package:newsily/data/database/science_data.dart';
import 'package:newsily/data/database/sports_data.dart';
import 'package:newsily/data/database/technology_data.dart';
import 'package:newsily/data/models/news_data_model.dart';

class NewsWebServices {
  static final String _apiKey = dotenv.env['API_KEY']!;
  BusinessData businessData = BusinessData();
  EntertainmentData entertainmentData = EntertainmentData();
  GeneralData generalData = GeneralData();
  HealthData healthData = HealthData();
  ScienceData scienceData = ScienceData();
  SportsData sportsData = SportsData();
  TechnologyData technologyData = TechnologyData();

  Future<List<Articles>> getResponse(String modelUrl, Enum category) async {
    // ignore: prefer_typing_uninitialized_variables
    var database;
    String? tableName;

    switch (category) {
      case Category.technology:
        database = technologyData;
        tableName = 'technology_news';
      case Category.business:
        database = businessData;
        tableName = 'buisness_news';
      case Category.entertainment:
        database = entertainmentData;
        tableName = 'entertainment_news';
      case Category.health:
        database = healthData;
        tableName = 'health_news';
      case Category.science:
        database = scienceData;
        tableName = 'science_news';
      case Category.sports:
        database = sportsData;
        tableName = 'sports_news';
      case Category.general:
        database = generalData;
        tableName = 'general_news';
    }
    try {
      http.Response response = await http.get(
        Uri.parse("$baseUrl$modelUrl$_apiKey"),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(response.body);

        // Properly escape the JSON string for SQLite
        String escapedJson = jsonEncode(body).replaceAll("'", "''");

        // Use parameterized query to prevent SQL injection
        await database.insertdata(
          '''
          INSERT INTO $tableName
          (response_data, last_updated) 
          VALUES (?, ?)
          ''',
          [escapedJson, DateTime.now().toIso8601String()],
        );

        if (body['articles'] != null) {
          return (body['articles'] as List)
              .map((article) => Articles.fromJson(article))
              .toList();
        }
        return [];
      } else {
        // print('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      // print('Error: ${e.toString()}');
      return [];
    }
  }
}
