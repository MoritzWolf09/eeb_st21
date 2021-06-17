import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/services/user_service.dart';
import 'package:my_app/vehicle.dart';
import 'package:my_app/vehicle_agruments.dart';
import 'package:my_app/vehicle_details.dart';
import 'package:my_app/services/vehicle_service.dart';
import 'package:provider/provider.dart';

class VehicleOverview extends StatefulWidget {
  const VehicleOverview({Key key}) : super(key: key);

  @override
  _VehicleOverviewState createState() => _VehicleOverviewState();
}

class _VehicleOverviewState extends State<VehicleOverview> {
  String _value = 'E-Bike';
  String _userId;

  @override
  Widget build(BuildContext context) {
    _userId = context.watch<User>().uid;
    return Scaffold(
      appBar: new AppBar(
          title: new DropdownButton<String>(
        value: _value,
        items: <DropdownMenuItem<String>>[
          new DropdownMenuItem(
            child: new Text('E-Bike'),
            value: 'E-Bike',
          ),
          new DropdownMenuItem(
              child: new Text('Mountain bike'), value: 'Mountain Bike'),
        ],
        onChanged: (String value) {
          setState(() => _value = value);
        },
      )),
      body: buildVehileList(),
    );
  }

  Card buildVehicleCard(vehicle, icon) {
    return Card(
        child: Container(
      child: ListTile(
        onTap: () => {
          Navigator.pushNamed(context, VehicleDetails.routeName, arguments: VehicleArguments(vehicle))
        },
        leading: Icon(
          icon,
          size: 13,
        ),
        title: Text(
          vehicle.description,
          textScaleFactor: 0.8,
        ),
        subtitle: buildUserName(),
      ),
    ));
  }

  buildVehileList() {
    return FutureBuilder(
        future: VehicleService().readVehicles(),
        builder: (BuildContext context, AsyncSnapshot result) {
          if (!result.hasData) {
            return Text("Loading vehicles");
          } else if (result.hasData != null) {
            return CustomScrollView(
              primary: false,
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.all(10),
                  sliver: SliverGrid.count(
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    crossAxisCount: 2,
                    childAspectRatio: 2,
                    children: getVehicles(result, context),
                  ),
                ),
              ],
            );
          } else {
            return Text("Error loading data");
          }
        });
  }

  List<Widget> getVehicles(result, BuildContext context) {
    var vehicles = convertResultToVehicle(result.data);

    return vehicles
        .map((e) =>
            buildVehicleCard(e, Icons.directions_bike))
        .toList();
  }

  List<Vehicle> convertResultToVehicle(
      QuerySnapshot<Map<String, dynamic>> result) {
    List<Vehicle> vehicles = [];

    result.docs.forEach((element) {
      vehicles.add(convertToVehicle(element));
    });

    return vehicles;
  }

  Vehicle convertToVehicle(QueryDocumentSnapshot<Map<String, dynamic>> e) {
    Vehicle vehicle = new Vehicle();

    vehicle.userId = e['userId'];
    vehicle.description = e['description'];
    vehicle.type = e['type'];
    vehicle.price = e['price'];

    return vehicle;
  }

  buildUserName() {
    return FutureBuilder(
    future: UserService().readUserInformation(_userId),
    builder: (BuildContext context, AsyncSnapshot result) {
      if(!result.hasData) {
        return Text("loading");
      } else if(result.hasData) {
        return Text(
          result.data.docs[0]['nickname'],
          textScaleFactor: 0.8,
        );
      } else {
        return Text("Error");
      }
    },
  );
  }
}
