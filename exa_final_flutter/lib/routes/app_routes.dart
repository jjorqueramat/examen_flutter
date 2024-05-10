import 'package:exa_final_flutter/screen/error_screen.dart';
import 'package:exa_final_flutter/screen/login_screen.dart';
import 'package:exa_final_flutter/screen/principal.dart';
import 'package:exa_final_flutter/screen/register_user_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const initialRoute = 'login';
  static Map<String, Widget Function(BuildContext)> routes = {
    'login': (BuildContext context) => const LoginScreen(),
    'list': (BuildContext context) => const PrincipalPage(),
    'add_user': (BuildContext context) => const RegisterUserScreen(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const ErrorScreen(),
    );
  }
}
