import 'package:flutter/material.dart';
import '/_services/auth_service.dart';
import '/ui/dashboard/dashboard_page.dart';
import '/ui/login/login_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AuthService _authService = AuthService();
  bool? isValid;

  @override
  void initState() {
    super.initState();
    _authService.isTokenValid().then((value) => {
          setState(() {
            isValid = value;
          }),
        });
  }

  @override
  Widget build(BuildContext context) {
    if (isValid == null)
      return const Center(child: CircularProgressIndicator());
    if (isValid!)
      return DashboardScreen();
    else
      return const LoginPage();
  }
}
