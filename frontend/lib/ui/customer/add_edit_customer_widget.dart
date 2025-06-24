import 'package:flutter/material.dart';
import 'package:frontend/_providers/booking_provider.dart';
import 'package:provider/provider.dart';

import '/_providers/customer_provider.dart';
import '/domains/customer_dto.dart';
import '/ui/ErrorMessage.dart';
import '../../_providers/payment_provider.dart';

class AddEditCustomerWidget extends StatefulWidget {
  const AddEditCustomerWidget({super.key});

  @override
  State<AddEditCustomerWidget> createState() => _AddEditCustomerWidgetState();
}

class _AddEditCustomerWidgetState extends State<AddEditCustomerWidget> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cnicController = TextEditingController();
  final _phoneNoController = TextEditingController();
  final _localeController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _cnicController.dispose();
    _phoneNoController.dispose();
    _localeController.dispose();
    super.dispose();
  }

  void _clear() {
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _cnicController.clear();
    _phoneNoController.clear();
    _localeController.clear();
    Provider.of<CustomerProvider>(context, listen: false)
        .setSelectedCustomer(null);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final customerData = CustomerDTO(
        id: '',
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        cnic: _cnicController.text,
        phoneNumber: _phoneNoController.text,
      );
      final provider = Provider.of<CustomerProvider>(context, listen: false);
      if (provider.selectedCustomer == null) {
        provider.addCustomer(customerData);
      } else {
        customerData.id = provider.selectedCustomer!.id;
             provider.updateCustomer(customerData.id, customerData);
        showInfoMessage(
            context, "Customer ${customerData.firstName} has been Updated.");
      }
      _clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerProvider>(builder: (ctx, provider, child) {
        final customer = provider.selectedCustomer;
        if (customer != null) {
          _firstNameController.text = customer.firstName;
          _lastNameController.text = customer.lastName;
          _emailController.text = customer.email;
          _cnicController.text = customer.cnic;
          _phoneNoController.text = customer.phoneNumber ?? '';
          Provider.of<PaymentProvider>(context, listen: false).fetchPaymentsByCustomer(customer.id);
          Provider.of<BookingProvider>(context, listen: false).fetchBookingsByCustomerId(customer.id);
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter first name' : null,
                ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter last name' : null,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) => value!.isEmpty || !value.contains('@')
                      ? 'Please enter a valid email'
                      : null,
                ),
                TextFormField(
                  controller: _cnicController,
                  decoration: const InputDecoration(labelText: 'CNIC'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter cnic' : null,
                ),
                TextFormField(
                  controller: _phoneNoController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter phone no.' : null,
                ),
                const SizedBox(height: 10),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                        onPressed: _submitForm,
                        child: Text(customer == null
                            ? 'Add Customer'
                            : 'Update Customer'),
                      ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _clear,
                      child: const Text('Clear'),
                    ),
                  ]
                ),
                if (provider.errorMessage != null)
                  showErrorMessage(context, provider.errorMessage),
              ],
            ),
          ),
        );
      });
  }
}
