import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:my_app/authentication_service.dart';
import 'package:my_app/vehicle.dart';
import 'package:my_app/vehicle_service.dart';
import 'package:provider/provider.dart';

class Account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverList(
            delegate: SliverChildListDelegate([
          buildSummary(),
          buildLogoutButton(context),
          buildBoldText("Your vehicle list"),
          buildVehicleList(context),
        ]))
      ],
    );
  }

  Row buildSummary() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [buildAvatarContainer()],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [buildBoldText("6"), buildText("vehicle(s)")],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [buildBoldText("94"), buildText("rental(s)")],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [buildBoldText("4,3"), buildText("rating")],
            ),
          ],
        )
      ],
    );
  }

  Container buildAvatarContainer() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Center(
          child: CircularProfileAvatar(
        null,
        child: Icon(
          Icons.person,
          size: 140,
        ),
        borderColor: Colors.black,
        borderWidth: 3,
        elevation: 5,
        radius: 75,
      )),
    );
  }

  Container buildText(text) {
    return Container(
      padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
      child: Text(text),
    );
  }

  Container buildBoldText(text) {
    return Container(
      padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
      child: Text(text,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
    );
  }

  buildVehicleList(BuildContext context) {
    return FutureBuilder(
        future: VehicleService().readVehicleOfUser(context.watch<User>().uid),
        builder: (BuildContext context, AsyncSnapshot result) {
          if (!result.hasData) {
            return Text("Loading");
          } else if(result.data != null){
            return Container(
                child: Center(
                  child: GroupedListView<dynamic, String>(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    elements: convertResultToVehicle(result.data),
                    groupBy: (element) => element.type,
                    groupComparator: (value1, value2) => value2.compareTo(value1),
                    itemComparator: (item1, item2) =>
                        item1.description.compareTo(item2.description),
                    order: GroupedListOrder.DESC,
                    useStickyGroupSeparators: true,
                    groupSeparatorBuilder: (String value) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        value,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    itemBuilder: (c, element) {
                      return Card(
                        elevation: 8.0,
                        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                        child: Container(
                          child: ListTile(
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                            leading: Icon(Icons.account_circle),
                            title: Text(element.description),
                            trailing: Icon(Icons.arrow_forward),
                          ),
                        ),
                      );
                    },
                  ),
                ));
          } else {
            return Text("Error while loading...");
          }
        });
  }

  buildLogoutButton(BuildContext context) {
    return Container(
      child: Center(
        child: ElevatedButton(
            child: const Text('Logout'),
            style: ElevatedButton.styleFrom(primary: Colors.redAccent),
            onPressed: () => {context.read<AuthenticationService>().signOut()}),
      ),
    );
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

    return vehicle;
  }
}
