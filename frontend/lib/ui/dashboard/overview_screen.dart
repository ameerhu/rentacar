import 'package:flutter/material.dart';
import 'package:frontend/_providers/payment_provider.dart';
import 'package:frontend/domains/customer_dto.dart';
import 'package:frontend/ui/booking/booking_list.dart';
import 'package:frontend/ui/booking/booking_screen.dart';
import 'package:frontend/ui/customer/add_edit_customer_widget.dart';
import 'package:frontend/ui/payment/payment_list_page.dart';
import 'package:frontend/ui/payment/payment_screen.dart';
import 'package:frontend/widgets/tile_header.dart';
import 'package:provider/provider.dart';
import '../../_providers/address_provider.dart';
import '../ErrorMessage.dart';
import '/ui/address/add_edit_address_screen.dart';

import '/ui/customer/customer_list.dart';
import '../../_providers/customer_provider.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  late CustomerDTO selectedCustomer;
  @override
  void initState() {
    super.initState();
    Future.microtask(() => {
      Provider.of<CustomerProvider>(context, listen: false).fetchCustomers(),
      Provider.of<PaymentProvider>(context, listen: false).fetchPendingPayments(),
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
          SizedBox(
            width: 300,
            child: Column(
              children: [
                Expanded(child: CustomerListScreen(
                  onTapCallBack: (customer) => {
                    Provider.of<CustomerProvider>(context, listen: false)
                      .setSelectedCustomer(customer),
                    Provider.of<AddressProvider>(context, listen: false)
                      .setCustomerId(customer.id),
                  }),
                ),
              ],
            ),
          ),
          const VerticalDivider(
            color: Colors.deepOrange,
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 5/4.2,
              shrinkWrap: true,
              children: [
                const Card(
                  child: GridTile(
                    header: TileHeader(title: "Add or Edit Customer"),
                    child: AddEditCustomerWidget(),
                  ),
                ), 
                GridTile(
                  header: const TileHeader(title:"Add or Edit Customer Address"),
                  child: Consumer<CustomerProvider>(builder: (ctx, provider, child) {
                    return AddressScreen(customerId: provider.selectedCustomer?.id);
                  }),
                ),
                GridTile(
                  header: const TileHeader(title:"Booking History"),
                  child: Consumer<CustomerProvider>(builder: (ctx, provider, child) {
                    return BookingListPage(customer: provider.selectedCustomer);
                  }),
                ),
                Card(
                  child: GridTile(
                    header: const TileHeader(title:"Payment History"),
                    child: Consumer<CustomerProvider>(builder: (ctx, provider, child) {
                      return PaymentListPage(customer: provider.selectedCustomer);
                    }),
                  ),
                ),
            ]),
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
                      Expanded(
                        child: ListView.builder(
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
