import 'package:flutter/material.dart';
import 'package:frontend/_providers/address_provider.dart';
import 'package:frontend/_providers/booking_provider.dart';
import 'package:frontend/_providers/payment_provider.dart';
import 'package:frontend/config/rac_routes.dart';
import 'package:frontend/ui/base_page.dart';
import 'package:frontend/ui/customer/customer_detail_screen.dart';
import 'package:frontend/ui/customer/customer_detail_view.dart';
import 'package:provider/provider.dart';

import '/ui/customer/customer_list.dart';
import '../../_providers/customer_provider.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  String routeTo = RacRoutes.customerAdd;
  late AddressProvider addressProvider;
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<CustomerProvider>(context, listen: false).fetchCustomers());
    addressProvider = Provider.of<AddressProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return BasePage(
      title: 'Customers',
      body: Row(
        children: [
          Expanded(
            flex: screenWidth > 1200 ? 1 : 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomerListScreen(
                onTap: (customer) => {
                  Provider.of<CustomerProvider>(context, listen: false).setSelectedCustomer(customer),
                  Provider.of<BookingProvider>(context, listen: false).fetchBookingsByCustomerId(customer.id),
                  Provider.of<PaymentProvider>(context, listen: false).fetchPaymentsByCustomer(customer.id),
                  addressProvider.setCustomerId(customer.id),
                  if(screenWidth < 500)
                    Navigator.push(context, MaterialPageRoute(builder: 
                      (context) => CustomerDetailScreen(customer: customer,)
                      )
                    )
                },
              ),
            ),
          ),
          if(screenWidth>500) 
            const VerticalDivider(width: 1, thickness: 1, color: Colors.deepOrange,),
          if(screenWidth>500) 
            Expanded(flex: screenWidth > 1200 ? 3 : 4, 
              child: CustomerDetailView(onTabChange: (rt) => setState(() => routeTo = rt ))
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Provider.of<CustomerProvider>(context, listen: false).setSelectedCustomer(null);
          Navigator.pushReplacementNamed(context, routeTo);
        },
      ),
    );
  }
}