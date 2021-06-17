import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/vehicle.dart';
import 'package:my_app/services/vehicle_service.dart';
import 'package:provider/provider.dart';

class VehicleConfiguration extends StatefulWidget {
  const VehicleConfiguration({Key key}) : super(key: key);

  @override
  _VehicleConfigurationState createState() => _VehicleConfigurationState();
}

class _VehicleConfigurationState extends State<VehicleConfiguration> {
  String _dropdownValue = '';
  String _userId = '';
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _userId = context.watch<User>().uid;

    return Scaffold(
        appBar: AppBar(
          title: Text("Add vehicle"),
          backgroundColor: Colors.redAccent,
        ),
        body: CustomScrollView(
          primary: false,
          slivers: <Widget>[
            SliverList(
                delegate: SliverChildListDelegate([
              buildInputField("Please enter description of vehicle", _descriptionController),
              buildInputField("Please enter price of vehicle", _priceController),
              buildTypeDropdown(),
                  buildSaveButton()
            ]))
          ],
        ));
  }

  buildInputField(label, controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: label,
            ),
          ),
        ),
      ],
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

  buildTypeDropdown() {
    return DropdownButton<String>(
      isExpanded: true,
      value: _dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      onChanged: (String newValue) {
        setState(() {
          _dropdownValue = newValue;
        });
      },
      items: <String>['Mountain bike', 'City bike', '']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  buildSaveButton() {
    return Container(
      child: Center(
        child: ElevatedButton(
            child: const Text('Add vehicle'),
            style:
            ElevatedButton.styleFrom(primary: Colors.redAccent),
            onPressed: () => {
              saveVehicle()
            }),
      )
    );
  }

  saveVehicle() {
    Vehicle vehicle = new Vehicle();

    vehicle.userId = _userId;
    vehicle.description = _descriptionController.text;
    vehicle.price = _priceController.text;
    vehicle.type = _dropdownValue;
    VehicleService().addVehicle(vehicle);
    Navigator.pop(context);
  }
}
