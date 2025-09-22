import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:newsily/helper/app_router.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(Newsily(appRoutter: AppRoutter()));
}

class Newsily extends StatelessWidget {
  const Newsily({super.key, required this.appRoutter});

  final AppRoutter appRoutter;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "home",
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRoutter.generateRoute,
    );
  }
}
