import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:newsily/constants/constant_strings.dart';

class NewsWebServices {
  static final String _apiKey = dotenv.env['API_KEY']!;

  Future<Map<String, dynamic>> getAllNews(String modelUrl) async {
    try {
      var request = http.Request('GET', Uri.parse("$baseUrl$modelUrl$_apiKey"));
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        return response.headers;
      } else {
        return {"Error": response.statusCode};
      }
    } catch (e) {
      return {"Error": e.toString()};
    }
  }
}
