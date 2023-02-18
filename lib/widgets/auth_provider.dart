import 'package:flutter/material.dart';
import 'package:campus_plus/controller/auth_controller.dart';

class AuthProvider extends InheritedWidget {
  const AuthProvider({required Key key, required Widget child, required this.auth}) : super(key: key, child: child);
  final AuthController auth;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static AuthProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AuthProvider>();
  }
}