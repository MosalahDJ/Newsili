// import 'package:algeria_news/logic/cubits/Economique%20news%20cubit/economic_api_fetch_cubit.dart';
// import 'package:algeria_news/presentation/widgets/data_loaded_widget.dart';
// import 'package:algeria_news/presentation/widgets/state_error_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class EconomicNewsPage extends StatefulWidget {
//   const EconomicNewsPage({super.key});

//   @override
//   State<EconomicNewsPage> createState() => _EconomicNewsPageState();
// }

// class _EconomicNewsPageState extends State<EconomicNewsPage> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<EconomiqueFetchCubit>().fetchData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocBuilder<EconomiqueFetchCubit, EconomiqueFetchState>(
//         builder: (context, state) {
//           if (state is EconomiqueDataloading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is EconomiqueDataLoaded) {
//             final articles = state.data?['articles'] as List<dynamic>;
//             return DataLoadedWidget(articles: articles);
//           } else if (state is EconomiqueDataError) {
//             return StateErrorWidget(errortext: state.errortext);
//           } else {
//             return const Center(child: Text("Press button to load news"));
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => context.read<EconomiqueFetchCubit>().fetchData(),
//         child: const Icon(Icons.refresh),
//       ),
//     );
//   }
// }
