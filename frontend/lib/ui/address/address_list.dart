import 'package:flutter/material.dart';
import 'package:frontend/domains/address_dto.dart';
import 'package:provider/provider.dart';
import '/_providers/address_provider.dart';

class AddressListScreen extends StatefulWidget {
  const AddressListScreen({super.key});

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddressProvider>(
      builder: (context, provider, child) {
        if (provider.addresses.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return Expanded(
          child: ListView.builder(
            itemCount: provider.addresses.length,
            itemBuilder: (context, index) {
              AddressDTO address = provider.addresses[index];
              return Card(
                child: ListTile(
                  title: Text("${address.street}, ${address.city}"),
                  subtitle: Text("${address.state}, ${address.country}"),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
