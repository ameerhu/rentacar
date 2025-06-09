import 'package:flutter/material.dart';
import 'package:frontend/_providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '_providers/address_provider.dart';

import '_providers/booking_provider.dart';
import '_providers/customer_provider.dart';
import '_providers/payment_provider.dart';
import '_providers/vehicle_provider.dart';
import 'config/rac_routes.dart';
import 'ui/home/home_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CustomerProvider()),
        ChangeNotifierProvider(create: (context) => VehicleProvider()),
        ChangeNotifierProvider(create: (context) => BookingProvider()),
        ChangeNotifierProvider(create: (context) => PaymentProvider()),
        ChangeNotifierProvider(create: (context) => AddressProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Rent A Car',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routes: racRoutes,
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}
