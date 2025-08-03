import 'package:flutter/material.dart';
import 'package:frontend/_providers/customer_provider.dart';
import 'package:frontend/ui/booking/booking_list.dart';
import 'package:frontend/ui/customer/add_edit_customer_data.dart';
import 'package:frontend/ui/payment/payment_list_page.dart';
import 'package:frontend/ui/payment/payment_pending_page.dart';
import 'package:frontend/ui/vehicle/vehicle_list_page.dart';
import 'package:frontend/widgets/no_item_selected.dart';
import 'package:provider/provider.dart';

class CustomerDetailView extends StatefulWidget {
  const CustomerDetailView({super.key});

  @override
  State<CustomerDetailView> createState() => _CustomerDetailViewState();
}

class _CustomerDetailViewState extends State<CustomerDetailView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
              tabs: const [
                Tab(text: 'Bio'),
                Tab(text: 'Bookings'),
                Tab(text: 'Payments'),
                Tab(text: 'Pending Payments'),
                Tab(text: 'Vehicles'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  const AddEditCustomerData(),
                  BookingListPage(customer: cp.selectedCustomer),
                  PaymentListPage(customer: cp.selectedCustomer),
                  PaymentPendingPage(customer: cp.selectedCustomer),
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
