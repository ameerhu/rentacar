import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/ui/address/add_edit_address_screen.dart';

import '/ui/customer/add_edit_customer_screen.dart';
import '/ui/customer/customer_list.dart';
import '../../_providers/customer_provider.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<CustomerProvider>(context, listen: false).fetchCustomers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Customers')),
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
                const Text("Add Edit Customer"),
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushReplacementNamed(context, "/customer/add");
        },
      ),
    );
  }
}
