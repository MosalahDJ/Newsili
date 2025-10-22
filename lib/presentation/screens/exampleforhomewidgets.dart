// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:newsily/logic/cubit/fetch%20data/fetch_cubit.dart';
// import 'package:newsily/logic/cubit/fetch%20data/fetch_state.dart';
// import 'package:newsily/logic/cubit/save_articles.dart/bookmarks_cubit.dart';
// import 'package:newsily/logic/cubit/save_articles.dart/bookmarks_state.dart';
// import 'package:newsily/presentation/screens/article_description.dart';
// // import 'package:newsily/presentation/screens/home_page.dart'
//     // as search_controller;
// import 'package:newsily/presentation/widgets/home_page_skeleton.dart';
// import 'package:newsily/presentation/widgets/suggesion_banner.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import '../../data/models/news_data_model.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final CarouselSliderController _carouselController =
//       CarouselSliderController();
//   final TextEditingController _searchController = TextEditingController();
//   int _currentPage = 0;
//   List<Articles> _cachedLatestNews = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Newsily",
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//         ),
//         centerTitle: true,
//       ),
//       body: BlocBuilder<FetchCubit, FetchState>(
//         buildWhen: (previous, current) {
//           // Only rebuild when data actually changes
//           if (current is DataLoaded) {
//             final newNews = current.generalNews ?? [];
//             if (listEquals(_cachedLatestNews, newNews)) {
//               return false;
//             }
//             _cachedLatestNews = newNews;
//             return true;
//           }
//           return true;
//         },
//         builder: (context, state) {
//           if (state is DataLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is DataError) {
//             return Center(child: Text(state.errortext));
//           } else if (state is DataLoaded) {
//             return _buildContent(state);
//           }
//           return const HomePageSkeleton();
//         },
//       ),
//     );
//   }

//   Widget _buildContent(DataLoaded state) {
//     final newsMap = {
//       'general': state.generalNews ?? [],
//       'business': state.businessNews ?? [],
//       'technology': state.technologyNews ?? [],
//       'sports': state.sportsNews ?? [],
//       'entertainment': state.entertainmentNews ?? [],
//     };

//     // Derive trending & featured from available data
//     final trendingNews = newsMap['general']?.take(3).toList() ?? [];
//     final featuredNews = newsMap['technology']?.take(2).toList() ?? [];

//     return RefreshIndicator(
//       onRefresh: () async => context.read<FetchCubit>().getArticles(),
//       child: ListView(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         children: [
//           const SizedBox(height: 12),

//           // ==== SEARCH BAR ====
//           TextField(
//             controller: _searchController,
//             decoration: InputDecoration(
//               hintText: 'Search news...',
//               prefixIcon: const Icon(Icons.search),
//               filled: true,
//               fillColor: Theme.of(context).colorScheme.surfaceVariant,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(30),
//                 borderSide: BorderSide.none,
//               ),
//             ),
//             onSubmitted: (query) {
//               ScaffoldMessenger.of(
//                 context,
//               ).showSnackBar(SnackBar(content: Text('Searching for: $query')));
//             },
//           ),
//           const SizedBox(height: 24),

//           // ==== BREAKING NEWS ====
//           const Text(
//             "Breaking News",
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 16),
//           _buildCarousel(newsMap['general']!.take(4).toList()),
//           const SizedBox(height: 8),
//           _buildPageIndicator(
//             newsMap['general']!.length > 4 ? 4 : newsMap['general']!.length,
//           ),
//           const SizedBox(height: 32),

//           // ==== TOP STORIES (Horizontal) ====
//           const Text(
//             "Top Stories",
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey,
//             ),
//           ),
//           const SizedBox(height: 12),
//           _buildCategoryList(newsMap['business'] ?? [], 'business'),
//           const SizedBox(height: 32),

//           // 🔥 TRENDING NOW (Vertical List)
//           if (trendingNews.isNotEmpty) ...[
//             const Text(
//               "Trending Now",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.redAccent,
//               ),
//             ),
//             const SizedBox(height: 12),
//             ...trendingNews
//                 .map((article) => _buildTrendingCard(article))
//                 .toList(),
//             const SizedBox(height: 32),
//           ],

