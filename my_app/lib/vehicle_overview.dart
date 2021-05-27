import 'package:flutter/material.dart';
import 'package:my_app/vehicle_details.dart';

class VehicleOverview extends StatefulWidget {
  const VehicleOverview({Key key}) : super(key: key);

  @override
  _VehicleOverviewState createState() => _VehicleOverviewState();
}

class _VehicleOverviewState extends State<VehicleOverview> {
  String _value = 'E-Bike';

  @override
  Widget build(BuildContext context) {
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
                  child: new Text('Mountain bike'),
                  value: 'Mountain Bike'
              ),
            ],
            onChanged: (String value) {
              setState(() => _value = value);
            },)
      ),
      body: buildVehileList(),
    );
  }

  Card buildVehicleCard(title, icon, owner) {
    return Card(
        child: Container(
          child: ListTile(
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) => VehicleDetails()))
            },
            leading: Icon(icon, size: 13,),
            title: Text(title, textScaleFactor: 0.8,),
            subtitle: Text(owner, textScaleFactor: 0.8,),
          ),
        ));
  }

  buildVehileList() {
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
            children: <Widget>[
              buildVehicleCard("Stevens S7", Icons.directions_bike, "Moritz"),
              buildVehicleCard("Stevens Aspin", Icons.directions_bike, "Patrick"),
              buildVehicleCard("E-Scooter", Icons.electric_scooter, "Michael"),
              buildVehicleCard("VW T5 Camper", Icons.car_rental, "Susanne"),
              buildVehicleCard("Cargo Bike", Icons.directions_bike, "Heinz"),
              buildVehicleCard("Stevens S7", Icons.directions_bike, "Moritz"),
              buildVehicleCard("Stevens Aspin", Icons.directions_bike, "Patrick"),
              buildVehicleCard("E-Scooter", Icons.electric_scooter, "Michael"),
              buildVehicleCard("VW T5 Camper", Icons.car_rental, "Susanne"),
              buildVehicleCard("Cargo Bike", Icons.directions_bike, "Heinz"),
              buildVehicleCard("Stevens S7", Icons.directions_bike, "Moritz"),
              buildVehicleCard("Stevens Aspin", Icons.directions_bike, "Patrick"),
              buildVehicleCard("E-Scooter", Icons.electric_scooter, "Michael"),
              buildVehicleCard("VW T5 Camper", Icons.car_rental, "Susanne"),
              buildVehicleCard("Cargo Bike", Icons.directions_bike, "Heinz"),
              buildVehicleCard("Stevens S7", Icons.directions_bike, "Moritz"),
              buildVehicleCard("Stevens Aspin", Icons.directions_bike, "Patrick"),
              buildVehicleCard("E-Scooter", Icons.electric_scooter, "Michael"),
              buildVehicleCard("VW T5 Camper", Icons.car_rental, "Susanne"),
              buildVehicleCard("Cargo Bike", Icons.directions_bike, "Heinz"),
            ],
          ),
        ),
      ],
    );
  }
}
