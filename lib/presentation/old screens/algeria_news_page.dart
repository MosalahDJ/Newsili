// import 'package:algeria_news/logic/cubits/algeria%20news%20cubit/algeria_news_cubit.dart';
// import 'package:algeria_news/presentation/widgets/data_loaded_widget.dart';
// import 'package:algeria_news/presentation/widgets/state_error_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class AlgeriaNewsPage extends StatefulWidget {
//   const AlgeriaNewsPage({super.key});

//   @override
//   State<AlgeriaNewsPage> createState() => _AlgeriaNewsPageState();
// }

// class _AlgeriaNewsPageState extends State<AlgeriaNewsPage> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<AlgerianewsCubit>().fetchData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocBuilder<AlgerianewsCubit, AlgeriaNewsState>(
//         builder: (context, state) {
//           if (state is AlgeriaNewsDataloading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is AlgeriaNewsDataLoaded) {
//             final articles = state.data?['articles'] as List<dynamic>;
//             return DataLoadedWidget(articles: articles);
//           } else if (state is AlgeriaNewsDataError) {
//             return StateErrorWidget(errortext: state.errortext);
//           } else {
//             return const Center(child: Text("Press button to load news"));
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => context.read<AlgerianewsCubit>().fetchData(),
//         child: const Icon(Icons.refresh),
//       ),
//     );
//   }
// }
