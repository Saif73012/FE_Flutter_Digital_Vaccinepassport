// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../comp/VaccineListCard.dart';

class ListAllVaccinePage extends StatelessWidget {
  ListAllVaccinePage({Key? key}) : super(key: key);

  final List AllVaccinesList = [
    // name , shortname , info , date
    ['Astrazenica', 'Astra', 'Impfung gegen Covid-19', '20.02.2021'],
    ['JohnsenJohnsen', 'J&J', 'Impfung gegen Covid-19', '20.08.2021'],
    ['Biontech Pfizer', 'Pfizer', 'Impfung gegen Covid-19', '20.01.2022'],
    ['Astrazenica', 'Astra', 'Impfung gegen Covid-19', '20.02.2021'],
    ['JohnsenJohnsen', 'J&J', 'Impfung gegen Covid-19', '20.08.2021'],
    ['Biontech Pfizer', 'Pfizer', 'Impfung gegen Covid-19', '20.01.2022'],
    ['Astrazenica', 'Astra', 'Impfung gegen Covid-19', '20.02.2021'],
    ['JohnsenJohnsen', 'J&J', 'Impfung gegen Covid-19', '20.08.2021'],
    ['Biontech Pfizer', 'Pfizer', 'Impfung gegen Covid-19', '20.01.2022']
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
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 20,
        ),
        Padding(
            padding: EdgeInsets.only(left: 25, right: 25),
            child: Text(
              'List of All Vaccines',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            )),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: ListView.builder(
              itemCount: AllVaccinesList.length,
              itemBuilder: (context, index) {
                return VaccineListCard(
                  name: AllVaccinesList[index][0],
                  shortname: AllVaccinesList[index][1],
                  info: AllVaccinesList[index][2],
                  date: AllVaccinesList[index][3],
                );
              }),
        )),
        SizedBox(
          height: 20,
        ),
      ]),
    );
  }
}
