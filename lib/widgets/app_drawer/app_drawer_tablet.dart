import 'package:flutter/material.dart';
import 'package:fst_app_flutter/widgets/app_drawer/app_drawer.dart';

class AppDrawerTabletPortrait extends StatelessWidget {
  const AppDrawerTabletPortrait({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(blurRadius: 16, color: Colors.black12),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: AppDrawer.getDrawerOptions(),
      ),
    );
  }
}

class AppDrawerTabletLandscape extends StatelessWidget {
  const AppDrawerTabletLandscape({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(blurRadius: 16, color: Colors.black12),
        ],
      ),
      child: Column(
        children: AppDrawer.getDrawerOptions(),
      ),
    );
  }
}
