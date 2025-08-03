import 'package:flutter/material.dart';

class TextBold extends StatelessWidget {
  final String text;
  const TextBold({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontWeight: FontWeight.bold),);
  }
}