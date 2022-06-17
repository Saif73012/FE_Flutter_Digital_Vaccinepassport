// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:digitalvaccinepassport/comp/VaccineListCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../comp/VaccineCard.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleVaccinePage extends StatelessWidget {
  final VaccineCard? vaccine;
  final VaccineListCard? vaccineList;

  SingleVaccinePage([this.vaccine, this.vaccineList]);
  SingleVaccinePage.forList(this.vaccineList, {this.vaccine});
  Uri? _url;

  void _launchUrl() async {
    if (vaccine?.name != null) {
      _url = Uri.parse(vaccine!.url);
    } else {
      _url = Uri.parse(vaccineList!.url);
    }
    if (!await launchUrl(_url!)) {
      throw 'CouldUri.parse( not launch  $_url';
    }
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
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            if (vaccine?.name != null) ...[
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      'Name: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(vaccine!.name),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      'Vaccination for: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(vaccine!.vaccination),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      'Expiry date: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today),
                        Text(vaccine!.expireDate),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      'Date of Vaccination: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today),
                        Text(vaccine!.date),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  /* decoration: BoxDecoration(color: Colors.grey[400]), */
                  margin: EdgeInsets.symmetric(horizontal: 50, vertical: 0),
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                  child: Text(
                    vaccine!.info,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              //PatientHomeScreen Click

              Center(
                widthFactor: 20,
                child: FloatingActionButton.extended(
                  heroTag: 'navigate_to_Link_src',
                  label: Text('Click here to learn more'), // <-- Text
                  backgroundColor: Colors.black,
                  icon: Icon(
                    Icons.web_sharp,
                    size: 24.0,
                  ),
                  onPressed: () {
                    _launchUrl();
                  },
                ),
              ),
              SizedBox(
                height: 20,
              )
            ] else if (vaccineList?.name != null) ...[
              //ListAllVaccine Click

              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      'Name: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(vaccineList!.name),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      'Vaccination for: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(vaccineList!.vaccination),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      'Expiry date: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today),
                        Text(vaccineList!.expireDate),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      'Date of Vaccination: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today),
                        Text(vaccineList!.date),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  /* decoration: BoxDecoration(color: Colors.grey[400]), */
                  margin: EdgeInsets.symmetric(horizontal: 50, vertical: 0),
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                  child: Text(
                    vaccineList!.info,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              //PatientHomeScreen Click

              Center(
                widthFactor: 20,
                child: FloatingActionButton.extended(
                  heroTag: 'navigate_to_Link_src',
                  label: Text('Click here to learn more'), // <-- Text
                  backgroundColor: Colors.black,
                  icon: Icon(
                    Icons.web_sharp,
                    size: 24.0,
                  ),
                  onPressed: () {
                    _launchUrl();
                  },
                ),
              ),
              SizedBox(
                height: 20,
              )
            ] else ...[
              Center(
                  child: Text(
                'no vaccinedetails',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ))
            ]
          ],
        ),
      ),
    );
  }
}
