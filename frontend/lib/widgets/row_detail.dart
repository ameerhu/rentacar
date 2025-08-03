import 'package:flutter/material.dart';

class RowDetail extends StatelessWidget {
  final String label;
  final String value;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  const RowDetail(
    this.label, 
    this.value, 
    {
      super.key, 
      this.mainAxisAlignment = MainAxisAlignment.spaceBetween, 
      this.crossAxisAlignment = CrossAxisAlignment.start
    }
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value),
      ],
    );
  }
}