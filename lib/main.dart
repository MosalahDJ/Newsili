import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:newsily/helper/app_router.dart';
import 'package:newsily/logic/cubit/fetch%20data/fetch_cubit.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(Newsily(appRoutter: AppRoutter()));
}

class Newsily extends StatelessWidget {
  const Newsily({super.key, required this.appRoutter});

  final AppRoutter appRoutter;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FetchCubit("")),
        BlocProvider(create: (context) => FetchCubit("")),
        BlocProvider(create: (context) => FetchCubit("")),
        BlocProvider(create: (context) => FetchCubit("")),

        // BlocProvider(create: (context) => WorldNewsFetchCubit()),
        // BlocProvider(create: (context) => SportFetchCubit()),
        // BlocProvider(create: (context) => EconomiqueFetchCubit()),
      ],
      child: MaterialApp(
        initialRoute: "home",
        debugShowCheckedModeBanner: false,
        onGenerateRoute: appRoutter.generateRoute,
      ),
    );
  }
}
