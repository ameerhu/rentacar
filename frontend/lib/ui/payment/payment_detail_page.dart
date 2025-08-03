import 'package:flutter/material.dart';
import 'package:frontend/util/date_time_util.dart';
import 'package:provider/provider.dart';

import '/_providers/payment_provider.dart';
import '../../domains/payment_dto.dart';

class PaymentDetailScreen extends StatelessWidget {
  final PaymentDTO payment;

  const PaymentDetailScreen({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Payment'),
                  content: const Text(
                      'Are you sure you want to delete this payment?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        paymentProvider.deletePayment(payment.id!).then(
                            (value) => Navigator.popUntil(
                                context, (route) => route.isFirst));
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailRow('ID', payment.id ?? 'N/A'),
            _buildDetailRow('Customer ID', payment.customerId ?? 'N/A'),
            _buildDetailRow(
                'Total Amount', payment.totalAmount?.toString() ?? 'N/A'),
            _buildDetailRow('Payment Method', payment.paymentMethod ?? 'N/A'),
            _buildDetailRow(
                'Overpaid Amount', payment.overpaidAmount.toString()),
            _buildDetailRow('Payment Date',
                DateTimeUtil.format(payment.paymentDate!.toLocal())),
            _buildDetailRow('Payment Status',
                payment.paymentStatus.toString().split('.').last),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
