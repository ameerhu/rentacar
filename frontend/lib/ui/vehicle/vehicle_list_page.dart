import 'package:flutter/material.dart';
import 'package:frontend/_providers/vehicle_provider.dart';
import 'package:frontend/domains/customer_dto.dart';
import 'package:frontend/domains/vehicle_dto.dart';
import 'package:frontend/ui/vehicle/vehicle_detail_screen.dart';
import 'package:frontend/ui/vehicle/widgets/no_vehicle_found.dart';
import 'package:frontend/widgets/responsive_list_view.dart';
import 'package:frontend/widgets/row_detail.dart';
import 'package:provider/provider.dart';

class VehicleListPage extends StatefulWidget {
  final CustomerDTO? customer;
  const VehicleListPage({super.key, this.customer});

  @override
  State<VehicleListPage> createState() => _VehicleListPageState();
}

class _VehicleListPageState extends State<VehicleListPage> {
  
  @override
  void initState() {
    super.initState();
    Provider.of<VehicleProvider>(context, listen: false).fetchVehicles();
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = Provider.of<VehicleProvider>(context);
    return vehicleProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vehicleProvider.errorMessage != null
              ? Center(child: Text('Error: ${vehicleProvider.errorMessage}'))
              : ResponsiveListView(
                  items: widget.customer == null 
                    ? vehicleProvider.vehicles 
                    : vehicleProvider.vehicles.where((VehicleDTO v) => v.ownerId == widget.customer?.id).toList(),
                  emptyWidget: const NoVehicleFound(), 
                  itemBuilder: (context, vehicle) {
                    return ListTile(
                      title: RowDetail('Company', vehicle.company!, mainAxisAlignment: MainAxisAlignment.start,),
                      subtitle: Column(
                        children: [
                          RowDetail('Model', vehicle.model!, mainAxisAlignment: MainAxisAlignment.start,),
                          RowDetail('Owner', vehicle.ownerName!, mainAxisAlignment: MainAxisAlignment.start,)
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VehicleDetailScreen(vehicle: vehicle),
                          ),
                        );
                      },
                    );
                  });
  }
}