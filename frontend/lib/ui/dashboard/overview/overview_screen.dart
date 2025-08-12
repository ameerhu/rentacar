import 'package:flutter/material.dart';
import 'package:frontend/_providers/payment_provider.dart';
import 'package:frontend/domains/customer_dto.dart';
import 'package:frontend/ui/base_page.dart';
import 'package:frontend/ui/dashboard/overview/overview_desktop_screen.dart';
import 'package:frontend/ui/dashboard/overview/overview_mobile_screen.dart';
import 'package:provider/provider.dart';

import '../../../_providers/customer_provider.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
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
    final screenWidth = MediaQuery.of(context).size.width;
    final body = screenWidth > 1200 ? const OverviewDesktopScreen() : const OverviewMobileScreen();

    return BasePage(
      title: 'Overview', 
      body: body,
    );
  }
}
