import 'package:dd_study_22_ui/ui/roots/app.dart';
import 'package:dd_study_22_ui/ui/roots/auth.dart';
import 'package:dd_study_22_ui/ui/roots/loader.dart';
import 'package:dd_study_22_ui/ui/roots/register.dart';
import 'package:dd_study_22_ui/ui/roots/settings.dart';
import 'package:flutter/material.dart';

class NavigationRoutes {
  static const loaderWidget = "/";
  static const auth = "/auth";
  static const app = "/app";
  static const profile = "/profile";
  static const userSettings = "/settings";
  static const register = "/register";
  static const postCreator = "/postCreator";
}

class AppNavigator {
  static final key = GlobalKey<NavigatorState>();

  static Future toLoader() async {
    return key.currentState?.pushNamedAndRemoveUntil(
        NavigationRoutes.loaderWidget, ((route) => false));
  }

  static Future toAuth() async {
    return await key.currentState
        ?.pushNamedAndRemoveUntil(NavigationRoutes.auth, ((route) => false));
  }

  static Future toRegister() async {
    return await key.currentState?.pushNamedAndRemoveUntil(
        NavigationRoutes.register, ((route) => false));
  }

  static Future toHome() async {
    return await key.currentState
        ?.pushNamedAndRemoveUntil(NavigationRoutes.app, ((route) => false));
  }

  static Future toProfile() async {
    return await key.currentState?.pushNamed(NavigationRoutes.profile);
  }

  static Future toPostCreator() async {
    return await key.currentState?.pushNamed(NavigationRoutes.postCreator);
  }

  static Future toSettings() async {
    return await key.currentState?.pushNamed(NavigationRoutes.userSettings);
  }

  static Route<dynamic>? onGeneratedRoutes(RouteSettings settings, context) {
    switch (settings.name) {
      case NavigationRoutes.loaderWidget:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => LoaderWidget.create()));
      case NavigationRoutes.auth:
        return PageRouteBuilder(pageBuilder: ((_, __, ___) => Auth.create()));
      case NavigationRoutes.app:
        return PageRouteBuilder(pageBuilder: ((_, __, ___) => App.create()));
      case NavigationRoutes.userSettings:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => Settings.create()));
      case NavigationRoutes.register:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => Register.create()));
    }
    return null;
  }
}
