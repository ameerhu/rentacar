import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/_providers/vehicle_provider.dart';
import '/domains/enums/vehicle_status.dart';
import '/domains/vehicle_dto.dart';

class AddEditVehicleScreen extends StatefulWidget {
  final VehicleDTO? vehicle;

  const AddEditVehicleScreen({super.key, this.vehicle});

  @override
  State<AddEditVehicleScreen> createState() => _AddEditVehicleScreenState();
}

class _AddEditVehicleScreenState extends State<AddEditVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _modelController = TextEditingController();
  final _typeController = TextEditingController();
  final _licensePlateController = TextEditingController();
  final _numberController = TextEditingController();
  final _ownerIdController = TextEditingController();
  final _pricePerDayController = TextEditingController();
  VehicleStatus _selectedStatus = VehicleStatus.AVAILABLE;

  @override
  void initState() {
    super.initState();
    if (widget.vehicle != null) {
      _companyController.text = widget.vehicle!.company ?? '';
      _modelController.text = widget.vehicle!.model ?? '';
      _typeController.text = widget.vehicle!.type ?? '';
      _licensePlateController.text = widget.vehicle!.licensePlate ?? '';
      _numberController.text = widget.vehicle!.number ?? '';
      _ownerIdController.text = widget.vehicle!.ownerId ?? '';
      _pricePerDayController.text =
          widget.vehicle!.pricePerDay?.toString() ?? '';
      _selectedStatus = widget.vehicle!.status;
    }
  }

  @override
  void dispose() {
    _companyController.dispose();
    _modelController.dispose();
    _typeController.dispose();
    _licensePlateController.dispose();
    _numberController.dispose();
    _ownerIdController.dispose();
    _pricePerDayController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final vehicle = VehicleDTO(
        id: widget.vehicle?.id,
        company: _companyController.text,
        model: _modelController.text,
        type: _typeController.text,
        licensePlate: _licensePlateController.text,
        number: _numberController.text,
        ownerId: _ownerIdController.text,
        pricePerDay: double.tryParse(_pricePerDayController.text),
        status: _selectedStatus,
      );

      final vehicleProvider =
          Provider.of<VehicleProvider>(context, listen: false);
      if (widget.vehicle == null) {
        vehicleProvider
            .addVehicle(vehicle)
            .then((value) => Navigator.pop(context));
      } else {
        vehicleProvider
            .updateVehicle(vehicle)
            .then((value) => Navigator.pop(context));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = Provider.of<VehicleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vehicle == null ? 'Add Vehicle' : 'Edit Vehicle'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(labelText: 'Company'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter company' : null,
              ),
              TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(labelText: 'Model'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter model' : null,
              ),
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: 'Type'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter type' : null,
              ),
              TextFormField(
                controller: _licensePlateController,
                decoration: const InputDecoration(labelText: 'License Plate'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter license plate' : null,
              ),
              TextFormField(
                controller: _numberController,
                decoration: const InputDecoration(labelText: 'Number'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter number' : null,
              ),
              TextFormField(
                controller: _ownerIdController,
                decoration: const InputDecoration(labelText: 'Owner ID'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter owner ID' : null,
              ),
              TextFormField(
                controller: _pricePerDayController,
                decoration: const InputDecoration(labelText: 'Price Per Day'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter price per day' : null,
              ),
              DropdownButtonFormField<VehicleStatus>(
                value: _selectedStatus,
                decoration: const InputDecoration(labelText: 'Status'),
                items: VehicleStatus.values.map((status) {
                  return DropdownMenuItem<VehicleStatus>(
                    value: status,
                    child: Text(status.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              vehicleProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(widget.vehicle == null
                          ? 'Add Vehicle'
                          : 'Update Vehicle'),
                    ),
              if (vehicleProvider.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    vehicleProvider.errorMessage!,
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
