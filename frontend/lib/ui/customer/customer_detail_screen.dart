import 'package:flutter/material.dart';
import 'package:frontend/_providers/customer_provider.dart';
import 'package:frontend/domains/address_dto.dart';
import 'package:frontend/domains/customer_dto.dart';
import 'package:frontend/ui/customer/add_edit_customer_data.dart';
import 'package:provider/provider.dart';

class CustomerDetailScreen extends StatelessWidget {
  final CustomerDTO customer;
  final AddressDTO? address;
  const CustomerDetailScreen({super.key, required this.customer, this.address});

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);
    customerProvider.setSelectedCustomer(customer);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Customer'),
                  content: const Text(
                      'Are you sure you want to delete this customer?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        customerProvider.deleteCustomer(customer.id)
                          .then((value) => Navigator.popUntil(context, (route) => route.isFirst));
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
      body: const AddEditCustomerData(),
    );
  }
}
