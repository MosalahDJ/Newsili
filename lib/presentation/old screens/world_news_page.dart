// import 'package:algeria_news/logic/cubits/world%20news%20cubit/world_news_api_fetch_cubit.dart';
// import 'package:algeria_news/presentation/widgets/data_loaded_widget.dart';
// import 'package:algeria_news/presentation/widgets/state_error_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class WorldNewsPage extends StatefulWidget {
//   const WorldNewsPage({super.key});

//   @override
//   State<WorldNewsPage> createState() => _NewsPageState();
// }

// class _NewsPageState extends State<WorldNewsPage> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<WorldNewsFetchCubit>().fetchData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocBuilder<WorldNewsFetchCubit, WorldNewsFetchState>(
//         builder: (context, state) {
//           if (state is WorldNewsDataloading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is WorldNewsDataLoaded) {
//             final articles = state.data?['articles'] as List<dynamic>;
//             return DataLoadedWidget(articles: articles);
//           } else if (state is WorldNewsDataError) {
//             return StateErrorWidget(errortext: state.errortext);
//           } else {
//             return const Center(child: Text("Press button to load news"));
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => context.read<WorldNewsFetchCubit>().fetchData(),
//         child: const Icon(Icons.refresh),
//       ),
//     );
//   }
// }
