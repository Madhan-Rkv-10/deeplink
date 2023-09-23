import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:url_launcher/url_launcher.dart';

class AuthController with ChangeNotifier {
  bool isLoggedIn = false;

  void signIn() {
    isLoggedIn = true;
    notifyListeners();
  }

  void signOut() {
    isLoggedIn = false;
    notifyListeners();
  }
}

final authProvider = ChangeNotifierProvider((ref) => AuthController());
final _key = GlobalKey<NavigatorState>();

enum AppRoute { splash, login, home, deeplink }

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _key,

    /// Forwards diagnostic messages to the dart:developer log() API.
    debugLogDiagnostics: true,

    /// Initial Routing Location
    initialLocation: '/',

    /// The listeners are typically used to notify clients that the object has been
    /// updated.
    refreshListenable: authState,

    routes: [
      GoRoute(
        path: '/${AppRoute.splash.name}',
        name: AppRoute.splash.name,
        builder: (context, state) {
          return const SplashPage();
        },
      ),
      GoRoute(
        path: '/',
        name: AppRoute.home.name,
        builder: (context, state) {
          return const HomePage();
        },
      ),
      GoRoute(
        path: '/${AppRoute.login.name}',
        name: AppRoute.login.name,
        builder: (context, state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: '/${AppRoute.deeplink.name}',
        name: AppRoute.deeplink.name,
        builder: (context, state) {
          return const DeepLinkPage();
        },
      ),
    ],
    redirect: (context, state) {
      if (state.uri.queryParameters['sam'] != null) {
        return '/${AppRoute.deeplink.name}';
      }
      return null;
    },
  );
});

void main() {
  runApp(const ProviderScope(child: GoRouterRiverpodExample()));
}

class GoRouterRiverpodExample extends ConsumerWidget {
  const GoRouterRiverpodExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your App Name")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Home Page"),
            ElevatedButton(
              onPressed: () async {
                // ref.read(authProvider.notifier).signOut();
                context.goNamed('deeplink');
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Login Page"),
            ElevatedButton(
              onPressed: () async {
                ref.read(authProvider.notifier).signIn();
              },
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: Text("Splash Page")),
          ElevatedButton(
              onPressed: () async {
                await launchUrl(
                    Uri.parse("https://ticketing-mob.excelsior-fht.com/sam"));

                // context.goNamed(AppRoute.login.name);
              },
              child: const Text("Lets Login"))
        ],
      ),
    );
  }
}

class DeepLinkPage extends HookConsumerWidget {
  const DeepLinkPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your App Name")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("DeepLink Page"),
            ElevatedButton(
              onPressed: () async {
                ref.read(authProvider.notifier).signOut();
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
