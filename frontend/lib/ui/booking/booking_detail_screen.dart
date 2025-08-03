import 'package:flutter/material.dart';
import 'package:frontend/domains/booking_dto_ext.dart';
import 'package:frontend/domains/enums/booking_status.dart';
import 'package:frontend/widgets/row_detail.dart';
import 'package:provider/provider.dart';

import '/_providers/booking_provider.dart';
import 'add_edit_booking_screen.dart';

class BookingDetailScreen extends StatelessWidget {
  final BookingDTOEXT booking;

  const BookingDetailScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if(booking.status != BookingStatus.COMPLETED)
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
          if(booking.status != BookingStatus.COMPLETED)
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
            RowDetail('ID', booking.id ?? 'N/A'),
            RowDetail('Vehicle ID', booking.vehicleId ?? 'N/A'),
            RowDetail('Vehicle Name', booking.vehicleName ?? 'N/A'),
            RowDetail('Customer ID', booking.customerId ?? 'N/A'),
            RowDetail('Customer Name', booking.customerName ?? 'N/A'),
            RowDetail(
                'Rental Start Date',
                booking.rentalStartDate?.toLocal().toString().split(' ')[0] ??
                    'N/A'),
            RowDetail(
                'Rental End Date',
                booking.rentalEndDate?.toLocal().toString().split(' ')[0] ??
                    'N/A'),
            RowDetail(
                'Total Amount', booking.totalAmount?.toString() ?? 'N/A'),
            RowDetail('Amount Paid', booking.amountPaid.toString()),
            RowDetail('Remaining Balance',
                booking.remainingBalance?.toString() ?? 'N/A'),
            RowDetail(
                'Status', booking.status.toString().split('.').last),
          ],
        ),
      ),
    );
  }
}