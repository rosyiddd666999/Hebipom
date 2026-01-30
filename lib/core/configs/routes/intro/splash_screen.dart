import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      context.go(RouteNames.habit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          Theme.of(context).brightness == Brightness.light
              ? 'assets/images/logo_dark.png'
              : 'assets/images/logo_light.png',
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}
