import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ResponsiveListView<T> extends StatelessWidget {
  final List<T> items;
  final Widget emptyWidget;
  final Widget Function(BuildContext context, T item) itemBuilder;
  const ResponsiveListView({super.key, required this.items, required this.itemBuilder, required this.emptyWidget});

  @override
  Widget build(BuildContext context) {
    if(items.isEmpty) {
      return emptyWidget;
    }
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        padding: const EdgeInsets.only(top: 24.0),
        child: StaggeredGrid.count(
          crossAxisCount: constraints.maxWidth < 500 ? 1
              : constraints.maxWidth < 800 ? 2 
              : constraints.maxWidth < 1200 ? 3
              : 4,
          children: items
            .map( (t) => Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.circular(12)),
                color: Colors.white,
                clipBehavior: Clip.antiAlias,
                child: itemBuilder(context, t),
              ),
            ).toList(),
        ),
      );
    });
  }
}