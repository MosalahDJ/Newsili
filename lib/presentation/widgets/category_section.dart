import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/data/models/news_data_model.dart';
import 'package:newsily/logic/cubit/fetch%20data/fetch_cubit.dart';
import 'package:newsily/logic/cubit/fetch%20data/fetch_state.dart';
import 'news_card.dart';

class CategorySection extends StatelessWidget {
  final String title;
  final List<Articles> articles;

  const CategorySection({
    super.key,
    required this.title,
    required this.articles,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),TextButton(
  onPressed: () {
    final state = context.read<FetchCubit>().state;

    if (state is DataLoaded) {
      List<Articles> selectedList = [];

      switch (title) {
        case "Business":
          selectedList = state.businessNews ?? [];
          break;
        case "Entertainment":
          selectedList = state.entertainmentNews ?? [];
          break;
        case "General":
          selectedList = state.generalNews ?? [];
          break;
        case "Health":
          selectedList = state.healthNews ?? [];
          break;
        case "Science":
          selectedList = state.scienceNews ?? [];
          break;
        case "Sports":
          selectedList = state.sportsNews ?? [];
          break;
        case "Technology":
          selectedList = state.technologyNews ?? [];
          break;
      }

      Navigator.pushNamed(
        context,
        "/category",
        arguments: {
          "category": title,
          "articles": selectedList,
        },
      );
    }
  },
  child: const Text("See All"),
),

          ],
        ),
        SizedBox(
          height: 260,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.85),
            itemCount: articles.length > 4 ? 4 : articles.length,
            itemBuilder: (context, index) {
              return NewsCard(article: articles, i: index);
            },
          ),
        ),
      ],
    );
  }
}
