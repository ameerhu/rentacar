import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/_providers/booking_provider.dart';
import '/domains/booking_dto.dart';
import 'add_edit_booking_screen.dart';

class BookingDetailScreen extends StatelessWidget {
  final BookingDTO booking;

  const BookingDetailScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditBookingScreen(booking: booking),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Booking'),
                  content: const Text(
                      'Are you sure you want to delete this booking?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        bookingProvider.deleteBooking(booking.id!).then(
                            (value) => Navigator.popUntil(
                                context, (route) => route.isFirst));
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailRow('ID', booking.id ?? 'N/A'),
            _buildDetailRow('Vehicle ID', booking.vehicleId ?? 'N/A'),
            _buildDetailRow('Customer ID', booking.customerId ?? 'N/A'),
            _buildDetailRow(
                'Rental Start Date',
                booking.rentalStartDate?.toLocal().toString().split(' ')[0] ??
                    'N/A'),
            _buildDetailRow(
                'Rental End Date',
                booking.rentalEndDate?.toLocal().toString().split(' ')[0] ??
                    'N/A'),
            _buildDetailRow(
                'Total Amount', booking.totalAmount?.toString() ?? 'N/A'),
            _buildDetailRow('Amount Paid', booking.amountPaid.toString()),
            _buildDetailRow('Remaining Balance',
                booking.remainingBalance?.toString() ?? 'N/A'),
            _buildDetailRow(
                'Status', booking.status.toString().split('.').last),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
