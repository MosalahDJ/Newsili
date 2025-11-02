import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/data/models/news_data_model.dart';
import 'package:newsily/logic/cubit/save_articles/bookmarks_cubit.dart';
import 'package:newsily/logic/cubit/save_articles/bookmarks_state.dart';

void showArticleMoreMenu(
  BuildContext context, {
  required VoidCallback onShare,
  required VoidCallback onSave,
  required Articles article,
}) async {
  final RenderBox button = context.findRenderObject() as RenderBox;
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;

  final RelativeRect position = RelativeRect.fromRect(
    Rect.fromPoints(
      button.localToGlobal(Offset.zero, ancestor: overlay),
      button.localToGlobal(
        button.size.bottomRight(Offset.zero),
        ancestor: overlay,
      ),
    ),
    Offset.zero & overlay.size,
  );

  final selected = await showMenu<String>(
    context: context,
    position: position,
    items: [
      const PopupMenuItem<String>(
        value: 'share',
        child: Row(
          children: [Icon(Icons.share), SizedBox(width: 8), Text("Share")],
        ),
      ),
      PopupMenuItem<String>(
        value: 'save',
        child: BlocBuilder<BookmarksCubit, BookmarksState>(
          builder: (context, state) {
            //TODO: Ihave some problems with future in this function tomorrow inchaalaw I will fix all that
            // bool isbookmarked = context.read<BookmarksCubit>().isBookmarked(article);
            return Row(
              children: [
                // Icon(isbookmarked?Icons.bookmark:Icons.bookmark_border,),
                SizedBox(width: 8),
                Text(
                  "",

                  // state.isSaved?"Saved":"Save",
                ),
              ],
            );
          },
        ),
      ),
    ],
  );

  if (selected == 'share') onShare();
  if (selected == 'save') onSave();
}
