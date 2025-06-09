import 'package:flutter/material.dart';

class TileHeader extends StatelessWidget {
  final String title;
  const TileHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return 
      Text(title,
            style: 
              const TextStyle(
                fontSize: 14, 
                fontWeight: FontWeight.bold,
              ),
            textAlign: TextAlign.center,
          );
  }
}