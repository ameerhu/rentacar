import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/_providers/address_provider.dart';

import '../../_providers/customer_provider.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  _CustomerListScreenState createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerProvider>(
      builder: (context, customerProvider, child) {
        if (customerProvider.customers.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: customerProvider.customers.length,
          itemBuilder: (context, index) {
            final customer = customerProvider.customers[index];
            return ListTile(
              title: Text(customer.firstName),
              subtitle: Text(customer.cnic),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  customerProvider.deleteCustomer(customer.id);
                },
              ),
              tileColor: customer == customerProvider.selectedCustomer
                  ? Theme.of(context).colorScheme.inversePrimary
                  : Colors.transparent,
              onTap: () => {
                Provider.of<CustomerProvider>(context, listen: false)
                    .setSelectedCustomer(customer),
                Provider.of<AddressProvider>(context, listen: false)
                    .setCustomerId(customer.id),
              },
            );
          },
        );
      },
    );
  }
}
