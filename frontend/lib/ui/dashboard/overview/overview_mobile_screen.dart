import 'package:flutter/material.dart';
import 'package:frontend/_providers/payment_provider.dart';
import 'package:frontend/ui/booking/booking_list.dart';
import 'package:frontend/ui/payment/payment_list_page.dart';
import 'package:frontend/ui/payment/payment_pending_page.dart';
import 'package:frontend/ui/vehicle/vehicle_list_page.dart';
import 'package:frontend/widgets/tile_header.dart';
import 'package:provider/provider.dart';

import '../../../_providers/customer_provider.dart';

class OverviewMobileScreen extends StatefulWidget {
  const OverviewMobileScreen({super.key});

  @override
  State<OverviewMobileScreen> createState() => _OverviewMobileScreenState();
}

class _OverviewMobileScreenState extends State<OverviewMobileScreen> {
  int expansionTileIndex = 0;
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
    final Map<String, Widget> data = {
      "Booking History": Consumer<CustomerProvider>(builder: (ctx, provider, child) {
              return BookingListPage(customer: provider.selectedCustomer);
            }),
      "Payment History": Consumer<CustomerProvider>(builder: (ctx, provider, child) {
            return PaymentListPage(customer: provider.selectedCustomer);
          }),
      "Pending Payments": const PaymentPendingPage(),
      "Vehicles": const VehicleListPage(),
    };

    return SingleChildScrollView(
      child: ExpansionPanelList.radio(
        elevation: 0,
        materialGapSize: 8,
        expandedHeaderPadding: EdgeInsets.zero,
        dividerColor: Theme.of(context).colorScheme.inversePrimary,
        children: data.entries.map((e) => 
          ExpansionPanelRadio(
            value:e.key, 
            headerBuilder: (ctx, _) => Center(child: TileHeader(title: e.key)), 
            body: e.value,
            canTapOnHeader: true,
          ),
        ).toList()
      ),
    );
  }
}
