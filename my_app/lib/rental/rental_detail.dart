import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:my_app/objects/rental.dart';
import 'package:my_app/services/rating_service.dart';
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
  var _rental;

  @override
  Widget build(BuildContext context) {
    _userId = context.watch<User>().uid;
    _rental = ModalRoute.of(context).settings.arguments as Rental;

    return Scaffold(
      body: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          SliverList(
              delegate: SliverChildListDelegate([
                buildRenterAvatar(context),
                buildRenterRating(context)
              ]))
        ],
      ),
    );
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
}
