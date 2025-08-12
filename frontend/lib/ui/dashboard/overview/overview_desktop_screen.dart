import 'package:flutter/material.dart';
import 'package:frontend/_providers/payment_provider.dart';
import 'package:frontend/domains/customer_dto.dart';
import 'package:frontend/ui/booking/booking_list.dart';
import 'package:frontend/ui/payment/payment_list_page.dart';
import 'package:frontend/ui/payment/payment_pending_page.dart';
import 'package:frontend/ui/vehicle/vehicle_list_page.dart';
import 'package:frontend/widgets/tile_header.dart';
import 'package:provider/provider.dart';

import '../../../_providers/customer_provider.dart';

class OverviewDesktopScreen extends StatefulWidget {
  const OverviewDesktopScreen({super.key});

  @override
  State<OverviewDesktopScreen> createState() => _OverviewDesktopScreenState();
}

class _OverviewDesktopScreenState extends State<OverviewDesktopScreen> {
  late CustomerDTO selectedCustomer;
  @override
  void initState() {
    super.initState();
    Future.microtask(() => {
          Provider.of<CustomerProvider>(context, listen: false)
              .fetchCustomers(),
          Provider.of<PaymentProvider>(context, listen: false)
              .fetchPendingPayments(),
        });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> elements = [
      Expanded(
        child: GridTile(
          header: const TileHeader(title: "Booking History"),
          child: Consumer<CustomerProvider>(builder: (ctx, provider, child) {
            return BookingListPage(customer: provider.selectedCustomer);
          }),
        ),
      ),
      Expanded(
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: GridTile(
            header: const TileHeader(title: "Payment History"),
            child: Consumer<CustomerProvider>(builder: (ctx, provider, child) {
              return PaymentListPage(customer: provider.selectedCustomer);
            }),
          ),
        ),
      ),
      const Expanded(
        child: Card(
          child: GridTile(
            header: TileHeader(title: "Vehicles"), 
            child: VehicleListPage()
          )
        )
      ),
      const Expanded(
        child: GridTile(
          header: TileHeader(title: "Pending Payments",), 
          child: PaymentPendingPage()
        )
      ),
    ];

    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: elements 
    );
  }
}
