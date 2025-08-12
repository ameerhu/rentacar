import 'package:flutter/material.dart';
import 'package:frontend/_providers/customer_provider.dart';
import 'package:frontend/config/rac_routes.dart';
import 'package:frontend/ui/booking/booking_list.dart';
import 'package:frontend/ui/customer/add_edit_customer_data.dart';
import 'package:frontend/ui/payment/payment_list_page.dart';
import 'package:frontend/ui/vehicle/vehicle_list_page.dart';
import 'package:frontend/widgets/no_item_selected.dart';
import 'package:provider/provider.dart';

class CustomerDetailView extends StatefulWidget {
  final ValueChanged<String> onTabChange;
  const CustomerDetailView({super.key, required this.onTabChange});

  @override
  State<CustomerDetailView> createState() => _CustomerDetailViewState();
}

class _CustomerDetailViewState extends State<CustomerDetailView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, String> tabTitles = {
    'Bio':  RacRoutes.customerAdd,
    'Bookings': RacRoutes.bookingAdd,
    'Payments': RacRoutes.paymentAdd,
    'Vehicles': RacRoutes.vehicleAdd,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabTitles.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerProvider>(
      builder: (context, cp, child) {
        if (cp.selectedCustomer == null) {
          return const NoItemSelected();
        }
        return Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: tabTitles.keys.map((e) => Tab(text: e)).toList(),
              onTap: (i) => { 
                widget.onTabChange(tabTitles.entries.elementAt(i).value) 
              }
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  const AddEditCustomerData(),
                  BookingListPage(customer: cp.selectedCustomer),
                  PaymentListPage(customer: cp.selectedCustomer),
                  VehicleListPage(customer: cp.selectedCustomer,),
                ],
              ),
            )
          ],
        );
      }
    );
  }
}
