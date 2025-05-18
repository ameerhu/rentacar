import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../_providers/address_provider.dart';
import '../../domains/address_dto.dart';
import '../../domains/inbound/address_dto_in.dart';

class AddressScreen extends StatefulWidget {
  String? customerId;
  late AddressDTO addressDTO;

  AddressScreen({super.key, this.customerId});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController cityController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  void saveAddress(BuildContext context) {
    final provider = Provider.of<AddressProvider>(context, listen: false);

    AddressDTOIn newAddress = AddressDTOIn(
      city: cityController.text,
      street: streetController.text,
      state: stateController.text,
      postalCode: int.parse(postalCodeController.text),
      country: countryController.text,
    );

    provider.addAddress(widget.customerId!, newAddress);
  }

  @override
  void dispose() {
    cityController.dispose();
    streetController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
    countryController.dispose();
    super.dispose();
  }

  void _clear() {
    cityController.clear();
    streetController.clear();
    stateController.clear();
    postalCodeController.clear();
    countryController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressProvider>(
      builder: (context, provider, child) {
        if (provider.customerAddress == null) {
          _clear();
        } else {
          cityController.text = provider.customerAddress!.city ?? '';
          streetController.text = provider.customerAddress!.street ?? '';
          stateController.text = provider.customerAddress!.state ?? '';
          postalCodeController.text =
              provider.customerAddress!.postalCode.toString() ?? '';
          countryController.text = provider.customerAddress!.country ?? '';
        }
        return Column(
          children: [
            /*Expanded(
              child: ListView.builder(
                itemCount: provider.addresses.length,
                itemBuilder: (context, index) {
                  AddressDTOIn address = provider.addresses[index];
                  return ListTile(
                    title: Text("${address.street}, ${address.city}"),
                    subtitle: Text("${address.state}, ${address.country}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () =>
                          provider.removeAddress(address.postalCode),
                    ),
                  );
                },
              ),
            ),*/

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                      controller: cityController,
                      decoration: const InputDecoration(labelText: "City")),
                  TextField(
                      controller: streetController,
                      decoration: const InputDecoration(labelText: "Street")),
                  TextField(
                      controller: stateController,
                      decoration: const InputDecoration(labelText: "State")),
                  TextField(
                      controller: postalCodeController,
                      decoration:
                          const InputDecoration(labelText: "Postal Code"),
                      keyboardType: TextInputType.number),
                  TextField(
                      controller: countryController,
                      decoration: const InputDecoration(labelText: "Country")),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => saveAddress(context),
                    child: const Text("Add Address"),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
