import 'package:flutter/material.dart';
import 'package:frontend/domains/customer_dto.dart';
import 'package:provider/provider.dart';

import '../../_providers/customer_provider.dart';

class CustomerListScreen extends StatefulWidget {
  final Function(CustomerDTO customer) onTapCallBack;
  const CustomerListScreen({super.key, required this.onTapCallBack});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
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
            return Card(
              child: ListTile(
                title: Text(customer.firstName),
                subtitle: Text(customer.cnic),
                tileColor: customer == customerProvider.selectedCustomer
                    ? Theme.of(context).colorScheme.inversePrimary
                    : Colors.transparent,
                onTap: () => widget.onTapCallBack(customer),
              ),
            );
          },
        );
      },
    );
  }
}
