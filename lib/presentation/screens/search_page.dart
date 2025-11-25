import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/logic/cubit/fetch%20data/fetch_cubit.dart';
import 'package:newsily/logic/cubit/fetch%20data/fetch_state.dart';
import 'package:newsily/presentation/widgets/homepage%20widgets/trending_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

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
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                hintText: 'Type to search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          context.read<FetchCubit>().performSearch('');
                        },
                      )
                    : null,
              ),
              onChanged: (query) {
                _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 300), () {
                  context.read<FetchCubit>().performSearch(query);
                });
              },
              onSubmitted: (query) {
                context.read<FetchCubit>().performSearch(query);
              },
            ),
            const SizedBox(height: 16),

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
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }
}

// tomorrow I will add some modifications