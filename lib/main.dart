import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:newsily/helper/app_router.dart';
import 'package:newsily/helper/themes.dart';
import 'package:newsily/logic/cubit/save_articles/bookmarks_cubit.dart';
import 'package:newsily/data/repositories/news_data_repository.dart';
import 'package:newsily/data/web_services/news_web_services.dart';
import 'package:newsily/logic/cubit/fetch_data/fetch_cubit.dart';
import 'package:newsily/logic/cubit/story/story_cubit.dart';
import 'package:newsily/logic/cubit/theme/theme_cubit.dart';
import 'package:newsily/logic/cubit/theme/theme_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
        BlocProvider<StoryCubit>(create: (context) => StoryCubit()),
        BlocProvider<BookmarksCubit>(create: (context) => BookmarksCubit()),
        BlocProvider<FetchCubit>(
          create: (context) => FetchCubit(
            NewsDataRepository(newsWebServices: NewsWebServices()),
          ),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeMode) {
          return MaterialApp(
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeMode.mode,
            initialRoute: "home",
            debugShowCheckedModeBanner: false,
            onGenerateRoute: appRoutter.generateRoute,
          );
        },
      ),
    );
  }
}

//project status: Newsily finished
