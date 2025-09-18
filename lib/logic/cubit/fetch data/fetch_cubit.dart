import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:newsily/constants/constant_strings.dart';
import 'package:newsily/data/database/business_data.dart';
import 'package:newsily/logic/cubit/fetch%20data/fetch_state.dart';

class FetchCubit extends Cubit<FetchState> {
  FetchCubit() : super(Initialdata()) {
    // Load cached data when cubit is created
    loadCachedData();
  }

  static final String _apiKey = dotenv.env['API_KEY']!;

  Future<void> loadCachedData() async {
    try {
      final cachedNews = await BusinessData.instance.getNews();
      if (cachedNews.isNotEmpty) {
        emit(DataLoaded({'articles': cachedNews}));
      }
    } catch (e) {
      emit(DataError("Failed to load cached data: ${e.toString()}"));
    }
  }

  Future<String> fetchData(String modelUrl, String category) async {
    try {
      emit(DataLoading());
      final response = await http.get(Uri.parse("$baseUrl$modelUrl$_apiKey"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Store the articles in SQLite
        if (data['articles'] != null) {
          await BusinessData.instance.insertNews(
            List<Map<String, dynamic>>.from(data['articles']),
          );
        }

        emit(DataLoaded(data));
        return "success";
      }
      return "connection_error ${response.statusCode}";
    } catch (e) {
      emit(DataError(e.toString()));
      return "connection_error";
    }
  }

  Future<void> clearCache() async {
    await BusinessData.instance.deleteOldNews();
  }
}
