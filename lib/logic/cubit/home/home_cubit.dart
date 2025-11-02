import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  /// Share article function
  Future<void> shareArticle(
    BuildContext context, {
    required String title,
    required String url,
  }) async {
    emit(state.copyWith(isSharing: true));
    try {
      await SharePlus.instance.share(
        ShareParams(text: "$title\n\nRead more: $url", subject: title),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error sharing article: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      emit(state.copyWith(isSharing: false));
    }
  }

  /// Copy article link
  Future<void> copyLink(BuildContext context, String url) async {
    await Clipboard.setData(ClipboardData(text: url));
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Link copied to clipboard ✅")));
  }
}
