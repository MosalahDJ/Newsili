// import 'dart:convert';

// import 'package:algeria_news/constants/constant_strings.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;

// part 'world_news_api_fetch_state.dart';

// class WorldNewsFetchCubit extends Cubit<WorldNewsFetchState> {
//   WorldNewsFetchCubit() : super(WorldNewsInitialdata());

//   static final String _apiKey = dotenv.env['API_KEY']!;
//   static const String _modelUrl =
//       "everything?q=a OR b OR c OR d OR e OR f OR g OR h OR i OR j OR k OR l OR m OR n OR o OR p OR q OR r OR s OR t OR u OR v OR w OR x OR y OR z&apiKey=";

//   Future<String> fetchData() async {
//     try {
//       emit(WorldNewsDataloading());
//       final response = await http.get(Uri.parse("$baseUrl$_modelUrl$_apiKey"));
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         emit(WorldNewsDataLoaded(data));
//       }
//       // emit(DataError("${response.statusCode}"));
//       return "${'connection_error'} ${response.statusCode}";
//     } catch (e) {
//       emit(WorldNewsDataError(e.toString()));
//       return "${'connection_error'} ";
//     }
//   }
// }
