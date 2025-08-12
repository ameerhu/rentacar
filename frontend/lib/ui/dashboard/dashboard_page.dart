import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/config/rac_routes.dart';
import 'package:frontend/ui/base_page.dart';

import '/constants/image_constants.dart';
import '/ui/dashboard/service_tile.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  double _leftPosition = -200; // Start position
  bool _movingRight = true; // Track movement direction
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAnimation() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _leftPosition = _movingRight ? 200 : -200; // Move left or right
        _movingRight = !_movingRight; // Toggle direction
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Dashboard',
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 500) {
          return buildMobileView();
        } else if (constraints.maxWidth < 1000) {
          return buildTabletView();
        }
        return buildDesktopView(constraints.maxWidth < 1200 ? 3 : 6);
      }),
    );
  }

  Widget buildMobileView() {
    return Center(
      child: getWidget(
        const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
        const EdgeInsets.only(top: 50.0),
      ),
    );
  }

  Widget buildDesktopView(int columnCount) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: ConstrainedBox(
          constraints: columnCount == 6 ? const BoxConstraints(maxWidth: 1200) : const BoxConstraints(maxWidth: 800),
          child: getWidget(
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnCount, 
              crossAxisSpacing: 20.0, 
              mainAxisSpacing: 10.0
            ),
            const EdgeInsets.only(top: 150.0),
            showCar: columnCount == 6,
          ),
        ),
      ),
    );
  }

  Widget buildTabletView() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: getWidget(
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2,
            ),
            const EdgeInsets.only(top: 50.0)),
      ),
    );
  }

  Widget getWidget(
    SliverGridDelegateWithFixedCrossAxisCount grid, 
    EdgeInsetsGeometry eig, 
    {bool showCar = false}
  ) {
    List<ServiceTile> serviceTiles = [
      ServiceTile(
        imagePath: 'assets/images/9.png',
        name: 'Overview',
        onTap: () {
          Navigator.pushNamed(context, RacRoutes.overview);
        },
      ),
      ServiceTile(
        imagePath: 'assets/images/4.png',
        name: 'Customer Management',
        onTap: () {
          Navigator.pushNamed(context, RacRoutes.customer);
        },
      ),
      ServiceTile(
        imagePath: 'assets/images/1.png',
        name: 'Vehicle Management',
        onTap: () {
          Navigator.pushNamed(context, RacRoutes.vehicle);
        },
      ),
      ServiceTile(
        imagePath: 'assets/images/2.png',
        name: 'Booking Management',
        onTap: () {
          Navigator.pushNamed(context, RacRoutes.booking);
        },
      ),
      ServiceTile(
        imagePath: 'assets/images/3.png',
        name: 'Payment Management',
        onTap: () {
          Navigator.pushNamed(context, RacRoutes.payment);
        },
      ),
      ServiceTile(
        imagePath: 'assets/images/11.png',
        name: 'Notifications',
        onTap: () {
          Navigator.pushNamed(context, RacRoutes.notification);
        },
      ),
    ];
    return showCar ? Column(
      children: [
        _buildServiceTileWidget(grid, serviceTiles),
        Padding(
          padding: eig,
          child: SizedBox(
            height: 200,
            child: AnimatedContainer(
              duration: const Duration(seconds: 3),
              curve: Curves.easeInOut,
              transform: Matrix4.translationValues(_leftPosition, 0, 0),
              child: Image.asset(ImageConstant.ayanrac),
            ),
          ),
        ),
      ],
    ) : _buildServiceTileWidget(grid, serviceTiles);
  }

  SizedBox _buildServiceTileWidget(
    SliverGridDelegateWithFixedCrossAxisCount grid, 
    List<ServiceTile> serviceTiles) {
    return SizedBox(
        child: GridView.builder(
          gridDelegate: grid,
          shrinkWrap: true,
          itemCount: serviceTiles.length,
          itemBuilder: (context, index) {
            return serviceTiles[index];
          },
        ),
      );
  }
}
