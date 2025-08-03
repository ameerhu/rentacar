import 'package:flutter/material.dart';
import 'package:frontend/ui/base_page.dart';

import 'payment_list_page.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Payments',
      body: const PaymentListPage(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushReplacementNamed(context, "/payment/add");
        },
      ),
    );
  }
}
