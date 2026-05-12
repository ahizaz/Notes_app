import 'package:get/get.dart';
import '../data/models/user_model.dart';
import '../data/services/api_service.dart';
import '../data/services/local_storage_service.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;
  final isLoggedIn = false.obs;
  final currentUser = Rx<UserModel?>(null);
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    final user = await LocalStorageService.getUser();
    if (user != null) {
      currentUser.value = user;
      isLoggedIn.value = true;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      if (password != confirmPassword) {
        errorMessage.value = 'Passwords do not match';
        return false;
      }

      if (email.isEmpty || !email.contains('@')) {
        errorMessage.value = 'Please enter a valid email';
        return false;
      }

      isLoading.value = true;
      errorMessage.value = '';

      final user = await ApiService.register(
        name: name,
        email: email,
        password: password,
      );

      if (user != null) {
        return true;
      }

      return false;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || !email.contains('@')) {
        errorMessage.value = 'Please enter a valid email';
        return false;
      }

      isLoading.value = true;
      errorMessage.value = '';

      final user = await ApiService.login(
        email: email,
        password: password,
      );

      if (user != null) {
        await LocalStorageService.saveUser(user);
        currentUser.value = user;
        isLoggedIn.value = true;
        return true;
      }

      return false;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await LocalStorageService.clearUser();
      await LocalStorageService.clearToken();
      currentUser.value = null;
      isLoggedIn.value = false;
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
