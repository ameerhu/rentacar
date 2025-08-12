import 'package:flutter/material.dart';
import 'package:frontend/util/date_time_util.dart';
import 'package:provider/provider.dart';
import '/_providers/customer_provider.dart';

import '/_providers/booking_provider.dart';
import '/_providers/vehicle_provider.dart';
import '/domains/booking_dto.dart';
import '/domains/enums/booking_status.dart';
import '/domains/vehicle_dto.dart';
import '../../domains/customer_dto.dart';

class AddEditBookingScreen extends StatefulWidget {
  final BookingDTO? booking;

  const AddEditBookingScreen({super.key, this.booking});

  @override
  State<AddEditBookingScreen> createState() => _AddEditBookingScreenState();
}

class _AddEditBookingScreenState extends State<AddEditBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleIdController = TextEditingController();
  final _customerIdController = TextEditingController();
  final _rentalStartDateController = TextEditingController();
  final _rentalEndDateController = TextEditingController();
  final _totalAmountController = TextEditingController();
  final _amountPaidController = TextEditingController();
  BookingStatus _selectedStatus = BookingStatus.PENDING;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  List<VehicleDTO> _vehicles = [];
  List<CustomerDTO> _customers = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
    if (widget.booking != null) {
      _vehicleIdController.text = widget.booking!.vehicleId ?? '';
      _customerIdController.text = widget.booking!.customerId ?? '';
      _selectedStartDate = widget.booking!.rentalStartDate;
      _selectedEndDate = widget.booking!.rentalEndDate;
      _rentalStartDateController.text = DateTimeUtil.ymdhm(_selectedStartDate!);
      _rentalEndDateController.text = DateTimeUtil.ymdhm(_selectedEndDate!);
      _totalAmountController.text = widget.booking!.totalAmount?.toString() ?? '';
      _amountPaidController.text = widget.booking!.amountPaid.toString();
      _selectedStatus = widget.booking!.status;
    }
  }

  Future<void> _fetchData() async {
    final vehicleProvider =
        Provider.of<VehicleProvider>(context, listen: false);
    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);
    await vehicleProvider.fetchVehicles();
    await customerProvider.fetchCustomers();
    setState(() {
      _vehicles = vehicleProvider.vehicles;
      _customers = customerProvider.customers;
    });
  }

  @override
  void dispose() {
    _vehicleIdController.dispose();
    _customerIdController.dispose();
    _rentalStartDateController.dispose();
    _rentalEndDateController.dispose();
    _totalAmountController.dispose();
    _amountPaidController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final booking = BookingDTO(
        id: widget.booking?.id,
        vehicleId: _vehicleIdController.text,
        customerId: _customerIdController.text,
        rentalStartDate: _selectedStartDate,
        rentalEndDate: _selectedEndDate,
        totalAmount: double.tryParse(_totalAmountController.text),
        amountPaid: double.tryParse(_amountPaidController.text) ?? 0.0,
        status: _selectedStatus,
      );

      final bookingProvider =
          Provider.of<BookingProvider>(context, listen: false);
      if (widget.booking == null) {
        bookingProvider
            .addBooking(booking)
            .then((value) => Navigator.pop(context));
      } else {
        bookingProvider
            .updateBooking(booking)
            .then((value) => Navigator.pop(context));
      }
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? _selectedStartDate ?? DateTime.now()
          : _selectedEndDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(isStartDate ? _selectedStartDate ?? DateTime.now() : _selectedEndDate ?? DateTime.now()),
    );
    final picked = DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
        pickedTime?.hour ?? DateTime.now().hour, pickedTime?.minute ?? 0);

    setState(() {
      if (isStartDate) {
        _selectedStartDate = picked;
        _rentalStartDateController.text = DateTimeUtil.ymdhm(picked);
      } else {
        _selectedEndDate = picked;
        _rentalEndDateController.text = DateTimeUtil.ymdhm(picked);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.booking == null ? 'Add Booking' : 'Edit Booking'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Vehicle'),
                value: _vehicleIdController.text.isEmpty
                    ? null
                    : _vehicleIdController.text,
                items: _vehicles.map((vehicle) {
                  return DropdownMenuItem<String>(
                    value: vehicle.id,
                    child: Text('${vehicle.company} - ${vehicle.model}'),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => _vehicleIdController.text = value!),
                validator: (value) =>
                    value == null ? 'Please select a vehicle' : null,
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Customer'),
                value: _customerIdController.text.isEmpty
                    ? null
                    : _customerIdController.text,
                items: _customers.map((c) {
                  return DropdownMenuItem(
                    value: c.id,
                    child: Text('${c.firstName} ${c.lastName} - ${c.cnic}'),
                  );
                }).toList(),
                onChanged: (value) => setState(() {
                  _customerIdController.text = value!;
                }),
                validator: (value) =>
                    value == null ? 'Please select a customer' : null,
              ),
              TextFormField(
                controller: _rentalStartDateController,
                decoration:
                    const InputDecoration(labelText: 'Rental Start Date'),
                readOnly: true,
                onTap: () => _selectDate(context, true),
                validator: (value) =>
                    value!.isEmpty ? 'Please select rental start date' : null,
              ),
              TextFormField(
                controller: _rentalEndDateController,
                decoration: const InputDecoration(labelText: 'Rental End Date'),
                readOnly: true,
                onTap: () => _selectDate(context, false),
                validator: (value) =>
                    value!.isEmpty ? 'Please select rentalend date' : null,
              ),
              TextFormField(
                controller: _totalAmountController,
                decoration: const InputDecoration(labelText: 'Total Amount'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter total amount' : null,
              ),
              TextFormField(
                controller: _amountPaidController,
                decoration: const InputDecoration(labelText: 'Amount Paid'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter amount paid' : null,
              ),
              DropdownButtonFormField<BookingStatus>(
                value: _selectedStatus,
                decoration: const InputDecoration(labelText: 'Status'),
                items: BookingStatus.values.map((status) {
                  return DropdownMenuItem<BookingStatus>(
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
              bookingProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(widget.booking == null
                          ? 'Add Booking'
                          : 'Update Booking'),
                    ),
              if (bookingProvider.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    bookingProvider.errorMessage!,
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
