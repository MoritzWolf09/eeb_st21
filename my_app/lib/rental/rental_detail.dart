import 'package:background_app_bar/background_app_bar.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:my_app/objects/rental.dart';
import 'package:my_app/services/rating_service.dart';
import 'package:my_app/services/rental_service.dart';
import 'package:my_app/services/storage_service.dart';
import 'package:provider/provider.dart';

class RentalDetail extends StatefulWidget {
  const RentalDetail({Key key}) : super(key: key);
  static const routeName = '/rentalDetail';

  @override
  _RentalDetailState createState() => _RentalDetailState();
}

class _RentalDetailState extends State<RentalDetail> {
  var _userId;
  Rental _rental;

  @override
  Widget build(BuildContext context) {
    _userId = context.watch<User>().uid;
    _rental = ModalRoute.of(context).settings.arguments as Rental;

    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (_, __) => <Widget>[
                  new SliverAppBar(
                      toolbarHeight: 200,
                      floating: false,
                      pinned: true,
                      snap: false,
                      elevation: 0.0,
                      backgroundColor: Colors.transparent,
                      flexibleSpace: new BackgroundFlexibleSpaceBar(
                        title: buildRenterAvatar(context),
                        centerTitle: false,
                        titlePadding:
                            const EdgeInsets.only(left: 20.0, bottom: 20.0),
                        background: new ClipRect(
                          child: new Container(
                            child: new Container(
                              decoration: new BoxDecoration(
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ),
                      ))
                ],
            body: CustomScrollView(primary: false, slivers: <Widget>[
              SliverList(
                  delegate: SliverChildListDelegate([
                buildRenterRating(context),
                buildRentalStart(),
                buildVehicleInformation(),
                buildRentalButton()
              ]))
            ])));
  }

  buildRenterAvatar(BuildContext context) {
    return FutureBuilder(
        future: StorageService().getAvatarUrl(_rental.renterId),
        builder: (BuildContext context, AsyncSnapshot resultUrl) {
          if (!resultUrl.hasData || resultUrl.hasError) {
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
                borderColor: Colors.black,
                borderWidth: 3,
                elevation: 5,
                radius: 75,
              )),
            );
          }
        });
  }

  buildRenterRating(BuildContext context) {
    return FutureBuilder(
      future: RatingService().readVehicleOfUser(_rental.renterId),
      builder: (BuildContext context, AsyncSnapshot result) {
        if (!result.hasData) {
          return Text("loading");
        } else if (result.hasData) {
          return Center(
            child: RatingBar.builder(
              initialRating: getRating(result.data),
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
            ),
          );
        } else {
          return Text("Error");
        }
      },
    );
  }

  getRating(QuerySnapshot<Map<String, dynamic>> data) {
    double rating = 0;
    int numberRatings = 0;

    data.docs.forEach((element) {
      rating = rating + element['rating'];
      numberRatings++;
    });

    return rating / numberRatings;
  }

  buildRentalStart() {
    return Container(
      padding: const EdgeInsets.fromLTRB(2, 20, 8, 2),
      child: Center(
        child: Text("Rental start date: " + _rental.rentalStart,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
    );
  }

  buildVehicleInformation() {
    return Container(
      padding: const EdgeInsets.fromLTRB(2, 20, 8, 2),
      child: Center(
        child: Text("Vehicle: " + _rental.vehicleDescription,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
    );
  }

  buildRentalButton() {
    if (_rental.status == 0) {
      return Container(
          child: Center(
              child: ElevatedButton(
        child: const Text('Accept rental'),
        style: ElevatedButton.styleFrom(primary: Colors.redAccent),
        onPressed: () {
          RentalService().acceptRentalRequest(_rental);
          Navigator.pop(context);
        },
      )));
    } else if (_rental.status == 1) {
      return Container(
          child: Center(
              child: ElevatedButton(
        child: const Text('Close rental'),
        style: ElevatedButton.styleFrom(primary: Colors.redAccent),
        onPressed: () {
          RentalService().closeRentalRequest(_rental);
          Navigator.pop(context);
        },
      )));
    } else if (_rental.status == 2) {
      return Container(
          child: Center(
        child: RatingBar.builder(
          initialRating: 0,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          glow: true,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return Icon(
                  Icons.sentiment_very_dissatisfied,
                  color: Colors.red,
                );
              case 1:
                return Icon(
                  Icons.sentiment_dissatisfied,
                  color: Colors.redAccent,
                );
              case 2:
                return Icon(
                  Icons.sentiment_neutral,
                  color: Colors.amber,
                );
              case 3:
                return Icon(
                  Icons.sentiment_satisfied,
                  color: Colors.lightGreen,
                );
              case 4:
                return Icon(
                  Icons.sentiment_very_satisfied,
                  color: Colors.green,
                );
            }
          },
          onRatingUpdate: (rating) {
            print("rating " + rating.toString());
          },
        ),
      ));
    }

    return Container();
  }
}
