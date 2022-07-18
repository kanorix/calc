import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'pages/home_page.dart';

final routerProvider = Provider(
  (_) => GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: "/",
        builder: (_, __) => HomePage(),
      ),
    ],
  ),
);
