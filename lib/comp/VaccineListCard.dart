// ignore_for_file: prefer_const_constructors

import 'package:digitalvaccinepassport/comp/VaccineCard.dart';
import 'package:flutter/material.dart';

import '../Screens/SingleVaccinePage.dart';

class VaccineListCard extends StatelessWidget {
  final String name;
  final String shortname;
  final String info;
  final String date;

  VaccineListCard(
      {required this.name,
      required this.shortname,
      required this.info,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SingleVaccinePage.forList(
            VaccineListCard(
                name: name, shortname: shortname, info: info, date: date),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 40,
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        Icons.medication,
                        color: Colors.blueGrey[900],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(shortname)
                    ],
                  ),
                ],
              ),
              Text(date)
            ],
          ),
        ),
      ),
    );
  }
}
