import 'package:flutter/material.dart';
import 'package:newsily/presentation/screens/home_page.dart';

class AppRoutter {
  Route? generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case "home":
        return MaterialPageRoute(builder: (_) => HomePage());
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
