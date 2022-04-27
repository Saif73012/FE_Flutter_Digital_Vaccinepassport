// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:digitalvaccinepassport/comp/VaccineListCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../comp/VaccineCard.dart';

class SingleVaccinePage extends StatelessWidget {
  final VaccineCard? vaccine;
  final VaccineListCard? vaccineList;

  SingleVaccinePage([this.vaccine, this.vaccineList]);
  SingleVaccinePage.forList(this.vaccineList, {this.vaccine});

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
              height: 50,
            ),
            if (vaccine?.name != null) ...[
              Text(vaccine!.name),
              SizedBox(
                height: 10,
              ),
              Text(vaccine!.shortname),
              SizedBox(
                height: 10,
              ),
              Text(vaccine!.date),
              SizedBox(
                height: 10,
              ),
              Text(vaccine!.info),
            ] else if (vaccineList?.name != null) ...[
              Text(vaccineList!.name),
              SizedBox(
                height: 10,
              ),
              Text(vaccineList!.shortname),
              SizedBox(
                height: 20,
              ),
              Text(vaccineList!.date),
              SizedBox(
                height: 10,
              ),
              Text(vaccineList!.info),
              SizedBox(
                height: 30,
              ),
            ] else ...[
              Text('none')
            ]
          ],
        ),
      ),
    );
  }
}
