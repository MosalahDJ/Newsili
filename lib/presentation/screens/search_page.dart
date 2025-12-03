import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/logic/cubit/fetch_data/fetch_cubit.dart';
import 'package:newsily/logic/cubit/fetch_data/fetch_state.dart';
import 'package:newsily/presentation/widgets/homepage%20widgets/trending_card.dart';
import 'package:newsily/presentation/widgets/search_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔍 Search Input
            Hero(
              tag: "search-bar-hero",
              child: Material(
                type: MaterialType.transparency,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: MySearchBar(
                    isButton: false,
                    searchController: _searchController,
                  ),
                ),
              ),
            ),
            // 🔎 Results
            Expanded(
              child: BlocBuilder<FetchCubit, FetchState>(
                builder: (context, state) {
                  if (state is DataLoaded) {
                    final results = state.searchResults;
                    if (results.isEmpty && _searchController.text.isNotEmpty) {
                      return const Center(child: Text('No results found'));
                    }
                    if (_searchController.text.isEmpty) {
                      return const Center(
                        child: Text('Type to search news...'),
                      );
                    }

                    return ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final article = results[index];
                        return buildTrendingCard(context, article);
                      },
                    );
                  }

                  // If not DataLoaded (e.g., still loading initial data)
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
