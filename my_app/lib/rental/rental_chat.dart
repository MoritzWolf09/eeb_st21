import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:my_app/objects/rental.dart';
import 'package:my_app/rental/rental_detail.dart';
import 'package:my_app/services/rental_service.dart';
import 'package:my_app/services/storage_service.dart';
import 'package:my_app/services/vehicle_service.dart';
import 'package:provider/provider.dart';

class RentalChat extends StatefulWidget {
  const RentalChat({Key key}) : super(key: key);

  @override
  _RentalChatState createState() => _RentalChatState();
}

class _RentalChatState extends State<RentalChat> {
  String _userId;
  @override
  Widget build(BuildContext context) {
    _userId = context.watch<User>().uid;

    return CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverList(
            delegate: SliverChildListDelegate([
          buildRentalChat(context),
              buildRentalRequests(context)
        ]))
      ],
    );
  }

  buildRentalRequests(BuildContext context) {
    return FutureBuilder(
        future: RentalService().readRentalRequestsForRenter(_userId),
        builder: (BuildContext context, AsyncSnapshot result) {
          if (!result.hasData) {
            return Text("Loading");
          } else if (result.data != null) {
            return Container(
                child: Center(
                  child: GroupedListView<dynamic, String>(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    elements: convertResultToRental(result.data, "Your rental requests"),
                    groupBy: (element) => element.rentalType,
                    groupComparator: (value1, value2) => value2.compareTo(value1),
                    itemComparator: (item1, item2) =>
                        item1.rentalType.compareTo(item2.rentalType),
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
                              Navigator.pushNamed(context, RentalDetail.routeName,
                                  arguments: element)
                            },
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            title: Text(element.vehicleDescription),
                            subtitle: Text("Renter: " +
                                element.renterName +
                                " / Start date: " +
                                element.rentalStart),
                            trailing: Icon(Icons.arrow_forward),
                            leading: generateRenterAvatar(element.renterId),
                            isThreeLine: true,
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

  buildRentalChat(BuildContext context) {
    return FutureBuilder(
        future: RentalService().readRentalRequestsForUser(_userId),
        builder: (BuildContext context, AsyncSnapshot result) {
          if (!result.hasData) {
            return Text("Loading");
          } else if (result.data != null) {
            return Container(
                child: Center(
              child: GroupedListView<dynamic, String>(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                elements: convertResultToRental(result.data, "Rental requests"),
                groupBy: (element) => element.rentalType,
                groupComparator: (value1, value2) => value2.compareTo(value1),
                itemComparator: (item1, item2) =>
                    item1.rentalType.compareTo(item2.rentalType),
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
                          Navigator.pushNamed(context, RentalDetail.routeName,
                              arguments: element)
                        },
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        title: Text(element.vehicleDescription),
                        subtitle: Text("Renter: " +
                            element.renterName +
                            " / Start date: " +
                            element.rentalStart),
                        trailing: Icon(Icons.arrow_forward),
                        leading: generateRenterAvatar(element.renterId),
                        isThreeLine: true,
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

  List<Rental> convertResultToRental(
      QuerySnapshot<Map<String, dynamic>> result, type) {
    List<Rental> vehicles = [];

    result.docs.forEach((element) {
      vehicles.add(convertToRental(element, type));
    });

    return vehicles;
  }

  convertToRental(element, type) {
    Rental rental = new Rental();

    rental.vehicleId = element['vehicleId'];
    rental.vehicleDescription = element['vehicleDescription'];
    rental.renterId = element['renterId'];
    rental.renterName = element['renterName'];
    rental.ownerId = element['ownerId'];
    rental.ownerName = element['ownerName'];
    rental.rentalStart = element['rentalStart'];
    rental.rentalId = element.id;
    rental.status = element['status'];
    rental.rentalType = type;

    return rental;
  }

  generateRenterAvatar(userId) {
    return FutureBuilder(
        future: StorageService().getAvatarUrl(userId),
        builder: (BuildContext context, AsyncSnapshot result) {
          if (result.hasData) {
            return CircleAvatar(
              backgroundImage: NetworkImage(
                result.data,
              ),
              radius: 25,
            );
          } else {
            return CircleAvatar(
              child: Icon(
                Icons.person,
                size: 140,
              ),
              radius: 25,
            );
          }
        });
  }
}
