import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/logic/cubit/fetch%20data/fetch_cubit.dart';
import 'package:newsily/logic/cubit/fetch%20data/fetch_state.dart';
import 'package:newsily/presentation/widgets/categories_page_skeletonizer.dart';
import '../widgets/category_section.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
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
          return CategoriesPageSkeleton();
        },
      ),
    );
  }
}
