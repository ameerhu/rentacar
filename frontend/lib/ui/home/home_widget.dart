import 'package:flutter/material.dart';
import 'package:frontend/_providers/auth_provider.dart';
import 'package:provider/provider.dart';
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
  final AuthService _authService = AuthService();
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
    return Consumer<AuthProvider>(builder: (ctx, provider, child) {
      return provider.isAuthenticated == null 
      ? const Center(child: CircularProgressIndicator())
      : provider.isAuthenticated! ? 
      const DashboardScreen() : const LoginPage();
    },);
  }
}
