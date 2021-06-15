import 'package:animated_dialog_box/animated_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:background_app_bar/background_app_bar.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:my_app/vehicle_agruments.dart';
import 'package:intl/intl.dart';

class VehicleDetails extends StatefulWidget {
  const VehicleDetails({Key key}) : super(key: key);
  static const routeName = '/vehicleDetails';

  @override
  _VehicleDetailsState createState() => _VehicleDetailsState();
}

class _VehicleDetailsState extends State<VehicleDetails> {
  final _priceController = TextEditingController();
  DateTime dateTime = DateTime.now();
  var vehicle;

  @override
  Widget build(BuildContext context) {
    vehicle = ModalRoute.of(context).settings.arguments as VehicleArguments;
    _priceController.text = vehicle.vehicle.price;

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
              title: Text(vehicle.vehicle.description),
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              buildOwnerInformation(),
              buildRatingInformation(),
              buildInputField("Price", _priceController),
              buildRentalStart(),
              buildRentalButton()
            ],
          ),
        ),
      ),
    );
  }

  buildInputField(label, controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: label,
            ),
          ),
        ),
      ],
    );
  }

  buildRentalButton() {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      color: Colors.white,
      child: Text('Start rental request'),
      onPressed: () async {
        await animated_dialog_box.showScaleAlertBox(
            title: Center(child: Text("Rent vehicle")), // IF YOU WANT TO ADD
            context: context,
            firstButton: MaterialButton(
              // FIRST BUTTON IS REQUIRED
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              color: Colors.white,
              child: Text('Create rental request'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            secondButton: MaterialButton(
              // OPTIONAL BUTTON
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              color: Colors.white,
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            icon: Icon(
              Icons.info_outline,
              color: Colors.red,
            ), // IF YOU WANT TO ADD ICON
            yourWidget: Container(
              child: Text('This is my first package'),
            ));
      },
    );
  }

  buildRentalStart() {
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
              mainAxisSize: MainAxisSize.max,
              children: [buildText("Rental start date")],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  DateFormat('dd.MM.yyyy').format(dateTime),
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  color: Colors.white,
                  child: Icon(Icons.date_range),
                  onPressed: () async {
                    DateTime newDateTime = await showRoundedDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(DateTime.now().year - 1),
                      lastDate: DateTime(DateTime.now().year + 1),
                      borderRadius: 2,
                    );
                    if (newDateTime != null) {
                      setState(() => dateTime = newDateTime);
                    }
                  },
                )
              ],
            ),
          ],
        )
      ],
    );
  }

  Container buildText(text) {
    return Container(
      padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
      child: Text(text),
    );
  }

  buildOwnerInformation() {
    return Container(
      padding: const EdgeInsets.fromLTRB(2, 20, 2, 20),
      child: Text(vehicle.vehicle.userId),
    );
  }

  buildRatingInformation() {
    return RatingBar.builder(
      initialRating: 4.5,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      glow: true,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
    );
  }
}
