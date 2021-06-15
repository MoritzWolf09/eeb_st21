import 'package:flutter/material.dart';
import 'package:background_app_bar/background_app_bar.dart';
import 'package:my_app/vehicle_agruments.dart';

class VehicleDetails extends StatefulWidget {
  const VehicleDetails({Key key}) : super(key: key);
  static const routeName = '/vehicleDetails';

  @override
  _VehicleDetailsState createState() => _VehicleDetailsState();
}

class _VehicleDetailsState extends State<VehicleDetails> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as VehicleArguments;

    return new Scaffold(
      body: new NestedScrollView(
        headerSliverBuilder: (_, __) => <Widget>[
          new SliverAppBar(
            toolbarHeight: 200,
            floating: false,
            pinned: true,
            snap: false,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            flexibleSpace: new BackgroundFlexibleSpaceBar(
              title: Text(args.vehicle.description),
              centerTitle: false,
              titlePadding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
              background: new ClipRect(
                child: new Container(
                  child: new Container(
                    decoration: new BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  decoration: new BoxDecoration(
                      image: new DecorationImage(
                    image: new AssetImage(
                      "assets/aspin.jpg",
                    ),
                    fit: BoxFit.fill,
                  )),
                ),
              ),
            ),
          ),
        ],
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                "Photo by Matt Artz on Unsplash",
              ),
              new Text(
                "You have pushed the button this many times:",
              ),
              new Text("Test"),
            ],
          ),
        ),
      ),
    );
  }
}
