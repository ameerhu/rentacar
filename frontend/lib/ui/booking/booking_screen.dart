import 'package:flutter/material.dart';
import 'package:frontend/ui/base_page.dart';
import 'package:frontend/ui/booking/booking_list.dart';
import 'package:provider/provider.dart';

import '/_providers/booking_provider.dart';
import '/ui/booking/add_edit_booking_screen.dart';

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
    return BasePage(
      title: 'Bookings',
      body: const BookingListPage(),
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
