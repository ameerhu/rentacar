import 'package:flutter/material.dart';
import 'package:frontend/_providers/payment_provider.dart';
import 'package:provider/provider.dart';
import '../ErrorMessage.dart';
import '/ui/address/add_edit_address_screen.dart';

import '/ui/customer/add_edit_customer_screen.dart';
import '/ui/customer/customer_list.dart';
import '../../_providers/customer_provider.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => {
      Provider.of<CustomerProvider>(context, listen: false).fetchCustomers(),
      Provider.of<PaymentProvider>(context, listen: false).fetchPendingPayments()
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Overview')),
      body: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 300,
            child: Column(
              children: [
                Expanded(child: CustomerListScreen()),
              ],
            ),
          ),
          const VerticalDivider(
            color: Colors.deepOrange,
          ),
          SizedBox(
            width: 400,
            child: Column(
              children: [
                const Text("Add or Edit Customer"),
                Expanded(child: Consumer<CustomerProvider>(
                  builder: (ctx, provider, child) {
                    return AddEditCustomerScreen(
                        customerDTO: provider.selectedCustomer);
                  },
                )),
              ],
            ),
          ),
          SizedBox(
            width: 400,
            child: Column(
              children: [
                const Text("Add or Edit Customer Address"),
                Expanded(
                  child: Consumer<CustomerProvider>(
                      builder: (ctx, provider, child) {
                    return AddressScreen(
                        customerId: provider.selectedCustomer?.id);
                  }),
                ),
              ],
            ),
          ),
          const VerticalDivider(
            color: Colors.deepOrange,
          ),
          SizedBox(
            width: 400,
            child: Consumer<PaymentProvider>(
              builder: (context, paymentProvider, child) {
                if (paymentProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (paymentProvider.errorMessage != null) {
                  return showErrorMessage(
                      context, paymentProvider.errorMessage);
                } else if (paymentProvider.pendingPayments.isEmpty) {
                  return const Center(child: Text("No pending payments found."));
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Pending Payments',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const Divider(thickness: 2),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: paymentProvider.pendingPayments.length,
                        itemBuilder: (context, index) {
                          final payment = paymentProvider.pendingPayments[index];
                          return Card(
                            elevation: 2,
                            child: ListTile(
                              title: Text("Name: ${payment.customerName}"), 
                              subtitle: Text("Amount: ${payment.remainingBalance}"),
                              onTap: ()=>{},
                            ),
                          );
                        },
                        ),
                    ],
                  );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
