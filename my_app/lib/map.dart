import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabBarView.dart';
import 'package:motion_tab_bar/MotionTabController.dart';
import 'package:motion_tab_bar/motiontabbar.dart';
import 'package:my_app/account/account.dart';
import 'package:my_app/rental/rental_chat.dart';
import 'package:my_app/vehicle/vehicle_change.dart';
import 'package:my_app/vehicle/vehicle_details.dart';
import 'package:my_app/vehicle/vehicle_overview.dart';

class Map extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapStatefulWidget(),
      routes: {
        VehicleChange.routeName: (context) => VehicleChange(),
        VehicleDetails.routeName: (context) => VehicleDetails()
      },
    );
  }
}

class MapStatefulWidget extends StatefulWidget {

  @override
  _MapStatefulWidgetState createState() => _MapStatefulWidgetState();
}

class _MapStatefulWidgetState extends State<MapStatefulWidget> with TickerProviderStateMixin {
  MotionTabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = new MotionTabController(vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Vehicle rental"),
        backgroundColor: Colors.redAccent,
      ),
      bottomNavigationBar: MotionTabBar(
        labels: [ "Home", "Account", "Rentals"],
        icons: [Icons.home, Icons.account_box, Icons.message],
        tabIconColor: Colors.amberAccent,
        tabSelectedColor: Colors.redAccent,
        initialSelectedTab: "Home",
        textStyle: TextStyle(color: Colors.red),
        onTabItemSelected: (int value){
          print(value);
          setState(() {
            _tabController.index = value;
          });
        },
      ),
      body: MotionTabBarView (
        controller: _tabController,
        children: <Widget>[
          VehicleOverview(),
          Account(),
          RentalChat()
        ],
      )
    );
  }
}