
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/data/models/news_data_model.dart';
import 'package:newsily/logic/cubit/save_articles/bookmarks_cubit.dart';

void handleBookmarkPress(BuildContext context, Articles article) async {
    if (!context.mounted) return;

    final bookmarksCubit = context.read<BookmarksCubit>();
    final isBookmarked = await bookmarksCubit.isBookmarked(article);

    if (!context.mounted) return;

    if (isBookmarked) {
      bookmarksCubit.removeBookmark(article);
    } else {
      bookmarksCubit.addBookmark(article);
    }
  }