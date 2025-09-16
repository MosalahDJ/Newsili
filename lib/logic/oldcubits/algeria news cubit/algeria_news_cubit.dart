// import 'dart:convert';

// import 'package:algeria_news/constants/constant_strings.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;

// part 'algeria_news_state.dart';

// class AlgerianewsCubit extends Cubit<AlgeriaNewsState> {
//   AlgerianewsCubit() : super(AlgeriaNewsInitialdata());

//   static final String _apiKey = dotenv.env['API_KEY']!;
//   static const String _modelUrl = "everything?q=Algeria&apiKey=";

//   Future<String> fetchData() async {
//     try {
//       emit(AlgeriaNewsDataloading());
//       final response = await http.get(Uri.parse("$baseUrl$_modelUrl$_apiKey"));
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         emit(AlgeriaNewsDataLoaded(data));
//       }
//       // emit(DataError("${response.statusCode}"));
//       return "${'connection_error'} ${response.statusCode}";
//     } catch (e) {
//       emit(AlgeriaNewsDataError(e.toString()));
//       return "${'connection_error'} ";
//     }
//   }
// }
