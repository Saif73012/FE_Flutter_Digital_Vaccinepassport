// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AddVaccinePage extends StatelessWidget {
  const AddVaccinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[300],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Column(
          children: [Text('data')],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 25, right: 25),
              child: Text(
                'Add new Vaccine',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 50, right: 50),
              child: Container(
                child: QrImage(
                  data: "1234567890",
                  version: QrVersions.auto,
                  size: 250,
                ),
                width: double.infinity,
                height: 250,
                padding: EdgeInsets.all(5),
                color: Colors.grey[400],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              widthFactor: 20,
              child: FloatingActionButton.extended(
                heroTag: 'navigate to AddVaccinePage',
                label: Text('Click here to Add a new Vaccine'), // <-- Text
                backgroundColor: Colors.black,
                icon: Icon(
                  // <-- Icon
                  Icons.medication,
                  size: 24.0,
                ),
                onPressed: () {
                  /*  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddVaccinePage())); */
                  print('object');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
