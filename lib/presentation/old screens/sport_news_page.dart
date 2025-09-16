// import 'package:algeria_news/logic/cubits/sports%20news%20cubit/sport_api_fetch_cubit.dart';
// import 'package:algeria_news/presentation/widgets/data_loaded_widget.dart';
// import 'package:algeria_news/presentation/widgets/state_error_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class SportNewsPage extends StatefulWidget {
//   const SportNewsPage({super.key});

//   @override
//   State<SportNewsPage> createState() => _NewsPageState();
// }

// class _NewsPageState extends State<SportNewsPage> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<SportFetchCubit>().fetchData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocBuilder<SportFetchCubit, SportFetchState>(
//         builder: (context, state) {
//           if (state is SportDataloading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is SportDataLoaded) {
//             final articles = state.data?['articles'] as List<dynamic>;
//             return DataLoadedWidget(articles: articles);
//           } else if (state is SportDataError) {
//             return StateErrorWidget(errortext: state.errortext);
//           } else {
//             return const Center(child: Text("Press button to load news"));
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => context.read<SportFetchCubit>().fetchData(),
//         child: const Icon(Icons.refresh),
//       ),
//     );
//   }
// }
