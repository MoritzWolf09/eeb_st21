import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:motion_tab_bar/MotionTabBarView.dart';
import 'package:motion_tab_bar/MotionTabController.dart';
import 'package:motion_tab_bar/motiontabbar.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:my_app/account.dart';

class Map extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapStatefulWidget(),
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
        title: Text("Bike rental"),
        backgroundColor: Colors.redAccent,
      ),
      bottomNavigationBar: MotionTabBar(
        labels: [ "Home", "Account"],
        icons: [Icons.home, Icons.account_box],
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
          Container(
            child: new FlutterMap(
              options: new MapOptions(
                  center: new LatLng(50.93346374604487, 6.957014837247413)
              ),
              layers: [
                new TileLayerOptions(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c']
                ),
                new MarkerLayerOptions(
                    markers: [
                      new Marker(
                          width: 30,
                          height: 30,
                          point: new LatLng(50.93346374604487, 6.957014837247413),
                          builder: (context) => new Container(
                            child: createIcon(Icons.electric_bike),
                          )
                      ),
                      new Marker(
                          width: 30,
                          height: 30,
                          point: new LatLng(50.94316978542711, 6.95067259780526),
                          builder: (context) => new Container(
                            child: createIcon(Icons.electric_scooter)
                          )
                      )
                    ]
                )
              ],
            ),
          ),
          Account(),
          Container(
            child: Center(
              child: Text("Not necessary"),
            )
          )
        ],
      )
    );
  }

  createIcon(IconData icon) {
    return IconButton(
      icon: Icon(icon),
      color: Colors.redAccent,
      iconSize: 20.0,
      onPressed: () {
        EasyDialog(
          title: Text("Rent a thing"),
          description: Text("This is a basic dialog"),
          height: 500.0,
          width: 300.0
        ).show(context);
      },
    );
  }
}