import 'package:flutter/material.dart';
import 'package:my_app/authentication_service.dart';
import 'package:provider/provider.dart';

class Map extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("HOME"),
            ElevatedButton(onPressed: () {
              context.read<AuthenticationService>().signOut();
            }, child: Text("Sign out")),
          ],
        ),
      )
    );
  }
}