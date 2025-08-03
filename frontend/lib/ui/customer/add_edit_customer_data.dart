import 'package:flutter/material.dart';
import 'package:frontend/_providers/customer_provider.dart';
import 'package:frontend/ui/address/add_edit_address_screen.dart';
import 'package:frontend/ui/customer/add_edit_customer_widget.dart';
import 'package:provider/provider.dart';

class AddEditCustomerData extends StatefulWidget {
  const AddEditCustomerData({super.key});

  @override
  State<AddEditCustomerData> createState() => _AddEditCustomerDataState();
}

class _AddEditCustomerDataState extends State<AddEditCustomerData> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Expanded(child: AddEditCustomerWidget(),),
            Expanded(child: Selector<CustomerProvider, String?>(
              selector: (_, provider) => provider.selectedCustomer?.id,
              builder: (ctx, customerId, child) {
                return AddressScreen(customerId: customerId);
              }),
            ),
          ],
        ),
      );
  }
}