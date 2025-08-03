import 'package:flutter/material.dart';

class TileDetail extends StatelessWidget {
  final Widget child;
  final Widget? title;
  final Widget? trailing;
  final Function()? onTap;
  const TileDetail({super.key, this.title, required this.child, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      trailing: trailing,
      onTap: onTap,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: child)
            ],
          ),
        ],
      ),
    );
  }
}