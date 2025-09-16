// import 'dart:convert';
// import 'package:algeria_news/constants/constant_strings.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;

// part 'sport_api_fetch_state.dart';

// class SportFetchCubit extends Cubit<SportFetchState> {
//   SportFetchCubit() : super(SportInitialdata());

//   static final String _apiKey = dotenv.env['API_KEY']!;
//   static const String _modelUrl =
//       "everything?q=soccer OR sport OR football&apiKey=";

//   Future<String> fetchData() async {
//     try {
//       emit(SportDataloading());
//       final response = await http.get(Uri.parse("$baseUrl$_modelUrl$_apiKey"));
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         emit(SportDataLoaded(data));
//       }
//       return "${'connection_error'} ${response.statusCode}";
//     } catch (e) {
//       emit(SportDataError(e.toString()));
//       return "${'connection_error'} ";
//     }
//   }
// }
