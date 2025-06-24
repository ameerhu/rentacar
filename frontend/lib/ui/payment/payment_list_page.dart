import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
            : LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: StaggeredGrid.count(
                      crossAxisCount: constraints.maxWidth < 500 ? 1 : constraints.maxWidth < 800 ? 2 : 4,
                      children: payments.map((payment) => 
                        Card(
                          child: ListTile(
                            title: Text('Payment ID: ${payment.id!.substring(0, 8)}'),
                            subtitle: Text('Amount: ${payment.totalAmount}'),
                            trailing: payment.paymentMethod!.toLowerCase() == 'cash' ? const Icon(Icons.payment) : const Icon(Icons.payments),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PaymentDetailScreen(payment: payment),
                                ),
                              );
                            },
                          ),
                        ),
                      ).toList(),
                    ),
                  );
                }
            );
  }
}
