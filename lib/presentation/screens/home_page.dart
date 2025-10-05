import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/logic/cubit/fetch%20data/fetch_cubit.dart';
import 'package:newsily/logic/cubit/fetch%20data/fetch_state.dart';
import '../widgets/category_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<FetchCubit>().getArticles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Newsly", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: BlocBuilder<FetchCubit, FetchState>(
        builder: (context, state) {
          if (state is DataError) {
            return Center(child: Text("Error: ${state.errortext}"));
          } else if (state is DataLoaded) {
            return ListView(
              padding: EdgeInsets.all(12),
              children: [
                CategorySection(title: "General", articles: state.generalNews!),
                CategorySection(
                  title: "Business",
                  articles: state.businessNews!,
                ),
                CategorySection(
                  title: "Entertainment",
                  articles: state.entertainmentNews!,
                ),
                CategorySection(title: "Health", articles: state.healthNews!),
                CategorySection(title: "Science", articles: state.scienceNews!),
                CategorySection(title: "Sports", articles: state.sportsNews!),
                CategorySection(
                  title: "Technology",
                  articles: state.technologyNews!,
                ),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: "Bookmarks",
          ),
        ],
      ),
    );
  }
}
