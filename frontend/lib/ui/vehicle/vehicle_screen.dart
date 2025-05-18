import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/_providers/vehicle_provider.dart';
import '/ui/vehicle/add_edit_vehicle_screen.dart';
import '/ui/vehicle/vehicle_detail_screen.dart';

class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({super.key});

  @override
  _VehicleListScreenState createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<VehicleProvider>(context, listen: false).fetchVehicles();
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = Provider.of<VehicleProvider>(context);

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Vehicles')),
      body: vehicleProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vehicleProvider.errorMessage != null
              ? Center(child: Text('Error: ${vehicleProvider.errorMessage}'))
              : Padding(
                  padding:
                      const EdgeInsets.only(left: 400, right: 400, top: 16),
                  child: ListView.builder(
                    itemCount: vehicleProvider.vehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = vehicleProvider.vehicles[index];
                      return ListTile(
                        title: Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Model: ', // Bold text
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: vehicle.company ?? '', // Normal text
                              ),
                            ],
                          ),
                        ),
                        subtitle: Text(vehicle.model ?? ''),
                        trailing: Text(vehicle.ownerId!),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VehicleDetailScreen(vehicle: vehicle),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditVehicleScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
