import 'package:flutter/material.dart';
import 'package:frontend/domains/customer_dto.dart';
import 'package:frontend/widgets/no_item_found.dart';
import 'package:frontend/widgets/responsive_list_view.dart';
import 'package:provider/provider.dart';

import '../../_providers/customer_provider.dart';

class CustomerListScreen extends StatefulWidget {
  final Function(CustomerDTO customer)? callBack;
  final Function(CustomerDTO customer)? onTap;
  const CustomerListScreen({super.key, this.callBack, this.onTap});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Search Customer',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.search),
            ),
            onChanged: (s) => setState((){}),
          ),
        ),
        Consumer<CustomerProvider>(
          builder: (context, customerProvider, child) {
            final customers = customerProvider.customers.where((c) => c.firstName.toLowerCase().contains(_searchController.text.toLowerCase())).toList();
            if (customerProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Expanded(
              child: ResponsiveListView(
                emptyWidget: const NoItemFound(itemName: 'No Customer Found.', itemIcon: Icons.person,),
                items: customers, 
                itemBuilder: (context, customer) {
                  return ListTile(
                    leading: const Icon(Icons.person,),
                    title: Text('Name: ${customer.firstName}'),
                    subtitle: Text('CNIC: ${customer.cnic}'),
                    selected: customer.cnic == customerProvider.selectedCustomer?.cnic,
                    selectedTileColor: Theme.of(context).colorScheme.inversePrimary,
                    trailing: widget.callBack == null ? null : IconButton(
                      icon: const Icon(Icons.edit), 
                      onPressed: () => widget.callBack!(customer),
                    ),
                    onTap: widget.onTap == null ? null : () => widget.onTap!(customer),
                  );
              }),
            );
          },
        ),
      ],
    );
  }
}
