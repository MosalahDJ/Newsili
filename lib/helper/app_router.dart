import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/data/repositories/news_data_repository.dart';
import 'package:newsily/data/web_services/news_web_services.dart';
import 'package:newsily/logic/cubit/fetch%20data/fetch_cubit.dart';
import 'package:newsily/presentation/screens/home_page.dart';

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
      // case "sport":
      //   return MaterialPageRoute(
      //     builder: (_) => SportNewsPage(),
      //   );
      // case "detail":
      //   return MaterialPageRoute(
      //     builder: (_) => WorldNewsPage(),
      //   );case "economic":
      //   return MaterialPageRoute(
      //     builder: (_) => EconomicNewsPage(),
      //   );
    }
    return null;
  }
}
