import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:newsily/constants/constant_strings.dart';

class NewsWebServices {
  static final String _apiKey = dotenv.env['API_KEY']!;

  getResponse(String modelUrl) async {
    try {
      http.Response response =await http.get(Uri.parse("$baseUrl$modelUrl$_apiKey"));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return {"Error": response.statusCode};
      }
    } catch (e) {
      return {"Error": e.toString()};
    }
  }
}
