import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:newsily/constants/constant_strings.dart';
import 'package:newsily/logic/cubit/fetch%20data/fetch_state.dart';

class FetchCubit extends Cubit<FetchState> {
  FetchCubit(this.modelUrl) : super(Initialdata());

  static final String _apiKey = dotenv.env['API_KEY']!;
  final String modelUrl;

  Future<String> fetchData() async {
    try {
      emit(DataLoading());
      final response = await http.get(Uri.parse("$baseUrl$modelUrl$_apiKey"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(DataLoaded(data));
        return "loaded";
      }
      return "${'connection_error'} ${response.statusCode}";
    } catch (e) {
      emit(DataError(e.toString()));
      return "${'connection_error'} ";
    }
  }
}
