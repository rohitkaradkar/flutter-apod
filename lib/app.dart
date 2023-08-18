import 'package:apod/details/picture_details_page.dart';
import 'package:apod/list/widget/picture_list_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ApodApp extends StatelessWidget {
  const ApodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'APOD',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const PictureListPage(),
      routes: [
        GoRoute(
          path: 'details',
          builder: (context, state) {
            return PictureDetailsPage(
              selectedItemDate: state.uri.queryParameters['date']!,
            );
          },
        ),
      ],
    ),
  ],
);
