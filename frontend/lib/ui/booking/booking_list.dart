import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:frontend/_providers/booking_provider.dart';
import 'package:frontend/domains/booking_dto_ext.dart';
import 'package:frontend/domains/customer_dto.dart';
import 'package:frontend/domains/enums/booking_status.dart';
import 'package:frontend/ui/booking/booking_detail_screen.dart';
import 'package:provider/provider.dart';

class BookingListPage extends StatefulWidget {
  final CustomerDTO? customer;
  const BookingListPage({super.key, this.customer});

  @override
  State<BookingListPage> createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<BookingProvider>(context, listen: false).fetchBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, provider, child) {
        final bookings = widget.customer == null ? provider.bookings : provider.customerBookings;
        if (provider.errorMessage != null) {
          return Center(child: Text('Error: ${provider.errorMessage}'));
        }
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: StaggeredGrid.count(
                  crossAxisCount: constraints.maxWidth < 500 ? 1 : constraints.maxWidth < 800 ? 2 : 4,
                  children: bookings.map((booking) => 
                    Card(
                      child: ListTile(
                        title: Text("${booking.id!.substring(0, 8)} ${booking.customerName ?? ""}"),
                        subtitle: (booking.remainingBalance != null && booking.remainingBalance! > 0) 
                          ? Text("Pending: ${booking.remainingBalance ?? 0}", 
                              style: const TextStyle(color: Colors.red, 
                                fontWeight: FontWeight.bold),
                                )
                          : Text("Paid: ${booking.totalAmount}"),
                        trailing: statusIcon(booking.status),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingDetailScreen(booking: booking),
                            ),
                          );
                        },
                      ),
                    )
                  ).toList()
                ),
              );
            }
          ),
        );
      },
    );
  }

  statusIcon (bs) => 
    BookingStatus.COMPLETED == bs 
      ? const Icon(Icons.check_box) 
        : BookingStatus.CANCELLED == bs 
          ? const Icon(Icons.cancel) 
          : const Icon(Icons.pending); 
}