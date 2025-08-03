import 'package:flutter/material.dart';
import 'package:frontend/widgets/no_item.dart';

class NoItemSelected extends StatelessWidget {
  final String? itemName;
  final IconData? itemIcon;
  const NoItemSelected({super.key , this.itemName, this.itemIcon});

  @override
  Widget build(BuildContext context) {
    return const NoItem(itemName: 'Please select a customer for details.', itemIcon: Icons.person,);
  }
}