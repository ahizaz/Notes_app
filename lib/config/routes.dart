import 'package:go_router/go_router.dart';
import '../presentation/pages/splash_screen.dart';
import '../presentation/pages/login_screen.dart';
import '../presentation/pages/register_screen.dart';
import '../presentation/pages/home_screen.dart';
import '../presentation/pages/add_note_screen.dart';
import '../presentation/pages/note_detail_screen.dart';
import '../presentation/pages/edit_note_screen.dart';
import '../data/models/note_model.dart';
import '../controllers/auth_controller.dart';
import 'package:get/get.dart';

final goRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/add-note',
      name: 'add-note',
      builder: (context, state) => const AddNoteScreen(),
    ),
    GoRoute(
      path: '/note-detail',
      name: 'note-detail',
      builder: (context, state) {
        final note = state.extra as NoteModel;
        return NoteDetailScreen(note: note);
      },
    ),
    GoRoute(
      path: '/edit-note',
      name: 'edit-note',
      builder: (context, state) {
        final note = state.extra as NoteModel;
        return EditNoteScreen(note: note);
      },
    ),
  ],
  redirect: (context, state) {
    try {
      final authController = Get.find<AuthController>();
      final isSplash = state.matchedLocation == '/splash';
      final isLoginOrRegister =
          state.matchedLocation == '/login' || state.matchedLocation == '/register';

      // If going to splash, allow
      if (isSplash) {
        return null;
      }

      // If not logged in and not on login/register, redirect to login
      if (!authController.isLoggedIn.value && !isLoginOrRegister) {
        return '/login';
      }

      // If logged in and trying to access login/register, redirect to home
      if (authController.isLoggedIn.value && isLoginOrRegister) {
        return '/home';
      }

      return null;
    } catch (e) {
      return null;
    }
  },
);
