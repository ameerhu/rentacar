import 'package:flutter/material.dart';
import 'package:frontend/_providers/address_provider.dart';
import 'package:frontend/ui/customer/customer_detail_screen.dart';
import 'package:provider/provider.dart';

import '/ui/customer/customer_list.dart';
import '../../_providers/customer_provider.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  late AddressProvider addressProvider;
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<CustomerProvider>(context, listen: false).fetchCustomers());
    addressProvider = Provider.of<AddressProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Customers')),
      body: CustomerListScreen(onTapCallBack: (customer) => {
        addressProvider.setCustomerId(customer.id),
        Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => CustomerDetailScreen(customer: customer, address: addressProvider.customerAddress),
          ),
        ),
      }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Provider.of<CustomerProvider>(context, listen: false).setSelectedCustomer(null);
          Navigator.pushReplacementNamed(context, "/customer/add");
        },
      ),
    );
  }
}