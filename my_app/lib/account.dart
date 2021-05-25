import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:my_app/authentication_service.dart';
import 'package:slider_button/slider_button.dart';
import 'package:provider/provider.dart';

class Account extends StatelessWidget {
  List _elements = [
    {'name': 'Rennrad Stevens Aspin', 'group': 'Bike'},
    {'name': 'Mountain Bike Stevens S7', 'group': 'Bike'},
    {'name': 'Z E-Bike', 'group': 'E-Bike'},
    {'name': 'VW T5 Transporter', 'group': 'Car'},
    {'name': 'XY E-Bike', 'group': 'E-Bike'},
    {'name': 'Cargo Donkey', 'group': 'Cargo bike'},
  ];

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
          buildVehicleList(),
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

  buildVehicleList() {
    return Container(
        child: Center(
      child: GroupedListView<dynamic, String>(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        elements: _elements,
        groupBy: (element) => element['group'],
        groupComparator: (value1, value2) => value2.compareTo(value1),
        itemComparator: (item1, item2) =>
            item1['name'].compareTo(item2['name']),
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
                title: Text(element['name']),
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
          );
        },
      ),
    ));
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
}
