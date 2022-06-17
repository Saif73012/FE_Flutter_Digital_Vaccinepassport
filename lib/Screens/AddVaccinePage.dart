// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'qrCode.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddVaccinePage extends StatefulWidget {
  const AddVaccinePage({Key? key}) : super(key: key);

  @override
  State<AddVaccinePage> createState() => _AddVaccinePageState();
}

class _AddVaccinePageState extends State<AddVaccinePage> {
  String? token = '';

  getId() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    token = logindata.getString('token');
  }

  @override
  void initState() {
    super.initState();
    getId();
  }

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
              padding: EdgeInsets.all(50),
              child: Container(
                child: FutureBuilder(
                  builder: (snapshot, context) {
                    return QrImage(
                      data: token!,
                      version: QrVersions.auto,
                      size: 250,
                    );
                  },
                  future: getId(),
                ),
                padding: EdgeInsets.all(20),
                color: Colors.grey[400],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              widthFactor: 20,
              child: FloatingActionButton.extended(
                heroTag: 'navigate_back_to_HomePage',
                label:
                    Text('Click here to go back to the HomePage'), // <-- Text
                backgroundColor: Colors.black,
                icon: Icon(
                  Icons.arrow_left,
                  size: 24.0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
