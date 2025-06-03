import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/_providers/booking_provider.dart';
import '/ui/booking/add_edit_booking_screen.dart';
import '/ui/booking/booking_detail_screen.dart';

class BookingListScreen extends StatefulWidget {
  const BookingListScreen({super.key});

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<BookingProvider>(context, listen: false).fetchBookings();
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Bookings')),
      body: bookingProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookingProvider.errorMessage != null
              ? Center(child: Text('Error: ${bookingProvider.errorMessage}'))
              : ListView.builder(
                  itemCount: bookingProvider.bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookingProvider.bookings[index];
                    return ListTile(
                      leading: Text('ID: ${booking.id!.substring(0, 8)}'),
                      subtitle: Text('Customer: ${booking.customerName}'),
                      trailing:  Text(
                          'Status: ${booking.status.toString().split('.').last}'),
                          title: Text('Model: ${booking.vehicleName}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BookingDetailScreen(booking: booking),
                          ),
                        );
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddEditBookingScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
