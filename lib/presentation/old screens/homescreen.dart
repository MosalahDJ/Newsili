// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class NewsHomePage extends StatelessWidget {
//   final List<String> categories = [
//     "Business",
//     "Entertainment",
//     "General",
//     "Health",
//     "Science",
//     "Sports",
//     "Technology",
//   ];

//   NewsHomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Text(
//           "News App",
//           style: TextStyle(
//             color: Colors.black87,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.search, color: Colors.black87),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: ListView.builder(
//         padding: EdgeInsets.all(16),
//         itemCount: categories.length,
//         itemBuilder: (context, index) {
//           final category = categories[index];
//           return BlocProvider(
//             create: (_) => NewsCubit()..fetchNews(category),
//             child: _CategorySection(category: category),
//           );
//         },
//       ),
//     );
//   }
// }

// class _CategorySection extends StatelessWidget {
//   final String category;

//   const _CategorySection({required this.category});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Title + See All button
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               category,
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             IconButton(
//               icon: Icon(Icons.more_horiz),
//               onPressed: () {
//                 // go to "See All" page
//               },
//             )
//           ],
//         ),
//         SizedBox(height: 12),

//         // BlocBuilder to listen for state
//         BlocBuilder<NewsCubit, NewsState>(
//           builder: (context, state) {
//             if (state is NewsLoading) {
//               return SizedBox(
//                 height: 200,
//                 child: Center(child: CircularProgressIndicator()),
//               );
//             } else if (state is NewsLoaded) {
//               return SizedBox(
//                 height: 220,
//                 child: PageView.builder(
//                   controller: PageController(viewportFraction: 0.8),
//                   itemCount: state.news.length,
//                   itemBuilder: (context, index) {
//                     final item = state.news[index];
//                     return _NewsCard(
//                       title: item["title"]!,
//                       description: item["description"]!,
//                     );
//                   },
//                 ),
//               );
//             } else {
//               return Text("Error loading $category news");
//             }
//           },
//         ),
//         SizedBox(height: 24),
//       ],
//     );
//   }
// }

// class _NewsCard extends StatelessWidget {
//   final String title;
//   final String description;

//   const _NewsCard({required this.title, required this.description});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(right: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 6,
//             offset: Offset(0, 3),
//           )
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Image placeholder
//           ClipRRect(
//             borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//             child: Container(
//               height: 120,
//               color: Colors.grey[300],
//               child: Center(
//                 child: Icon(Icons.image, size: 50, color: Colors.grey[500]),
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//                 ),
//                 SizedBox(height: 6),
//                 Text(
//                   description,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(fontSize: 12, color: Colors.black54),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }






// // import 'package:algeria_news/presentation/screens/algeria_news_page.dart';
// // import 'package:algeria_news/presentation/screens/economic_news_page.dart';
// // import 'package:algeria_news/presentation/screens/sport_news_page.dart';
// // import 'package:algeria_news/presentation/screens/world_news_page.dart';
// // import 'package:flutter/material.dart';

// // class NewsApp extends StatelessWidget {
// //   const NewsApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return const MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       home: NewsHomePage(),
// //     );
// //   }
// // }

// // class NewsHomePage extends StatelessWidget {
// //   const NewsHomePage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return DefaultTabController(
// //       length: 4, // number of tabs
// //       child: Scaffold(
// //         appBar: AppBar(
// //           title: const Text(
// //             "News App",
// //             style: TextStyle(
// //               fontWeight: FontWeight.bold,
// //               fontSize: 22,
// //             ),
// //           ),
// //           centerTitle: true,
// //           elevation: 5,
// //           shadowColor: Colors.black45,
// //           backgroundColor: Colors.white,
// //           foregroundColor: Colors.black,
// //           bottom: const TabBar(
// //             isScrollable: false,
// //             indicatorColor: Colors.red,
// //             indicatorWeight: 3,
// //             labelColor: Colors.red,
// //             unselectedLabelColor: Colors.grey,
// //             labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
// //             tabs: [
// //               Tab(text: "World"),
// //               Tab(text: "Sports"),
// //               Tab(text: "Business"),
// //               Tab(text: "Algeria"),
// //             ],
// //           ),
// //         ),
// //         body: const TabBarView(
// //           children: [
// //             WorldNewsPage(),
// //             SportNewsPage(),
// //             EconomicNewsPage(),
// //             AlgeriaNewsPage(),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // void main() {
// //   runApp(const NewsApp());
// // }
