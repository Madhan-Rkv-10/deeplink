import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MaterialApp.router(routerConfig: router));

/// This handles '/' and '/details'.
final router = GoRouter(
  debugLogDiagnostics: true,
  redirect: (context, state) {
    log(state.fullPath.toString());
    if (state.path != null) {
      if (state.path!.endsWith('/mad')) {
        print("madhan");
      } else {
        print("not");
      }
      ;
    }
    log(state.path.toString());
    log(state.name.toString());
    log(state.name.toString());
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => Scaffold(
        appBar: AppBar(
          title: const Text('Home Screen'),
        ),
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  _.go('/mad');

                  // await launchUrl(
                  //     Uri.parse("https://ticketing-mob.excelsior-fht.com/sam"));
                },
                child: Text("Open details"))
          ],
        ),
      ),
      routes: [
        GoRoute(
          path: 'details',
          builder: (_, __) => Scaffold(
            appBar: AppBar(title: const Text('Details Screen')),
            body: Column(
              children: [
                ElevatedButton(
                    onPressed: () async {
                      // await launchUrl(Uri.parse(
                      //     "https://ticketing-mob.excelsior-fht.com/sam"));
                    },
                    child: Text("Open Home"))
              ],
            ),
          ),
        ),
        GoRoute(
          path: 'sam',
          builder: (_, __) => Scaffold(
            appBar: AppBar(title: const Text('sam Screen')),
            body: Column(
              children: [
                ElevatedButton(
                    onPressed: () async {
                      _.goNamed('details');
                      // await launchUrl(Uri.parse(
                      //     "https://ticketing-mob.excelsior-fht.com/sam"));
                    },
                    child: Text("Open Home"))
              ],
            ),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/mad',
      // name: AppRoute.login.name,
      builder: (context, state) {
        return const Sample();
      },
    ),
  ],
);

class Sample extends StatelessWidget {
  const Sample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () async {
                context.goNamed('/mass');

                // await launchUrl(
                //     Uri.parse("https://ticketing-mob.excelsior-fht.com/sam"));
              },
              child: Text("Open details"))
        ],
      ),
    );
  }
}
