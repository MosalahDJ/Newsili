// import 'dart:convert';
// import 'package:algeria_news/constants/constant_strings.dart';
// import 'package:algeria_news/data/database/database_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;
// part 'economic_api_fetch_state.dart';

// class EconomiqueFetchCubit extends Cubit<EconomiqueFetchState> {
//   EconomiqueFetchCubit() : super(EconomiqueInitialdata()) {
//     // Load cached data when cubit is created
//     loadCachedData();
//   }

//   static final String _apiKey = dotenv.env['API_KEY']!;
//   static const String _modelUrl =
//       "everything?q=Economic OR Business OR currency&apiKey=";

//   Future<void> loadCachedData() async {
//     try {
//       final cachedNews = await DatabaseHelper.instance.getNews();
//       if (cachedNews.isNotEmpty) {
//         emit(EconomiqueDataLoaded({'articles': cachedNews}));
//       }
//     } catch (e) {
//       emit(EconomiqueDataError("Failed to load cached data: ${e.toString()}"));
//     }
//   }

//   Future<String> fetchData() async {
//     try {
//       emit(EconomiqueDataloading());
//       final response = await http.get(Uri.parse("$baseUrl$_modelUrl$_apiKey"));

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         // Store the articles in SQLite
//         if (data['articles'] != null) {
//           await DatabaseHelper.instance.insertNews(
//             List<Map<String, dynamic>>.from(data['articles']),
//           );
//         }

//         emit(EconomiqueDataLoaded(data));
//         return "success";
//       }
//       return "connection_error ${response.statusCode}";
//     } catch (e) {
//       emit(EconomiqueDataError(e.toString()));
//       return "connection_error";
//     }
//   }

//   Future<void> clearCache() async {
//     await DatabaseHelper.instance.deleteOldNews();
//   }
// }
