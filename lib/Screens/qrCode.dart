// ignore_for_file: use_key_in_widget_constructors

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../API/api.dart';

class QRCodeScanner extends StatefulWidget {
  @override
  _QRCodeScannerState createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  String _scanedtoken = 'Unknown';
  DateTime selectedDate = DateTime.now();
  bool isDateSelected = false;
  String selectedItem = 'Choose a Vaccine';
  String? token;
  List vaccineList = [];
  String? patient_Id = '';
  String? user_Id = '';
  String? vaccine_Id = '';
  List<String> listOfVaccineNames = ['Choose a Vaccine'];
  List listOfVaccins = [];

  @override
  void initState() {
    super.initState();
    getUserInfo();
    getVaccineInfo();
    setState(() {});
  }

  filterVaccine(vaccine) {
    var filteredVaccines = List<String>.filled(2, "");
    filteredVaccines[0] = vaccine['_id'];
    filteredVaccines[1] = vaccine['name'];
    return filteredVaccines;
  }

  getVaccineId(vaccineItem) {
    if (vaccineItem.toString().contains('Choose a Vaccine')) {
    } else {
      setState(() {
        selectedItem = vaccineItem!;
      });

      for (var i = 0; i < listOfVaccins.length; i++) {
        if (listOfVaccins[i][1] == vaccineItem) {
          vaccine_Id = listOfVaccins[i][0];
        }
      }
    }
  }

  getVaccineInfo() async {
    var res = await BECall().getRouteInfo('vacine', token);

    for (var i = 0; i < res.length; i++) {
      if (!listOfVaccineNames.contains(res[i]['name'])) {
        listOfVaccineNames.add(res[i]['name']);
      }
      var result = filterVaccine(res[i]);
      listOfVaccins.add(result);
    }
  }

  getUserInfo() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    token = logindata.getString('token');
    user_Id = logindata.getString('id');
    getVaccineInfo();
  }

  decodeJson(token) {
    Map<String, dynamic> payload = Jwt.parseJwt(token!);
    String s = payload.toString();
    var splitted = s.split(",");
    //var idp;
    for (var e in splitted) {
      if (e.startsWith("{user: {_id:")) {
        var idarray = e.split(" ");
        patient_Id = idarray[2];
      }
    }
    setState(() {});
  }

  getPatientInfo(String token) async {
    decodeJson(token);

    var res = await BECall().getUserInfoById(patient_Id, 'patient', token);
    // ignore: avoid_print
    print(res);
  }

  attemptCreateEntry() async {
    var data = {
      'expireDate': selectedDate.toString(),
      'date': DateTime.now().toString(),
      'patient_Id': patient_Id,
      'vacine_Id': vaccine_Id,
      'user_Id': user_Id,
    };

    var res = await BECall().createEntry(data, 'entry', token);
    var body = json.decode(res.body);
    if (body.toString().contains('error')) {
      const snackBar = SnackBar(content: Text('Failed. Try Again!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (body['id'].toString().isNotEmpty) {
      const snackBar = SnackBar(content: Text('Entry safed.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context);
    } else {
      const snackBar = SnackBar(content: Text('Failed. Try Again!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2010),
      lastDate: DateTime(2040),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        isDateSelected = true;
      });
    }
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _scanedtoken = barcodeScanRes;
    });

    getPatientInfo(_scanedtoken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          const SizedBox(height: 40),
          const Expanded(
            flex: 1,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  'Creating a new Entry for Patient',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                )),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 30),
                child: Column(
                  children: const [
                    Icon(Icons.warning_sharp, size: 20.0),
                    Center(
                        child: Text(
                      'To create a new Entry you need to follow these steps:\n 1. Choose a expiredate! \n 2. Click the button with the Camera and Scan the QR-Code of the Patients Smartphone. \n 3. Choose a Vaccine from the Dropdown menu! \n 4. click the send button to add the entry ',
                      style: TextStyle(fontSize: 12),
                    )),
                  ],
                ),
                width: double.infinity,
                height: 150,
                color: Colors.grey[400],
              ),
            ),
          ),
          Expanded(
            flex: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: FloatingActionButton.extended(
                heroTag: 'pick_expiredate',
                onPressed: () => _selectDate(context),
                label: const Text('pick expire date'),
                backgroundColor: Colors.black,
                icon: const Icon(
                  Icons.calendar_today,
                  size: 24.0,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: FloatingActionButton.extended(
                heroTag: 'scan_QR_Code',
                onPressed: () => scanQR(),
                label: const Text('Scan QC-Code'), // <-- Text
                backgroundColor: Colors.black,
                icon: const Icon(
                  // <-- Icon
                  Icons.camera_enhance,
                  size: 24.0,
                ),
              ),
            ),
          ),
          if (isDateSelected) ...[
            Expanded(
              flex: 0,
              child: Container(
                padding: const EdgeInsets.only(
                    bottom: 0, left: 10, right: 10, top: 10),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20)),
                child: DropdownButton<String>(
                  dropdownColor: Colors.grey[800],
                  value: selectedItem,
                  onChanged: (vaccine) => getVaccineId(vaccine),
                  items: listOfVaccineNames
                      .map((vaccine) => DropdownMenuItem<String>(
                            value: vaccine,
                            child: Text(
                              vaccine,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                            ),
                          ))
                      .toList(),
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 35,
                  underline: const SizedBox(),
                ),
              ),
            ),
          ] else ...[
            Expanded(
              flex: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(197, 197, 197, 1),
                    borderRadius: BorderRadius.circular(20)),
                child: DropdownButton<String>(
                  value: selectedItem,
                  onChanged: null,
                  items: listOfVaccineNames
                      .map((vaccine) => DropdownMenuItem<String>(
                            value: vaccine,
                            child: Text(
                              vaccine,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                            ),
                          ))
                      .toList(),
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 35,
                  underline: const SizedBox(),
                ),
              ),
            ),
          ],
          Expanded(
            flex: 1,
            child: Container(
              alignment: FractionalOffset.center,
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
              child: FloatingActionButton.extended(
                heroTag: 'create_Entry',
                label: const Text('Click to create a entry'), // <-- Text
                backgroundColor: Colors.black,
                icon: const Icon(
                  Icons.description,
                  size: 24.0,
                ),
                onPressed: () {
                  attemptCreateEntry();
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
