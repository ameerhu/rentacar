import 'package:flutter/material.dart';
import 'package:frontend/domains/customer_dto.dart';
import 'package:frontend/util/date_time_util.dart';
import 'package:frontend/util/rac_text_style.dart';
import 'package:frontend/widgets/no_item_found.dart';
import 'package:frontend/widgets/responsive_list_view.dart';
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
    final payments = widget.customer == null
        ? paymentProvider.payments
        : paymentProvider.customerPayments;

    return paymentProvider.isLoading
        ? const Center(child: CircularProgressIndicator())
        : paymentProvider.errorMessage != null
            ? Center(child: Text('Error: ${paymentProvider.errorMessage}'))
            : ResponsiveListView(
                emptyWidget: const NoItemFound(itemName: 'No Payment Found.', itemIcon: Icons.payment,),
                items: payments, 
                itemBuilder: (context, payment) {
                  return ListTile(
                    title: Text(
                      'Payment ID: ${payment.id!.substring(0, 8)}',
                      style: RacTextStyle.tileSubHeader,
                    ),
                    trailing:
                        payment.paymentMethod!.toLowerCase() == 'card'
                            ? const Icon(Icons.payment)
                            : const Icon(Icons.payments),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PaymentDetailScreen(payment: payment),
                        ),
                      );
                    },
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Amount: ${payment.totalAmount}'),
                        Text('Date: ${DateTimeUtil.format(payment.paymentDate!)}')
                      ],
                    ),
                  );
              });
  }
}
