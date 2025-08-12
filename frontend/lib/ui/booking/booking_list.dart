import 'package:flutter/material.dart';
import 'package:frontend/_providers/booking_provider.dart';
import 'package:frontend/domains/customer_dto.dart';
import 'package:frontend/domains/enums/booking_status.dart';
import 'package:frontend/ui/booking/booking_detail_screen.dart';
import 'package:frontend/ui/booking/widgets/no_booking_found.dart';
import 'package:frontend/util/date_time_util.dart';
import 'package:frontend/widgets/responsive_list_view.dart';
import 'package:frontend/widgets/row_detail.dart';
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
        
        bookings.sort((a,b) => (b.remainingBalance ?? 0).compareTo(a.remainingBalance ?? 0));
        return ResponsiveListView(
          items: bookings, 
          emptyWidget: const NoBookingFound(),
          itemBuilder: (context, booking) =>
            ListTile(
              title: Text("${booking.id}"),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RowDetail('Customer', booking.customerName ?? '', mainAxisAlignment: MainAxisAlignment.start,),
                  RowDetail('Vehicle', booking.vehicleName ?? '', mainAxisAlignment: MainAxisAlignment.start,),
                  RowDetail('Start Date', DateTimeUtil.ymdhm(booking.rentalStartDate!.toLocal()), mainAxisAlignment: MainAxisAlignment.start,),
                  RowDetail('End Date', DateTimeUtil.ymdhm(booking.rentalEndDate!.toLocal()), mainAxisAlignment: MainAxisAlignment.start,), 
                  (booking.remainingBalance != null && booking.remainingBalance! > 0) 
                  ? Text("Pending: ${booking.remainingBalance ?? 0}", 
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      )
                  : Text("Paid: ${booking.amountPaid}"),
                ],
              ),
              trailing: statusIcon(booking.status),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingDetailScreen(booking: booking),
                  ),
                );
              },
            )
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