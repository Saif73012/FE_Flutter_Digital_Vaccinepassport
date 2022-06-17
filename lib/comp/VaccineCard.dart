// ignore_for_file: prefer_const_constructors

import 'package:digitalvaccinepassport/Screens/SingleVaccinePage.dart';
import 'package:flutter/material.dart';

class VaccineCard extends StatelessWidget {
  final String name;
  final String vaccination;
  final String info;
  final String expireDate;
  final String date;
  final String url;

  VaccineCard(
      {required this.name,
      required this.vaccination,
      required this.info,
      required this.expireDate,
      required this.date,
      required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SingleVaccinePage(
            VaccineCard(
              name: name,
              vaccination: vaccination,
              info: info,
              expireDate: expireDate,
              url: url,
              date: date,
            ),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 150,
            padding: EdgeInsets.all(12),
            color: Colors.grey[400],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        height: 30,
                        child: Icon(
                          Icons.medication,
                          color: Colors.blueGrey[900],
                        )),
                  ],
                ),
                Text(name),
                Text(date),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
