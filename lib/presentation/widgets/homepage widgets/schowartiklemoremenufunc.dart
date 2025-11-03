import 'package:flutter/material.dart';
import 'package:newsily/data/models/news_data_model.dart';

void showArticleMoreMenu(
  BuildContext context, {
  required VoidCallback onShare,
  required VoidCallback onSave,
  required Articles article,
  required bool isbookmarked,
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
        child:  Row(
              children: [
                Icon(isbookmarked?Icons.bookmark:Icons.bookmark_border,),
                SizedBox(width: 8),
                Text(
                  isbookmarked?"Saved":"Save",
                ),
              ],
            )
      ),
    ],
  );

  if (selected == 'share') onShare();
  if (selected == 'save') onSave();
}
