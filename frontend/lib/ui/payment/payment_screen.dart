import 'package:flutter/material.dart';

import '/ui/payment/add_edit_payment_page.dart';
import 'payment_list_page.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Payments')),
      body: const Row(
        children: [
          SizedBox(
            width: 400,
            height: 700,
            child: PaymentListPage(),
          ),
          SizedBox(
            width: 400,
            height: 700,
            child: AddEditPaymentPage(),
          ),
        ],
      ),
    );
  }
}
