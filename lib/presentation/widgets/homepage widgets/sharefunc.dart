import 'package:share_plus/share_plus.dart';

Future<void> shareWithAnyApp() async {
  try {
    await SharePlus.instance.share(ShareParams(subject: 'check this news'));
  } catch (e) {
    print(e);
    // Get.snackbar(
    //   'Error',
    //   'Could not share content',
    //   snackPosition: SnackPosition.BOTTOM,
    // );
  }
}
