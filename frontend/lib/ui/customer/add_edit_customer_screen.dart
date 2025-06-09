import 'package:flutter/material.dart';
import 'package:frontend/ui/customer/add_edit_customer_widget.dart';
import '/domains/customer_dto.dart';

class AddEditCustomerScreen extends StatefulWidget {
  final CustomerDTO? customerDTO;

  const AddEditCustomerScreen({super.key, this.customerDTO});

  @override
  State<AddEditCustomerScreen> createState() => _AddEditCustomerScreenState();
}

class _AddEditCustomerScreenState extends State<AddEditCustomerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customerDTO == null ? 'Add Customer' : 'Edit Customer'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const AddEditCustomerWidget(),
    );
  }
}
