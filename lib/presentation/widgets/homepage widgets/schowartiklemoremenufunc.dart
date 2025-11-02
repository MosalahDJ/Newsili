import 'package:flutter/material.dart';

void showArticleMoreMenu(BuildContext context,IconData bookmarkicon ,String bookmarktext, {required VoidCallback onShare, required VoidCallback onSave}) async {
  final RenderBox button = context.findRenderObject() as RenderBox;
  final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

  final RelativeRect position = RelativeRect.fromRect(
    Rect.fromPoints(
      button.localToGlobal(Offset.zero, ancestor: overlay),
      button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
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
        child: Row(
          children: [Icon(bookmarkicon), SizedBox(width: 8), Text(bookmarktext)],
        ),
      ),
    ],
  );

  if (selected == 'share') onShare();
  if (selected == 'save') onSave();
}
