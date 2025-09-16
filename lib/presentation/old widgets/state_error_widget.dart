import 'package:flutter/material.dart';

class StateErrorWidget extends StatelessWidget {
  const StateErrorWidget({super.key, required this.errortext});
  final String errortext;

  @override
  Widget build(BuildContext context) {
    return Center(
              child: Text(
                "Error: $errortext",
                style: const TextStyle(color: Colors.red),
              ),
            );
  }
}