//           // 📚 FEATURED REPORTS / EDITOR'S PICKS
//           if (featuredNews.isNotEmpty) ...[
//             const Text(
//               "Editor's Picks",
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             ...featuredNews
//                 .map((article) => _buildFeaturedCard(article))
//                 .toList(),
//             const SizedBox(height: 32),
//           ],

//           // ==== SUGGESTION BANNER ====
//           buildSuggestionBanner(context),
//           const SizedBox(height: 24),
//         ],
//       ),
//     );
//   }

//   Widget _buildCarousel(List<Articles> news) {
//     return SizedBox(
//       height: 280,
//       child: CarouselSlider.builder(
//         carouselController: _carouselController,
//         itemCount: news.length,
//         itemBuilder: (context, index, realIndex) {
//           return _buildBreakingCard(context, news[index], index);
//         },
//         options: CarouselOptions(
//           height: 250,
//           autoPlay: true,
//           autoPlayInterval: const Duration(seconds: 3),
//           autoPlayAnimationDuration: const Duration(milliseconds: 500),
//           autoPlayCurve: Curves.easeInOut,
//           pauseAutoPlayOnTouch: true,
//           aspectRatio: 16 / 9,
//           viewportFraction: 0.8,
//           enlargeCenterPage: true,
//           onPageChanged: (index, reason) {
//             setState(() => _currentPage = index);
//           },
//         ),
//       ),
//     );
//   }

//   // ======= Breaking News Card =======
//   Widget _buildBreakingCard(BuildContext context, Articles article, int index) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => ArticleDescriptionPage(article: article),
//           ),
//         );
//       },
//       child: Hero(
//         tag: "${article.url}-$index",
//         child: Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           clipBehavior: Clip.antiAlias,
//           elevation: 4,
//           child: Stack(
//             children: [
//               // Background Image
//               Positioned.fill(
//                 child: Image.network(
//                   article.urlToImage ?? "",
//                   height: 150,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) {
//                     return Container(
//                       height: 150,
//                       color: Colors.grey[300],
//                       alignment: Alignment.center,
//                       child: const Icon(Icons.broken_image, size: 60),
//                     );
//                   },
//                 ),
//               ),
//               // Gradient overlay
//               Positioned.fill(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Colors.black.withValues(alpha: 0.1),
//                         Colors.black.withValues(alpha: 0.7),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               // Text
//               Positioned(
//                 bottom: 16,
//                 left: 16,
//                 right: 16,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       article.title ?? "No title available",
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                         height: 1.3,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         Text(
//                           article.source?.name ?? "",
//                           style: TextStyle(
//                             color: Colors.white.withValues(alpha: 0.9),
//                           ),
//                         ),
//                         const Spacer(),
//                         BlocBuilder<BookmarksCubit, BookmarksState>(
//                           builder: (context, state) {
//                             return FutureBuilder<bool>(
//                               future: context
//                                   .read<BookmarksCubit>()
//                                   .isBookmarked(article),
//                               builder: (context, snapshot) {
//                                 final isBookmarked = snapshot.data ?? false;
//                                 return IconButton(
//                                   icon: Icon(
//                                     isBookmarked
//                                         ? Icons.bookmark
//                                         : Icons.bookmark_border,
//                                     color: Colors.white,
//                                   ),
//                                   onPressed: () =>
//                                       _handleBookmarkPress(context, article),
//                                 );
//                               },
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // 🔥 Trending Card — Compact vertical list
//   Widget _buildTrendingCard(Articles article) {
//     return GestureDetector(
//       onTap: () {
//         // TODO
//       },
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 6),
//         child: Row(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: SizedBox(
//                 width: 100,
//                 height: 70,
//                 child: article.urlToImage != null
//                     ? Image.network(article.urlToImage!, fit: BoxFit.cover)
//                     : Container(color: Colors.grey[300]),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     article.title ?? 'Untitled',
//                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                       fontWeight: FontWeight.w600,
//                       height: 1.3,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     article.source?.name ?? '',
//                     style: Theme.of(
//                       context,
//                     ).textTheme.labelSmall?.copyWith(color: Colors.grey),
//                   ),
//                 ],
//               ),
//             ),
//             IconButton(
//               onPressed: () {
//                 // todo
//               },
//               icon: const Icon(Icons.more_vert, size: 18),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // 📚 Featured Card — Larger, with excerpt
//   Widget _buildFeaturedCard(Articles article) {
//     return GestureDetector(
//       onTap: () {
//         // TODO
//       },
//       child: Card(
//         margin: const EdgeInsets.only(bottom: 16),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         clipBehavior: Clip.hardEdge,
//         elevation: 2,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             AspectRatio(
//               aspectRatio: 16 / 9,
//               child: article.urlToImage != null
//                   ? Image.network(article.urlToImage!, fit: BoxFit.cover)
//                   : Container(color: Colors.grey[300]),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     article.title ?? 'Untitled',
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                       fontWeight: FontWeight.bold,
//                       height: 1.3,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 8),
//                   if (article.description != null)
//                     Text(
//                       article.description!,
//                       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                         color: Theme.of(context).colorScheme.onSurfaceVariant,
//                         height: 1.4,
//                       ),
//                       maxLines: 3,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       Text(
//                         article.source?.name ?? '',
//                         style: Theme.of(
//                           context,
//                         ).textTheme.labelSmall?.copyWith(color: Colors.grey),
//                       ),
//                       const Spacer(),
//                       // _BookmarkButton(article: article),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _handleBookmarkPress(BuildContext context, Articles article) async {
//     if (!context.mounted) return;

