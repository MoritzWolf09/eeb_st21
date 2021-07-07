import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/services/authentication_service.dart';
import 'package:my_app/services/rating_service.dart';
import 'package:my_app/objects/vehicle.dart';
import 'package:my_app/services/storage_service.dart';
import 'package:my_app/objects/vehicle_agruments.dart';
import 'package:my_app/vehicle/vehicle_change.dart';
import 'package:my_app/vehicle/vehicle_configuration.dart';
import 'package:my_app/services/vehicle_service.dart';
import 'package:provider/provider.dart';

class Account extends StatefulWidget {
  const Account({Key key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  var imageFile;
  var _userId;

  @override
  Widget build(BuildContext context) {
    // Save User ID from session
    _userId = context.watch<User>().uid;

    return CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverList(
            delegate: SliverChildListDelegate([
          buildAccountSummary(context),
          buildLogoutButton(context),
          buildListHeader(context),
          buildVehicleList(context),
        ]))
      ],
    );
  }

  Row buildAccountSummary(BuildContext context) {
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
              children: [
                buildNumberVehicles(context),
                buildText("vehicle(s)")
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildRating(context),
                buildText("rating")
              ],
            ),
          ],
        )
      ],
    );
  }

  buildAvatarContainer() {
    return FutureBuilder(
        future: StorageService().getAvatarUrl(_userId),
        builder: (BuildContext context, AsyncSnapshot resultUrl) {
          if(!resultUrl.hasData || resultUrl.hasError) {
            return Container(
              padding: const EdgeInsets.all(8),
              child: Center(
                  child: CircularProfileAvatar(
                    null,
                    child: Icon(
                      Icons.person,
                      size: 140,
                    ),
                    onTap: () => {
                      Future_showChoiceDialog(context)
                    },
                    borderColor: Colors.black,
                    borderWidth: 3,
                    elevation: 5,
                    radius: 75,
                  )),
            );
          } else {
            return Container(
              padding: const EdgeInsets.all(8),
              child: Center(
                  child: CircularProfileAvatar(
                    null,
                    child: Image.network(
                        resultUrl.data,
                      height: 140,
                      width: 140,
                    ),
                    onTap: () => {
                      Future_showChoiceDialog(context)
                    },
                    borderColor: Colors.black,
                    borderWidth: 3,
                    elevation: 5,
                    radius: 75,
                  )),
            );
          }
        }
    );
  }

  Future_showChoiceDialog(BuildContext context)
  {
    return showDialog(context: context,builder: (BuildContext context){

      return AlertDialog(
        title: Text("Choose option",style: TextStyle(color: Colors.redAccent),),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Divider(height: 1,color: Colors.yellowAccent,),
              ListTile(
                onTap: (){
                  _openGallery(context);
                },
                title: Text("Gallery"),
                leading: Icon(Icons.account_box,color: Colors.redAccent,),
              ),

              Divider(height: 1,color: Colors.yellowAccent,),
              ListTile(
                onTap: (){
                  _openCamera(context);
                },
                title: Text("Camera"),
                leading: Icon(Icons.camera,color: Colors.redAccent,),
              ),
            ],
          ),
        ),);
    });
  }

  void _openGallery(BuildContext context) async{
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery ,
    );

    setState(() {
      imageFile = pickedFile;
    });
  }

  void _openCamera(BuildContext context)  async{
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera ,
    );

    setState(() {
      imageFile = pickedFile;
    });
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
        future: VehicleService().readVehicleOfUser(_userId),
        builder: (BuildContext context, AsyncSnapshot result) {
          if (!result.hasData) {
            return Text("Loading");
          } else if (result.data != null) {
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
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                    child: Container(
                      child: ListTile(
                        onTap: () => {
                          Navigator.pushNamed(context, VehicleChange.routeName,
                              arguments: VehicleArguments(element))
                        },
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
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
    vehicle.price = e['price'];
    vehicle.id = e.id;

    return vehicle;
  }

  buildListHeader(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [buildBoldText("Your vehicle list")],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                        child: const Text('Add vehicle'),
                        style:
                            ElevatedButton.styleFrom(primary: Colors.redAccent),
                        onPressed: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VehicleConfiguration()))
                            }),
                  ),
                )
              ],
            ),
          ])
    ]);
  }

  buildRating(BuildContext context) {
    return FutureBuilder(
      future: RatingService().readVehicleOfUser(context.watch<User>().uid),
      builder: (BuildContext context, AsyncSnapshot result) {
        if(!result.hasData) {
          return Text("loading");
        } else if(result.hasData) {
          return buildBoldText(getRating(result.data).toString());
        } else {
          return Text("Error");
        }
      },
    );
  }

  getRating(
      QuerySnapshot<Map<String, dynamic>> data) {
    double rating=0;
    int numberRatings=0;

    data.docs.forEach((element) {
      rating = rating + element['rating'];
      numberRatings++;
    });

    return rating/numberRatings;
  }

  buildNumberVehicles(BuildContext context) {
    return FutureBuilder(
      future: VehicleService().readVehicleOfUser(context.watch<User>().uid),
      builder: (BuildContext context, AsyncSnapshot result) {
        if(!result.hasData) {
          return Text("loading");
        } else if(result.hasData) {
          return buildBoldText(result.data.size.toString());
        } else {
          return Text("Error");
        }
      },
    );
  }
}
