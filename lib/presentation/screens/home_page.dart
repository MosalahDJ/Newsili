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
    context.read<FetchCubit>().fetchData(
      "top-headlines?category=sports&apiKey=",
    );
    // context.read<FetchCubit>().fetchData("");
    // context.read<FetchCubit>().fetchData("");
    // context.read<FetchCubit>().fetchData("");
    super.initState();
  }

  final List<String> categories = [
    "General",
    "Business",
    "Entertainment",
    "Health",
    "Science",
    "Sports",
    "Technology",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Newsly", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: BlocBuilder<FetchCubit, FetchState>(
        builder: (context, state) {
          if (state is DataLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is DataError) {
            return Center(child: Text("Error: ${state.errortext}"));
          } else if (state is DataLoaded) {
            return ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return CategorySection(
                  title: categories[index],
                  articles: state.data?['articles'] as List<dynamic>,
                );
              },
            );
          }
          return Center(child: Text("No data"));
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
