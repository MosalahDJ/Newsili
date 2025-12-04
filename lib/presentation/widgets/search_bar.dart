import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:newsily/logic/cubit/fetch_data/fetch_cubit.dart';

// ignore: must_be_immutable
class MySearchBar extends StatefulWidget {
  const MySearchBar({super.key, this.searchController, required this.isButton});
  final TextEditingController? searchController;
  final bool isButton;

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  Timer? debounce;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(11),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              offset: const Offset(0, 4),
              color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            ),
          ],
        ),
        child: TextField(
          enabled: widget.isButton ? false : true,
          readOnly: widget.isButton ? true : false,
          controller: widget.searchController,
          style: TextStyle(fontSize: 15, color: theme.colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: 'Search articles…',
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Icon(
              Icons.search,
              size: 22,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            suffixIcon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, anim) =>
                  FadeTransition(opacity: anim, child: child),
              child: widget.isButton
                  ? null
                  : widget.searchController!.text.isNotEmpty
                  ? IconButton(
                      key: const ValueKey('clearBtn'),
                      icon: Icon(
                        Icons.close,
                        size: 18,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () {
                        widget.searchController!.clear();
                        context.read<FetchCubit>().performSearch('');
                      },
                    )
                  : const SizedBox.shrink(key: ValueKey('empty')),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            filled: false,
          ),
          cursorColor: theme.colorScheme.primary,
          onChanged: widget.isButton
              ? null
              : (query) {
                  debounce?.cancel();
                  debounce = Timer(const Duration(milliseconds: 300), () {
                    context.read<FetchCubit>().performSearch(query);
                  });
                },
          onSubmitted: widget.isButton
              ? null
              : (query) {
                  context.read<FetchCubit>().performSearch(query);
                },
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.isButton ? null : debounce?.cancel();
    super.dispose();
  }
}
