import 'package:flutter/material.dart';
import 'package:frontend/widgets/no_item.dart';

class NoVehicleFound extends StatelessWidget {
  const NoVehicleFound({super.key});

  @override
  Widget build(BuildContext context) {
    return const NoItem(itemName: 'No Vehicle Found.', itemIcon: Icons.directions_car,);
  }
}