import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:newsily/constants/constant_strings.dart';
import 'package:newsily/logic/fetch%20data/fetch_state.dart';

class FetchCubit extends Cubit<FetchState> {
  FetchCubit() : super(Initialdata());

  static final String _apiKey = dotenv.env['API_KEY']!;
  static const String _modelUrl = "everything?q=soccer OR football&apiKey=";

  Future<String> fetchData() async {
    try {
      emit(DataLoading());
      print("loading");
      final response = await http.get(Uri.parse("$baseUrl$_modelUrl$_apiKey"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data.toString());
        emit(DataLoaded(data));
        return "loaded";
      }
      print("error");
      return "${'connection_error'} ${response.statusCode}";
    } catch (e) {
      emit(DataError(e.toString()));
      return "${'connection_error'} ";
    }
  }
}
