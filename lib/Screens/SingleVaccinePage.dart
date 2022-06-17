// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

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
    } //$_url
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
          icon: const Icon(
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
            const SizedBox(
              height: 25,
            ),
            if (vaccine?.name != null) ...[
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    const Text(
                      'Name: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
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
                    const Text(
                      'Vaccination for: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
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
                    const Text(
                      'Expiry date: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.calendar_today),
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
                    const Text(
                      'Date of Vaccination: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.calendar_today),
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
                  margin:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 0),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                  child: Text(
                    vaccine!.info,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                        fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //PatientHomeScreen Click

              Center(
                widthFactor: 20,
                child: FloatingActionButton.extended(
                  heroTag: 'navigate_to_Link_src',
                  label: const Text('Click here to learn more'), // <-- Text
                  backgroundColor: Colors.black,
                  icon: const Icon(
                    Icons.web_sharp,
                    size: 24.0,
                  ),
                  onPressed: () {
                    _launchUrl();
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ] else if (vaccineList?.name != null) ...[
              //ListAllVaccine Click

              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    const Text(
                      'Name: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
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
                    const Text(
                      'Vaccination for: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
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
                    const Text(
                      'Expiry date: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.calendar_today),
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
                    const Text(
                      'Date of Vaccination: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.calendar_today),
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
                  margin:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 0),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                  child: Text(
                    vaccineList!.info,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                        fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //PatientHomeScreen Click

              Center(
                widthFactor: 20,
                child: FloatingActionButton.extended(
                  heroTag: 'navigate_to_Link_src',
                  label: const Text('Click here to learn more'), // <-- Text
                  backgroundColor: Colors.black,
                  icon: const Icon(
                    Icons.web_sharp,
                    size: 24.0,
                  ),
                  onPressed: () {
                    _launchUrl();
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ] else ...[
              const Center(
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
