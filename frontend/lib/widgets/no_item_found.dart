import 'package:flutter/material.dart';
import 'package:frontend/widgets/no_item.dart';

class NoItemFound extends StatelessWidget {
  final String? itemName;
  final IconData? itemIcon;
  const NoItemFound({super.key , this.itemName, this.itemIcon});

  @override
  Widget build(BuildContext context) {
    return NoItem(itemName: itemName ?? 'Item Not Found.', itemIcon: itemIcon?? Icons.hourglass_empty,);
  }
}