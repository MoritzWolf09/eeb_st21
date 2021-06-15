import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/vehicle.dart';
import 'package:my_app/vehicle_agruments.dart';
import 'package:my_app/vehicle_service.dart';
import 'package:provider/provider.dart';

class VehicleChange extends StatefulWidget {
  const VehicleChange({Key key}) : super(key: key);
  static const routeName = '/vehiclechange';

  @override
  _VehicleChangeState createState() => _VehicleChangeState();
}

class _VehicleChangeState extends State<VehicleChange> {
  String _dropdownValue = '';
  String _userId = '';
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _userId = context.watch<User>().uid;
    final args = ModalRoute.of(context).settings.arguments as VehicleArguments;
    _descriptionController.text = args.vehicle.description;
    _priceController.text = args.vehicle.price.toString();
    _dropdownValue = args.vehicle.type;

    return Scaffold(
        appBar: AppBar(
          title: Text("Change vehicle"),
          backgroundColor: Colors.redAccent,
        ),
        body: CustomScrollView(
          primary: false,
          slivers: <Widget>[
            SliverList(
                delegate: SliverChildListDelegate([
              buildInputField("Please enter description of vehicle",
                  _descriptionController),
              buildInputField(
                  "Please enter price of vehicle", _priceController),
              buildTypeDropdown(),
              buildSaveButton(args.vehicle.id)
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
      items: <String>['Mountain bike', 'City bike', 'Racing bike' '']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  buildSaveButton(id) {
    return Container(
        child: Center(
      child: ElevatedButton(
          child: const Text('Save changes'),
          style: ElevatedButton.styleFrom(primary: Colors.redAccent),
          onPressed: () => {saveVehicle(id)}),
    ));
  }

  saveVehicle(id) {
    Vehicle vehicle = new Vehicle();

    vehicle.id = id;
    vehicle.userId = _userId;
    vehicle.description = _descriptionController.text;
    vehicle.price = _priceController.text;
    vehicle.type = _dropdownValue;
    VehicleService().changeVehicle(vehicle);
    Navigator.pop(context);
  }
}
