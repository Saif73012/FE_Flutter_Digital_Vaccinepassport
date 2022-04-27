// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:digitalvaccinepassport/Screens/AddVaccinePage.dart';
import 'package:digitalvaccinepassport/Screens/ListAllVaccinePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';
import '../API/api.dart';
import '../comp/VaccineCard.dart';

class PatientHomeScreen extends StatefulWidget {
  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  String? email;
  String? token;
  String? username;
  String? id;

  @override
  void initState() {
    super.initState();
    initial();
  }

  getUserInfo() async {
    print('vor res');
    var res = await BECall().getUserInfoById(id!, 'patient', token!);
    print('nach res');
    var body = json.decode(res.body);
    print(body);
  }

  decodeJwt() {
    Map<String, dynamic> payload = Jwt.parseJwt(token!);
    String s = payload.toString();
    var splitted = s.split(",");
    splitted.forEach((e) {
      if (e.startsWith("username:")) {
        username = e; // method for splitting
      }
      if (e.startsWith("_id:")) {
        id = e;
      }
    });
  }

  getToken() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = logindata.getString('token');
    token = stringValue;
    decodeJwt();
  }

  void initial() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    setState(() {
      email = logindata.getString('email');
    });
    getToken();
    getUserInfo();
  }

  /* get call with id --> decode jwt 
  1. set token into sharedpref store
  2. use jwt in homescreen and make get call to get all information - username, vacines,
  3. set variables and show them (look up future Builder)
  4. set VaccineList and show  */

  final List VaccinesList = [
    // name , shortname , info , date
    ['Astrazenica', 'Astra', 'Impfung gegen Covid-19', '20.02.2021'],
    ['JohnsenJohnsen', 'J&J', 'Impfung gegen Covid-19', '20.08.2021'],
    ['Biontech Pfizer', 'Pfizer', 'Impfung gegen Covid-19', '20.01.2022'],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.only(left: 25, right: 25),
              child: Container(
                child: Center(child: Text('Hello $email!')),
                width: double.infinity,
                height: 50,
                padding: EdgeInsets.all(10),
                color: Colors.grey[400],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: Text(
                  'Add new Vaccine',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                )),
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
                  getToken();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddVaccinePage()));
                },
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: Text(
                  'Last Vaccines',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                itemCount: VaccinesList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: ((context, index) {
                  return VaccineCard(
                    name: VaccinesList[index][0],
                    shortname: VaccinesList[index][1],
                    info: VaccinesList[index][2],
                    date: VaccinesList[index][3],
                  );
                }),
              ),
            ),
            SizedBox(
              height: 60,
            ),
            Center(
              widthFactor: 20,
              child: FloatingActionButton.extended(
                heroTag: 'navigate to ListAllVaccinePage',
                label: Text('List all Vaccines'), // <-- Text
                backgroundColor: Colors.black,
                icon: Icon(
                  // <-- Icon
                  Icons.keyboard_arrow_right_rounded,
                  size: 24.0,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListAllVaccinePage()));
                },
              ),
            ),
          ],
        ));
  }
}
