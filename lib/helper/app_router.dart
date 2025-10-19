import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/data/models/news_data_model.dart';
import 'package:newsily/data/repositories/news_data_repository.dart';
import 'package:newsily/data/web_services/news_web_services.dart';
import 'package:newsily/logic/cubit/fetch%20data/fetch_cubit.dart';
import 'package:newsily/logic/cubit/save_articles.dart/bookmarks_cubit.dart';
import 'package:newsily/presentation/main_page.dart';
import 'package:newsily/presentation/screens/article_description.dart';
import 'package:newsily/presentation/screens/categorypage.dart';

class AppRoutter {
  late NewsDataRepository newsDataRepository;
  late NewsWebServices newsWebServices = NewsWebServices();

  Route? generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case "home":
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => FetchCubit(
              NewsDataRepository(newsWebServices: newsWebServices),
            ),),
            BlocProvider(create: (context) => BookmarksCubit(),)
            ],
            child: MainPage(),
          ),
        );
      case "categories":
        return MaterialPageRoute(builder: (_) => CategoryPage());
      // case "category":
      //   final args = setting.arguments as Map;
      //   return MaterialPageRoute(
      //     builder: (_) => Categoryposts(
      //       category: args["category"],
      //       articles: args["articles"],
      //       categoryIndex: 0, // you can pass an index if needed
      //     ),
      //   );

      case "/article":
        final article = setting.arguments as Articles;
        return MaterialPageRoute(
          builder: (_) => ArticleDescriptionPage(article: article),
        );
    }
    return null;
  }
}
