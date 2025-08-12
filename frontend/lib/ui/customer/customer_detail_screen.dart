import 'package:flutter/material.dart';
import 'package:frontend/_providers/customer_provider.dart';
import 'package:frontend/config/rac_routes.dart';
import 'package:frontend/domains/address_dto.dart';
import 'package:frontend/domains/customer_dto.dart';
import 'package:frontend/ui/base_page.dart';
import 'package:frontend/ui/customer/customer_detail_view.dart';
import 'package:provider/provider.dart';

class CustomerDetailScreen extends StatefulWidget {
  final CustomerDTO customer;
  final AddressDTO? address;
  const CustomerDetailScreen({super.key, required this.customer, this.address});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  String routeTo = RacRoutes.customerAdd;
  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);

    return BasePage(
      title: 'Customer Details',
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
                      customerProvider.deleteCustomer(widget.customer.id)
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
      body: Column(
        children: [
          Text('Name: ${widget.customer.firstName}, CNIC: ${widget.customer.cnic}'),
          Expanded(child: CustomerDetailView(onTabChange: (rt) => setState(() => routeTo = rt ))),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Provider.of<CustomerProvider>(context, listen: false).setSelectedCustomer(null);
          Navigator.pushReplacementNamed(context, routeTo);
        },
      ),
    );
  }
}
