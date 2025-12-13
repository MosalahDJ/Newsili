import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/logic/cubit/fetch_data/fetch_cubit.dart';
import 'package:newsily/presentation/screens/bookmarks_page.dart';
import 'package:newsily/presentation/screens/categorypage.dart';
import 'package:newsily/presentation/screens/home_page.dart';
import 'package:newsily/presentation/screens/about_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() async {
    final theme = Theme.of(context);

    // Check internet connectivity
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Connectivity Issue: Cannot refresh feed. Check your internet connection.',
            style: theme.textTheme.titleSmall?.copyWith(
              height: 1.3,
              color: theme.colorScheme.onSurface,
            ),
          ),
          backgroundColor: theme.colorScheme.surface,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
    // ignore: use_build_context_synchronously
    context.read<FetchCubit>().getArticles();
    super.initState();
  }

  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    const CategoryPage(),
    BookmarksPage(),
    AboutPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.1),
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: theme.colorScheme.surface,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: theme.colorScheme.onSurfaceVariant,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
          showUnselectedLabels: true,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_rounded),
              label: "Categories",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_rounded),
              label: "Bookmarks",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info_outline_rounded),
              label: "About",
            ),
          ],
        ),
      ),
    );
  }
}
