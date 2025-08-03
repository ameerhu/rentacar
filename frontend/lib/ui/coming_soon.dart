import 'package:flutter/material.dart';
import 'package:frontend/ui/base_page.dart';

class ComingSoon extends StatefulWidget {
  const ComingSoon({super.key});

  @override
  State<ComingSoon> createState() => _ComingSoonState();
}

class _ComingSoonState extends State<ComingSoon> {
  final title = 'Coming Soon';
  final Duration delay = const Duration(milliseconds: 150);
  String displayText = "";

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() async {
    while(mounted) {
      for (int i = 0; i <= title.length; i++) {
        Future.delayed(delay * i, () {
          if (mounted) {
            setState(() => displayText = title.substring(0, i));
          }
        });
      }
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() => displayText = "");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: title,
      body: Center(
        child: Text(
          displayText, 
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 48, 
            fontWeight: FontWeight.bold, 
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}