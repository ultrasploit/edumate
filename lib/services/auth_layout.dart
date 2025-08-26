import 'package:edumate/screens/home_screen.dart';
import 'package:edumate/screens/signin_screen.dart';
import 'package:edumate/services/auth_service.dart';
import 'package:flutter/material.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    this.pageIfNotConnected
  });

  final Widget? pageIfNotConnected;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, authService, child) {
        return StreamBuilder(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            Widget widget;
            if (snapshot.connectionState == ConnectionState.waiting) {
              widget = CircularProgressIndicator.adaptive();

            } else if (snapshot.hasData) {
              widget = const HomeScreen();

            } else {
              widget = SignInScreen();
            }
            
            return widget;
          },
        );
      }
    );
  }
}