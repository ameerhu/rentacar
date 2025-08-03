import 'dart:math';

import 'package:flutter/material.dart';

class NoItem extends StatelessWidget {
  final String? itemName;
  final IconData? itemIcon;
  final Icon? icon;
  final Text? text;
  const NoItem({super.key , this.itemName, this.itemIcon, this.icon, this.text});

  @override
  Widget build(BuildContext context) {
    var no = Random().nextInt(Colors.primaries.length);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon ?? Icon(itemIcon ?? Icons.cancel, size: 250, color: Colors.primaries[no],),
          text ?? Text(itemName ?? 'No Item',
            style: TextStyle(fontSize: 18, color: Colors.primaries[no]),
          ),
        ],
      ),
    );
  }
}