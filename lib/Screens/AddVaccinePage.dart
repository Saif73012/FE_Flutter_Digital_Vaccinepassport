//  prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            const Padding(
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
              padding: const EdgeInsets.all(50),
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
                padding: const EdgeInsets.all(20),
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
