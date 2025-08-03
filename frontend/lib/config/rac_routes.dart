import 'package:flutter/material.dart';
import 'package:frontend/ui/coming_soon.dart';
import 'package:frontend/ui/dashboard/overview_screen.dart';
import 'package:frontend/ui/payment/add_edit_payment_page.dart';
import 'package:frontend/ui/vehicle/add_edit_vehicle_screen.dart';

import '/ui/booking/add_edit_booking_screen.dart';
import '/ui/booking/booking_screen.dart';
import '/ui/customer/add_edit_customer_screen.dart';
import '/ui/customer/customer_screen.dart';
import '/ui/dashboard/dashboard_page.dart';
import '/ui/login/login_page.dart';
import '/ui/payment/payment_screen.dart';
import '/ui/registration/registration_page.dart';
import '/ui/vehicle/vehicle_screen.dart';

class RacRoutes {
  static const login = '/login';
  static const register = '/register';
  static const dashboard = '/dashboard';
  static const overview = '/overview';

  static const customer = '/customer';
  static const customerAdd = '/customer/add';

  static const vehicle = '/vehicle';
  static const vehicleAdd = '/vehicle/add';

  static const booking = '/booking';
  static const bookingAdd = '/booking/add';

  static const payment = '/payment';
  static const paymentAdd = '/payment/add';

  static const notification = '/notifications';
}


final racRoutes = {
  RacRoutes.login: (context) => const LoginPage(),
  RacRoutes.register: (context) => const RegistrationPage(),
  RacRoutes.dashboard: (context) => const DashboardScreen(),
  RacRoutes.overview: (context) => const OverviewScreen(),
  RacRoutes.customer: (context) => const CustomerScreen(),
  RacRoutes.customerAdd: (context) => const AddEditCustomerScreen(),
  RacRoutes.vehicle: (context) => const VehicleListScreen(),
  RacRoutes.vehicleAdd: (context) => const AddEditVehicleScreen(),
  RacRoutes.booking: (context) => const BookingListScreen(),
  RacRoutes.bookingAdd: (context) => const AddEditBookingScreen(),
  RacRoutes.payment: (context) => const PaymentScreen(),
  RacRoutes.paymentAdd: (context) => const AddEditPaymentPage(),
  RacRoutes.notification: (context) => const ComingSoon(),
};

Route<dynamic> generateRoute(RouteSettings settings) {
  final args = settings.arguments;
  switch (settings.name) {
    case RacRoutes.login:
      return MaterialPageRoute(builder: (context) => const LoginPage());
    case  RacRoutes.register:
      return MaterialPageRoute(builder: (context) => const RegistrationPage());
    default:
      return MaterialPageRoute(builder: (context) => const OverviewScreen());
  }
}
