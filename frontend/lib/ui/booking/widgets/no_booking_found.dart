import 'package:flutter/material.dart';
import 'package:frontend/widgets/no_item_found.dart';

class NoBookingFound extends StatelessWidget {
  const NoBookingFound({super.key});

  @override
  Widget build(BuildContext context) {
    return const NoItemFound(itemName: 'No Booking Found.', itemIcon: Icons.book,);
  }
}