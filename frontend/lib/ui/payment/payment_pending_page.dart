import 'package:flutter/material.dart';
import 'package:frontend/_providers/payment_provider.dart';
import 'package:frontend/domains/customer_dto.dart';
import 'package:frontend/domains/pending_payment_dto.dart';
import 'package:frontend/ui/ErrorMessage.dart';
import 'package:frontend/widgets/no_item_found.dart';
import 'package:frontend/widgets/responsive_list_view.dart';
import 'package:provider/provider.dart';

class PaymentPendingPage extends StatefulWidget {
  final CustomerDTO? customer;
  const PaymentPendingPage({super.key, this.customer});

  @override
  State<PaymentPendingPage> createState() => _PaymentPendingPageState();
}

class _PaymentPendingPageState extends State<PaymentPendingPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => {
      Provider.of<PaymentProvider>(context, listen: false).fetchPendingPayments(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentProvider>(
      builder: (context, paymentProvider, child) {
        if (paymentProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (paymentProvider.errorMessage != null) {
          return showErrorMessage(context, paymentProvider.errorMessage);
        } else {
          var pp = widget.customer == null 
            ? paymentProvider.pendingPayments 
            : paymentProvider.pendingPayments.where((PendingPaymentDTO p) => p.customerId == widget.customer?.id).toList();
          return ResponsiveListView(
            emptyWidget: const NoItemFound(itemName: 'No Pending Payment Found.', itemIcon: Icons.payments,),
            items: pp, 
            itemBuilder: (context, payment) => 
              ListTile(
                title: Text("Name: ${payment.customerName}"),
                subtitle: Text("Amount: ${payment.remainingBalance}"),
                onTap: () => {},
              ),
          );
        }
      }
    );
  }
}