// ignore_for_file: non_constant_identifier_names

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
    print(listOfVaccineNames);
    print('vaccineItem');
    print(selectedItem);
    if (vaccineItem.toString().contains('Choose a Vaccine')) {
      print('not');
    } else {
      setState(() {
        selectedItem = vaccineItem!;
      });

      for (var i = 0; i < listOfVaccins.length; i++) {
        if (listOfVaccins[i][1] == vaccineItem) {
          vaccine_Id = listOfVaccins[i][0];
        }
      }
      print(vaccine_Id);
      print(selectedItem);
    }
  }

  getVaccineInfo() async {
    /* TODO: 
    
      getlist - make optioninput afterset -- after pick - 
      forloop if the name of the list 
      check whether the vacine is in list 
      if so --> setz die id des gesetzten vaccine in den state/variable;
      //done mit dem ssetzten 


      __> funktioniert alles aber drobdown ist nicht sychron 
      https://stackoverflow.com/questions/56815603/flutter-dropdownbutton-using-futurebuilder-for-json-response
    bau es so damit es funktinoiert und dann siehe unten

    --> QRcode scan test fehlt 
    --> die zwei buttons fehlen 
    

      UI -
       wenn id gesetzt ist und mache den button disabled - wie in addVacinePage mit if und featureBUilder
      außerdem zwei butttons --> 
      eintragen/ safe --> dialog mit all den daten -bei bestätigung an be senden 
      --> attemptCreateEntry() aufrufen

      cancel button - navigator.pop()

     */

    var res = await BECall().getRouteInfo('vacine', token);

    for (var i = 0; i < res.length; i++) {
      if (!listOfVaccineNames.contains(res[i]['name'])) {
        listOfVaccineNames.add(res[i]['name']);
      }
      // die beiden werte in einem Array packen und das array in die liste -->
      var result = filterVaccine(res[i]);
      /* print(result); */
      listOfVaccins.add(result);

      // todo: umwandeln
      //done

      //mit der fertigen liste kann ich ein selectinput widget machen und dann bei
      //select in die liste schauen mit den namen und die id herausfinden und in den state packen

      //todo : datum von impfung hinzufügen - class an sich und ui plus design
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

    // villt nicht nötig
    SharedPreferences logindata = await SharedPreferences.getInstance();

    var res = await BECall().getUserInfoById(patient_Id, 'patient', token);
    //
  }

  attemptCreateEntry() async {
    var data = {
      'expireDate': selectedDate.toString(),
      'date': DateTime.now().toString(),
      'patient_Id': patient_Id,
      'vacine_Id': vaccine_Id,
      'user_Id': user_Id,
    };
    print(data);

    var res = await BECall().createEntry(data, 'entry', token);
    var body = json.decode(res.body);
    print(body);
    if (body.toString().contains('error')) {
      // error --> not a boolean --> if body has a password value then exec. otherwise show error dialog
      final snackBar = SnackBar(content: Text('Failed. Try Again!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (!body['id'].toString().isEmpty) {
      final snackBar = SnackBar(content: Text('Entry safed.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context);
    } else {
      final snackBar = SnackBar(content: Text('Failed. Try Again!'));
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
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanedtoken = barcodeScanRes;
    });

    getPatientInfo(_scanedtoken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: Column(
        /* crossAxisAlignment: CrossAxisAlignment.start, */
        children: [
          SizedBox(height: 40),
          Expanded(
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
              padding: EdgeInsets.only(left: 25, right: 25),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 30),
                child: Column(
                  children: [
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
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: FloatingActionButton.extended(
                heroTag: 'pick_expiredate',
                onPressed: () => _selectDate(context),
                label: Text('pick expire date'), // <-- Text
                backgroundColor: Colors.black,
                icon: Icon(
                  // <-- Icon
                  Icons.calendar_today,
                  size: 24.0,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: FloatingActionButton.extended(
                heroTag: 'scan_QR_Code',
                onPressed: () => scanQR(),
                label: Text('Scan QC-Code'), // <-- Text
                backgroundColor: Colors.black,
                icon: Icon(
                  // <-- Icon
                  Icons.camera_enhance,
                  size: 24.0,
                ),
              ),
            ),
          ),
          if (isDateSelected) ...[
            Expanded(
              flex: 1,
              child: Container(
                padding:
                    EdgeInsets.only(bottom: 0, left: 10, right: 10, top: 10),
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
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                            ),
                          ))
                      .toList(),
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 35,
                  underline: SizedBox(),
                ),
              ),
            ),
          ] else ...[
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(197, 197, 197, 1),
                    borderRadius: BorderRadius.circular(20)),
                child: DropdownButton<String>(
                  value: selectedItem,
                  onChanged: null,
                  items: listOfVaccineNames
                      .map((vaccine) => DropdownMenuItem<String>(
                            value: vaccine,
                            child: Text(
                              vaccine,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                            ),
                          ))
                      .toList(),
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 35,
                  underline: SizedBox(),
                ),
              ),
            ),
          ],
          Expanded(
            flex: 1,
            child: Container(
              alignment: FractionalOffset.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FloatingActionButton.extended(
                    heroTag: 'navigate_back_to_HomePage',
                    label: Text('Click to create a entry'), // <-- Text
                    backgroundColor: Colors.black,
                    icon: Icon(
                      Icons.description,
                      size: 24.0,
                    ),
                    onPressed: () {
                      attemptCreateEntry();
                    },
                  ),
                  FloatingActionButton.extended(
                    heroTag: 'navigate_back_to_HomePage',
                    label: Text('Cancel'), // <-- Text
                    backgroundColor: Colors.black,
                    icon: Icon(
                      Icons.arrow_left,
                      size: 24.0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          /* Container( 
            alignment: Alignment.center,
            child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: FloatingActionButton.extended(
                      heroTag: 'pick_expiredate',
                      onPressed: () => _selectDate(context),
                      label: Text('pick expire date'), // <-- Text
                      backgroundColor: Colors.black,
                      icon: Icon(
                        // <-- Icon
                        Icons.calendar_today,
                        size: 24.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FloatingActionButton.extended(
                    heroTag: 'scan_QR_Code',
                    onPressed: () => scanQR(),
                    label: Text('Scan QC-Code'), // <-- Text
                    backgroundColor: Colors.black,
                    icon: Icon(
                      // <-- Icon
                      Icons.camera_enhance,
                      size: 24.0,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: 300,
                    child: DropdownButtonFormField<String>(
                      dropdownColor: Colors.grey[800],
                      decoration: InputDecoration(
                          fillColor: Colors.black,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(width: 3, color: Colors.black))),
                      value: selectedItem,
                      items: listOfVaccineNames
                          .map((vaccine) => DropdownMenuItem<String>(
                                value: vaccine,
                                child: Text(
                                  vaccine,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24.0),
                                ),
                              ))
                          .toList(),
                      onChanged: (vaccine) => getVaccineId(vaccine),
                    ),
                  ),
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      attemptCreateEntry();
                    },
                    color: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      "send",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      "cancel",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  /* Text('Scan result : $_scanedtoken\n',
                      style: TextStyle(fontSize: 20)),
                  Text('datepicker result : $selectedDate\n',
                      style: TextStyle(fontSize: 20)),
                  Text('dropdown result : $selectedItem\n',
                      style: TextStyle(fontSize: 20)), */
                ]),
          ),*/
        ],
      ),
    );
  }
}
