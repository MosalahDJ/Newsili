import 'dart:developer';
import 'package:share_plus/share_plus.dart';

Future<void> shareWithAnyApp() async {
  try {
    await SharePlus.instance.share(ShareParams(subject: 'check this news'));
  } catch (e) {
    log(e.toString());
  }
}


// TODO: tomorow I will fix the bag of sharing func and modify some othe features