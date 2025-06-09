import 'package:flutter/material.dart';
import 'package:frontend/domains/customer_dto.dart';
import 'package:provider/provider.dart';

import '../../_providers/payment_provider.dart';
import 'payment_detail_page.dart';

class PaymentListPage extends StatefulWidget {
  final CustomerDTO? customer;
  const PaymentListPage({super.key, this.customer});

  @override
  State<StatefulWidget> createState() => _PaymentListPageState();
}

class _PaymentListPageState extends State<PaymentListPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<PaymentProvider>(context, listen: false).fetchPayments();
  }

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentProvider>(context);
    final payments = widget.customer == null ? paymentProvider.payments : paymentProvider.customerPayments;

    return paymentProvider.isLoading
        ? const Center(child: CircularProgressIndicator())
        : paymentProvider.errorMessage != null
            ? Center(child: Text('Error: ${paymentProvider.errorMessage}'))
            : ListView.builder(
                itemCount: payments.length,
                itemBuilder: (context, index) {
                  final payment = payments[index];
                  return ListTile(
                    title: Text('Payment ID: ${payment.id!.substring(0, 8)}'),
                    subtitle: Text('Amount: ${payment.totalAmount}'),
                    trailing: const Icon(Icons.payment),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PaymentDetailScreen(payment: payment),
                        ),
                      );
                    },
                  );
                },
              );
  }
}
