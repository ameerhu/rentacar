import 'package:flutter/material.dart';
import 'package:frontend/_providers/customer_provider.dart';
import 'package:frontend/domains/address_dto.dart';
import 'package:frontend/domains/customer_dto.dart';
import 'package:frontend/ui/address/add_edit_address_screen.dart';
import 'package:frontend/ui/customer/add_edit_customer_widget.dart';
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
                        customerProvider.deleteCustomer(customer.id!).then(
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
        child: Column(
          children: [
            /* _buildDetailRow('ID', customer.id),
            _buildDetailRow('First Name', customer.firstName),
            _buildDetailRow('Last Name', customer.lastName),
            _buildDetailRow('CNIC', customer.cnic),
            _buildDetailRow('Email', customer.email),
            _buildDetailRow('Phone no.', customer.phoneNumber ?? 'N/A'),
            _buildDetailRow('Timezone', customer.timezone ?? 'N/A'),
            _buildDetailRow('Locale', customer.locale ?? 'N/A'), */

            /* if(address != null) ...[
              _buildDetailRow('Address ID', address!.id ?? 'N/A'),
              _buildDetailRow('City', address!.city ?? 'N/A'),
              _buildDetailRow('Street', address!.street ?? 'N/A'),
              _buildDetailRow('Postal Code', address!.postalCode.toString()),
              _buildDetailRow('Country', address!.country ?? 'N/A'),
            ], */
            Expanded(child: Consumer<CustomerProvider>(
                  builder: (ctx, provider, child) {
                    return const AddEditCustomerWidget();
                  },
                )),
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
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
