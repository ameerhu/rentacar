import 'package:flutter/material.dart';
import 'package:frontend/widgets/rac_app_bar.dart';

class BasePage extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;
  final List<Widget>? actions;

  const BasePage({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RacAppBar(title: title, actions: actions),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: body,
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
