import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/_providers/vehicle_provider.dart';
import '/domains/vehicle_dto.dart';
import 'add_edit_vehicle_screen.dart';

class VehicleDetailScreen extends StatelessWidget {
  final VehicleDTO vehicle;

  const VehicleDetailScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = Provider.of<VehicleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditVehicleScreen(vehicle: vehicle),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Vehicle'),
                  content: const Text(
                      'Are you sure you want to delete this vehicle?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        vehicleProvider.deleteVehicle(vehicle.id!).then(
                            (value) => Navigator.popUntil(
                                context, (route) => route.isFirst));
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailRow('ID', vehicle.id ?? 'N/A'),
            _buildDetailRow('Company', vehicle.company ?? 'N/A'),
            _buildDetailRow('Model', vehicle.model ?? 'N/A'),
            _buildDetailRow('Type', vehicle.type ?? 'N/A'),
            _buildDetailRow('License Plate', vehicle.licensePlate ?? 'N/A'),
            _buildDetailRow('Number', vehicle.number ?? 'N/A'),
            _buildDetailRow(
                'Status', vehicle.status.toString().split('.').last),
            _buildDetailRow('Owner ID', vehicle.ownerId ?? 'N/A'),
            _buildDetailRow(
                'Price Per Day', vehicle.pricePerDay?.toString() ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
