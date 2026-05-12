import 'package:get/get.dart';
import '../data/services/local_storage_service.dart';

class SplashController extends GetxController {
  final isFirstLaunch = true.obs;

  @override
  void onInit() {
    super.onInit();
    checkFirstLaunch();
  }

  Future<void> checkFirstLaunch() async {
    final isShown = await LocalStorageService.isSplashShown();
    isFirstLaunch.value = !isShown;

    // Mark splash as shown
    if (!isShown) {
      await LocalStorageService.setSplashShown(true);
    }
  }
}