//     final bookmarksCubit = context.read<BookmarksCubit>();
//     final isBookmarked = await bookmarksCubit.isBookmarked(article);

//     if (!context.mounted) return;

//     if (isBookmarked) {
//       bookmarksCubit.removeBookmark(article);
//     } else {
//       bookmarksCubit.addBookmark(article);
//     }
//   }

//   Widget _buildPageIndicator(int itemCount) {
//     return Center(
//       child: AnimatedSmoothIndicator(
//         activeIndex: _currentPage,
//         count: itemCount,
//         effect: ExpandingDotsEffect(
//           dotHeight: 8,
//           dotWidth: 8,
//           activeDotColor: Theme.of(context).colorScheme.primary,
//           dotColor: Colors.grey.withValues(alpha: .3),
//         ),
//       ),
//     );
//   }
// }

// Widget _buildCategoryList(List<Articles> articles, String categoryKey) {
//   if (articles.isEmpty) {
//     return const Padding(
//       padding: EdgeInsets.symmetric(vertical: 16),
//       child: Text(
//         "No articles available",
//         style: TextStyle(color: Colors.grey),
//       ),
//     );
//   }

//   return SizedBox(
//     height: 220,
//     child: ListView.builder(
//       scrollDirection: Axis.horizontal,
//       itemCount: articles.length,
//       itemBuilder: (context, index) {
//         final article = articles[index];
//         return GestureDetector(
//           onTap: () {
//             //TODO
//           },
//           child: SizedBox(
//             width: 280,
//             child: Card(
//               margin: const EdgeInsets.only(right: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               clipBehavior: Clip.hardEdge,
//               elevation: 2,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   AspectRatio(
//                     aspectRatio: 16 / 9,
//                     child: article.urlToImage != null
//                         ? Image.network(
//                             article.urlToImage!,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) =>
//                                 Container(color: Colors.grey[300]),
//                           )
//                         : Container(color: Colors.grey[300]),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           article.title ?? 'Untitled',
//                           style: Theme.of(context).textTheme.titleSmall
//                               ?.copyWith(
//                                 fontWeight: FontWeight.bold,
//                                 height: 1.3,
//                               ),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         const SizedBox(height: 6),
//                         Row(
//                           children: [
//                             Flexible(
//                               child: Text(
//                                 article.source?.name ?? '',
//                                 style: Theme.of(context).textTheme.labelSmall
//                                     ?.copyWith(color: Colors.grey),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                             const SizedBox(width: 6),
//                             IconButton(
//                               padding: EdgeInsets.zero,
//                               constraints: const BoxConstraints(),
//                               splashRadius: 20,
//                               onPressed: () {
//                                 // TODO
//                               },
//                               icon: const Icon(Icons.more_vert, size: 18),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     ),
//   );
// }

// // @override
// // void dispose() {
// //   search_controller.dispose();
// // }
