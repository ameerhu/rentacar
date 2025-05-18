import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/_providers/customer_provider.dart';
import '/domains/customer_dto.dart';

import '../../_providers/payment_provider.dart';
import '../../domains/inbound/payment_dto_in.dart';
import '../../domains/payment_dto.dart';

class AddEditPaymentPage extends StatefulWidget {
  final PaymentDTO? payment;

  const AddEditPaymentPage({super.key, this.payment});

  @override
  State<StatefulWidget> createState() => _AddEditPaymentPageState();
}

class _AddEditPaymentPageState extends State<AddEditPaymentPage> {
  List<CustomerDTO> _customers = [];
  final _formKey = GlobalKey<FormState>();
  final _customerIdController = TextEditingController();
  final _totalAmountController = TextEditingController();
  final _paymentMethodController = TextEditingController();

  @override
  void dispose() {
    _customerIdController.dispose();
    _totalAmountController.dispose();
    _paymentMethodController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
    var pmt = widget.payment;
    if (pmt != null) {
      _customerIdController.text = pmt.customerId!;
      _totalAmountController.text = pmt.totalAmount!.toString();
      _paymentMethodController.text = pmt.paymentMethod!;
    }
  }

  Future<void> _fetchData() async {
    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);
    await customerProvider.fetchCustomers();
    setState(() {
      _customers = customerProvider.customers;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final payment = PaymentDTOIn(
        customerId: _customerIdController.text,
        totalAmount: double.tryParse(_totalAmountController.text),
        paymentMethod: _paymentMethodController.text,
      );

      final paymentProvider =
          Provider.of<PaymentProvider>(context, listen: false);
      paymentProvider.addPayment(payment);
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Add Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Autocomplete<CustomerDTO>(
                optionsBuilder: (TextEditingValue tev) {
                  if (tev.text.isEmpty) return const Iterable.empty();
                  return _customers.where((c) {
                    return c.cnic.contains(tev.text);
                  });
                },
                displayStringForOption: (option) =>
                    '${option.cnic} - ${option.firstName}',
                onSelected: (customer) {
                  setState(() {
                    _customerIdController.text = customer.cnic;
                  });
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                  controller.addListener(() {
                    if (_customerIdController.text != controller.text)
                      _customerIdController.text = controller.text;
                  });
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      labelText: 'Customer CNIC',
                      suffixIcon: Icon(Icons.search),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter customer ID' : null,
                  );
                },
              ),
              TextFormField(
                controller: _totalAmountController,
                decoration: const InputDecoration(labelText: 'Total Amount'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter total amount' : null,
              ),
              TextFormField(
                controller: _paymentMethodController,
                decoration: const InputDecoration(labelText: 'Payment Method'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter payment method' : null,
              ),
              const SizedBox(height: 20),
              paymentProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Add Payment'),
                    ),
              if (paymentProvider.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    paymentProvider.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
