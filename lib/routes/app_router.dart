import 'package:go_router/go_router.dart';
import 'package:pt_flutter_faag/screens/home_screen.dart';
import 'package:pt_flutter_faag/screens/login_screen.dart';
import 'package:pt_flutter_faag/screens/splash_screen.dart';
import 'package:pt_flutter_faag/screens/user_form_screen.dart';
import 'package:pt_flutter_faag/screens/edit_user_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/login', builder: (_, __) => LoginScreen()),
    GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/add-user', builder: (_, __) => UserFormScreen()),
    GoRoute(
      path: '/edit-user',
      builder: (context, state) {
        if (state.extra == null || state.extra is! Map<String, dynamic>) {
          return const HomeScreen();
        }
        return EditUserScreen(user: state.extra as Map<String, dynamic>);
      },
    ),
  ],
);
