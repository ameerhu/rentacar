import '/ui/booking/add_edit_booking_screen.dart';
import '/ui/booking/booking_screen.dart';
import '/ui/customer/add_edit_customer_screen.dart';
import '/ui/customer/customer_screen.dart';
import '/ui/dashboard/dashboard_page.dart';
import '/ui/login/login_page.dart';
import '/ui/payment/payment_screen.dart';
import '/ui/registration/registration_page.dart';
import '/ui/vehicle/vehicle_screen.dart';

final racRoutes = {
  '/login': (context) => const LoginPage(),
  '/register': (context) => const RegistrationPage(),
  '/dashboard': (context) => DashboardScreen(),
  /*'/dashboard': (context) => DashbosardScreen(
      userDTO: ModalRoute.of(context)!.settings.arguments as UserDTO),*/
  '/customer': (context) => const CustomerScreen(),
  '/customer/add': (context) => AddEditCustomerScreen(),
  '/vehicle': (context) => const VehicleListScreen(),
  '/vehicle/add': (context) => AddEditCustomerScreen(),
  '/booking': (context) => const BookingListScreen(),
  '/booking/add': (context) => const AddEditBookingScreen(),
  '/payment': (context) => const PaymentScreen(),
};
