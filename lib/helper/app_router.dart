import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/data/models/news_data_model.dart';
import 'package:newsily/data/repositories/news_data_repository.dart';
import 'package:newsily/data/web_services/news_web_services.dart';
import 'package:newsily/logic/cubit/fetch%20data/fetch_cubit.dart';
import 'package:newsily/presentation/screens/home_page.dart';
import 'package:newsily/presentation/widgets/article_description.dart';
import 'package:newsily/presentation/screens/category_page.dart';
import 'package:newsily/presentation/screens/categories.dart';

class AppRoutter {
  late NewsDataRepository newsDataRepository;
  late NewsWebServices newsWebServices = NewsWebServices();

  Route? generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case "home":
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => FetchCubit(
              NewsDataRepository(newsWebServices: newsWebServices),
            ),
            child: HomePage(),
          ),
        );
      case "categories":
        return MaterialPageRoute(builder: (_) => Categories());
      case "category":
        final args = setting.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => CategoryPage(
            category: args["category"],
            articles: args["articles"],
            categoryIndex: 0, // you can pass an index if needed
          ),
        );

      case "article":
        final article = setting.arguments as Articles;
        return MaterialPageRoute(
          builder: (_) => ArticleDescriptionPage(article: article),
        );
    }
    return null;
  }
}
