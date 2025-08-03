import 'package:flutter/material.dart';
import 'package:frontend/ui/base_page.dart';
import 'package:frontend/ui/vehicle/vehicle_list_page.dart';
import '/ui/vehicle/add_edit_vehicle_screen.dart';

class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({super.key});

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Vehicles',
      body: const VehicleListPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditVehicleScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
