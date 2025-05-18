import 'dart:async';

import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Dashboard'),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return buildMobileView();
        } else if (constraints.maxWidth < 800) {
          return buildTabletView();
        }
        return buildDesktopView();
      }),
    );
  }

  Widget buildMobileView() {
    return getWidget(
      const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
      const EdgeInsets.only(top: 50.0),
    );
  }

  Widget buildDesktopView() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: getWidget(
          const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, crossAxisSpacing: 20.0, mainAxisSpacing: 10.0),
          const EdgeInsets.only(top: 200.0),
        ),
      ),
    );
  }

  Widget buildTabletView() {
    return getWidget(
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2,
        ),
        const EdgeInsets.only(top: 50.0));
  }

  Widget getWidget(
      SliverGridDelegateWithFixedCrossAxisCount grid, EdgeInsetsGeometry eig) {
    List<ServiceTile> serviceTiles = [
      ServiceTile(
        imagePath: 'assets/images/4.png',
        name: 'Customer Management',
        onTap: () {
          Navigator.pushReplacementNamed(context, "/customer");
        },
      ),
      ServiceTile(
        imagePath: 'assets/images/1.png',
        name: 'Vehicle Management',
        onTap: () {
          Navigator.pushReplacementNamed(context, "/vehicle");
        },
      ),
      ServiceTile(
        imagePath: 'assets/images/2.png',
        name: 'Booking Management',
        onTap: () {
          Navigator.pushReplacementNamed(context, "/booking");
        },
      ),
      ServiceTile(
        imagePath: 'assets/images/3.png',
        name: 'Payment Management',
        onTap: () {
          Navigator.pushReplacementNamed(context, "/payment");
        },
      ),
    ];
    return Column(
      children: [
        SizedBox(
          child: GridView.builder(
            gridDelegate: grid,
            shrinkWrap: true,
            itemCount: serviceTiles.length,
            itemBuilder: (context, index) {
              return serviceTiles[index];
            },
          ),
        ),
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
    );
  }
}
