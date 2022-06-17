// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:digitalvaccinepassport/Screens/AddVaccinePage.dart';
import 'package:digitalvaccinepassport/Screens/ListAllVaccinePage.dart';
import 'package:digitalvaccinepassport/Screens/qrCode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';
import '../API/api.dart';
import 'package:intl/intl.dart';
import '../comp/InputField.dart';
import '../comp/VaccineCard.dart';
import 'package:http/http.dart' as http;

class PatientHomeScreen extends StatefulWidget {
  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  bool isDoctor = false;
  String? token;
  String? username;
  String? id;
  List? vaccineList;
  bool? isChecked;
  List EntrieList = [];
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final usernameController = TextEditingController();
  final doctorOfficeController = TextEditingController();
  final adressController = TextEditingController();
  final messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getToken();
  }

  filterEntry(entry) {
    print('filter');
    var formatter = DateFormat('dd-MM-yyyy');
    DateTime dt = DateTime.parse(entry['expireDate']);
    DateTime dts = DateTime.parse(entry['date']);
    entry['date'] = formatter.format(dts);
    entry['expireDate'] = formatter.format(dt);
    /*  print('DATE: ');
    print(entry['expireDate']); */
    var vaccineinfo = entry['vacine_Id'];
    /*  print(vaccineinfo['name']);
    print(vaccineinfo['abbrevation']);
    print(vaccineinfo['information']); */
    var filteredEntry = List<String>.filled(6, "");
/*     print('before seting up filterd: ');
    print(filteredEntry); */
    filteredEntry[0] = vaccineinfo['name'];
    filteredEntry[1] = vaccineinfo['abbrevation'];
    filteredEntry[2] = vaccineinfo['information'];
    filteredEntry[3] = entry['date'];
    filteredEntry[4] = entry['expireDate'];
    filteredEntry[5] = vaccineinfo['url'];
    /* print('after seting up filterd: ');
    print(filteredEntry); */
    return filteredEntry;
  }

  Future getUserInfo() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    /*  print('vor res');
    print(id);
    print(token); */
    var res;
    List<String> listOfEntries = [];

    if (!isDoctor) {
      print('isDoctor is false');
      res = await BECall().getUserSpecial(id, 'patient', 'filtered', token);
      print('test');
      print(res);
      print('nach res ausgabe');
      print(res[0]);
      print('split:');
      //var tmp = res.toString().split('__v: 0}, __v: 0}, ');
      print('print array');
      print('entry1');
      print(res[0]);
      var tmpentry; /* = res[0]; */
      print('entry2');
      print(res[1]);
      print('entry3');
      print(res[2]);

      var patientInfo; /*  = tmpentry['patient_Id']; */
      print('patientinfo:');
      print(patientInfo);
      print('step2');

      for (var i = 0; i < res.length; i++) {
        tmpentry = res[i];
        print(tmpentry);
        patientInfo = tmpentry['_id'];

        listOfEntries.add(patientInfo);
      }

      //final List<dynamic> metadata = patientInfo['entries'];
      //listOfEntries = metadata.map((e) => e.toString()).toList();
      print('list of entries');
      print(listOfEntries);
      print('step3');
      logindata.setStringList('entries', listOfEntries);
      final li = logindata.getStringList('entries');
      print('LIST');
      print(li);
      print(li!.length);

      for (var i = 0; i <= li.length; i++) {
        var entry = await BECall().getUserInfoById(li[i], 'entry', token);
        var result = filterEntry(entry);

        EntrieList.add(result);
      }
    } else {
      print('isDoctor is true');
      res = await BECall().getUserInfoById(id, 'user', token);
      print('step1');
      logindata.setString('username', res['username']);
      logindata.setBool('ischecked', res['isCheckedByAdmin']);
      isChecked = logindata.getBool('ischecked');

      print('bool wert');
      print(isChecked);
    }

    /*   print('BE1');
    print(res);
    print('BE1 end'); */

/* conditional filtering : if doc then save id , username and status - isDoc, isApproved

 */

    /* if (id?.allMatches(res['_id']) != null) { */
    // nach namaz : id von call herausfinden und id setzen-
    /* logindata.setString('id', res['_id']); */

    //convert List of entries to StringList
    /*  print('in if und set data in store'); */

    /*  var three =
          await BECall().getUserSpecial(id, 'patient', 'filtered', token);
      for (var i = 0; i <= three.length; i++) {
        print('added');
        print(three[i]['_id']);
        listOfEntries!.add(three[i]['_id']);
      } */

    /* } */
/*     print('in if nach dem call'); */
    /* print(res);
    print('nach res'); */

    // get entry list info
    // loop durch alle elemente der listOfEntries list um getcall aufzurufen.

    /* check for last 3 enries  */
    /*
     var three = await BECall().getUserSpecial(id, 'patient', 'filtered', token);
    print('three entry');
    print(three);
    print(three.length);
    print(three[1]['_id']);
    final List lis = [];
    for (var i = 0; i <= three.length; i++) {
      lis.add(three[i]['_id']);
      print('added');
    }
    print('LIS LIST');
    print(lis); */
    /*  if (!isDoctor) {} */
  }
  // TODOO:

  // PRIO 1
  // post entry seite und be call
  // QR COde einfügen code schon da --> beim scannen string lesen
  // - token durchlesen - id herausfinden und in den state speichern dabei
  // beim ende des BE call die ID wieder löschen den state immer wieder auf
  //null setzen damit er sich resetet

  // PRIO 3
  // homepage alternative für doctor
  // done ABER -->  design etwas anderes strukturien - buttons

  // PRIO 3
  // inputfield in ein widget (dart)Page verwandelen und importieren in den seiten wo es genutzt wird.

  // PRIO 3
  // simple design für vacinepage structure ändern bzw einfach design + erweitern des durchgeführten datum sowohl im BE als auch im FE
  // + link für mehr info bearbeiten mithinzufügen.

  decodeJwt() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    Map<String, dynamic> payload = Jwt.parseJwt(token!);
    String s = payload.toString();
    var splitted = s.split(",");
    if (s.contains("adress")) {
      isDoctor = true;
    }
    for (var e in splitted) {
      if (e.startsWith("{user: {_id:")) {
        var idarray = e.split(" ");
        id = idarray[2];
        logindata.setString('id', id!);
      } else if (e.startsWith(' username:')) {
        var usernameArray = e.split(" ");
        username = usernameArray[2];
      }
    }
    print('isDoctor VALUE:');
    print(isDoctor);
    print('gettoken finish');
    setState(() {
      /* username = logindata.getString('username'); */
      print('setstate1');
      //print(logindata.getStringList('entries'));
      vaccineList = logindata.getStringList('entries');
    });
  }

  getToken() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = logindata.getString('token');
    token = stringValue;
    print('gettoken finish');
    decodeJwt();
    print('username state:');
    print(username);
  }

  // ignore: non_constant_identifier_names
  /*  vaccineList; */ /* = [
    // name , shortname , info , date
     ['Astrazenica', 'Astra', 'Impfung gegen Covid-19', '20.02.2021'],
    ['JohnsenJohnsen', 'J&J', 'Impfung gegen Covid-19', '20.08.2021'],
    ['Biontech Pfizer', 'Pfizer', 'Impfung gegen Covid-19', '20.01.2022'],
  ]; */

  _sendEmailRequestAccess() async {
    var res2 = await BECall().sendEmail(
      adress: adressController.text,
      email: emailController.text,
      officeName: doctorOfficeController.text,
      username: usernameController.text,
    );
    var body = res2.toString();
    print('body email:');
    print(body);
  }

  _sendEmailRequestVaccine() async {
    var res2 = await BECall().sendEmail2(
      message: messageController.text,
      email: emailController.text,
      officeName: doctorOfficeController.text,
      username: usernameController.text,
    );
    var body = res2.toString();
    print('body email:');
    print(body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          if (isDoctor == false) ...{
            FutureBuilder(
              builder: (context, snapshot) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40),
                      Padding(
                        padding: EdgeInsets.only(left: 25, right: 25),
                        child: Container(
                          child: Center(child: Text('Hello $username!')),
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
                          label: Text(
                              'Click here to Add a new Vaccine'), // <-- Text
                          backgroundColor: Colors.black,
                          icon: Icon(
                            // <-- Icon
                            Icons.medication,
                            size: 24.0,
                          ),
                          onPressed: () {
                            print('object');
                            //getToken();
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
                          itemCount: EntrieList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: ((context, index) {
                            /*  if (EntrieList.isNotEmpty) {
                            print('NOT EMPTY');
                            print(vaccineList);
                            print(EntrieList.length); */
                            return VaccineCard(
                              name: EntrieList[index][0],
                              vaccination: EntrieList[index][1],
                              info: EntrieList[index][2],
                              expireDate: EntrieList[index][4],
                              date: EntrieList[index][3],
                              url: EntrieList[index][5],
                            );
                            /*  } else {
                            print('EMPTY');
                  
                            return Container(
                              margin: EdgeInsets.all(20.0),
                              alignment: Alignment.center,
                              child: Text('empty Space'),
                            );
                          } */
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
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ListAllVaccinePage()));
                          },
                        ),
                      ),
                    ]);
              },
              future: getUserInfo(),
            ),
          } else ...{
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: Container(
                  child: Center(child: Text('Hello $username!')),
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
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [],
              ),
              SizedBox(
                height: 50,
              ),
              FutureBuilder(
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      if (isChecked == true)
                        Center(
                          widthFactor: 20,
                          child: FloatingActionButton.extended(
                            heroTag: 'navigate to QRCodeScanner',
                            label: Text(
                                'Click here to Add a new Vaccine'), // <-- Text
                            backgroundColor: Colors.black,
                            icon: Icon(
                              // <-- Icon
                              Icons.plus_one,
                              size: 24.0,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => QRCodeScanner()));
                            },
                          ),
                        ),
                      if (isChecked == false)
                        Center(
                          widthFactor: 20,
                          child: ElevatedButton.icon(
                              onPressed: null,
                              label: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Text(
                                  'Click here to Add a new Vaccine',
                                  style: TextStyle(),
                                ),
                              ),
                              icon: Icon(
                                Icons.check,
                                size: 24.0,
                              ),
                              style: ElevatedButton.styleFrom(
                                  shape: StadiumBorder())),
                        ),
                      SizedBox(
                        height: 50,
                      ),
                      if (isChecked == false)
                        Center(
                          widthFactor: 20,
                          child: FloatingActionButton.extended(
                            heroTag: 'email_Create_Access',
                            onPressed: () {
                              if (isChecked == false) {
                                print(
                                    'method for emailing request for accsess');
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                        'Request to grant Accsess to add Functionality'),
                                    content: SingleChildScrollView(
                                      child: Form(
                                        key: formkey,
                                        child: Column(children: <Widget>[
                                          InputFile(
                                            label: "Officename",
                                            controller: doctorOfficeController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter a officename';
                                              }
                                              return null;
                                            },
                                            obscureText: false,
                                          ),
                                          InputFile(
                                            label: "Address",
                                            controller: adressController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter a address';
                                              }
                                              return null;
                                            },
                                            obscureText: false,
                                          ),
                                          InputFile(
                                            label: "Username",
                                            controller: usernameController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter a username';
                                              }
                                              return null;
                                            },
                                            obscureText: false,
                                          ),
                                          InputFile(
                                            label: "Email",
                                            controller: emailController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter a Email';
                                              }
                                              if (!RegExp(
                                                      "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                                  .hasMatch(value)) {
                                                return 'Please enter a valid Email';
                                              }
                                              return null;
                                            },
                                            obscureText: false,
                                          ),
                                        ]),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            final snackBar = SnackBar(
                                                content: Text('Email send.'));
                                            _sendEmailRequestAccess();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                            Navigator.pop(context);
                                          },
                                          child: Text('Submit')),
                                      TextButton(
                                          onPressed: () {
                                            print('canceled');
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel'))
                                    ],
                                  ),
                                );
                              } else {
                                print('bereits TRUE');
                                null;
                              }
                            },
                            label: Text(
                                'Click to request Doctor Accsess'), // <-- Text
                            icon: Icon(
                              // <-- Icon
                              Icons.check,
                              size: 24.0,
                            ),
                            backgroundColor: Colors.black,
                          ),
                        ),
                      if (isChecked == true)
                        Center(
                          widthFactor: 20,
                          child: ElevatedButton.icon(
                              onPressed: null,
                              label: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Text(
                                  'Click to request Doctor Accsess',
                                  style: TextStyle(),
                                ),
                              ),
                              icon: Icon(
                                Icons.check,
                                size: 24.0,
                              ),
                              style: ElevatedButton.styleFrom(
                                  shape: StadiumBorder())),
                        ),
                      SizedBox(
                        height: 50,
                      ),
                      Center(
                        widthFactor: 20,
                        child: FloatingActionButton.extended(
                          heroTag: 'email_Create_New_Vaccine',
                          onPressed: () {
                            print(
                                'method for emailing request for a new vaccine');
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                    'Email Admin to grant Accsess to add Functionality'),
                                content: SingleChildScrollView(
                                  child: Form(
                                    key: formkey,
                                    child: Column(children: <Widget>[
                                      InputFile(
                                        label: "Officename",
                                        controller: doctorOfficeController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a officename';
                                          }
                                          return null;
                                        },
                                        obscureText: false,
                                      ),
                                      InputFile(
                                        label: "Username",
                                        controller: usernameController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a username';
                                          }
                                          return null;
                                        },
                                        obscureText: false,
                                      ),
                                      InputFile(
                                        label: "Email",
                                        controller: emailController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a Email';
                                          }
                                          if (!RegExp(
                                                  "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                              .hasMatch(value)) {
                                            return 'Please enter a valid Email';
                                          }
                                          return null;
                                        },
                                        obscureText: false,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Message",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black87),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller: messageController,
                                            maxLines: 4,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter a address';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 0,
                                                        horizontal: 10),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(),
                                                ),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide())),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      ),
                                    ]),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        final snackBar = SnackBar(
                                            content: Text('Email send.'));
                                        _sendEmailRequestVaccine();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        Navigator.pop(context);
                                      },
                                      child: Text('Submit')),
                                  TextButton(
                                      onPressed: () {
                                        print('cancel');
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel'))
                                ],
                              ),
                            );
                          },
                          label: Text(
                              'Click to request a new Vaccine'), // <-- Text
                          backgroundColor: Colors.black,
                          icon: Icon(
                            // <-- Icon
                            Icons.medication,
                            size: 24.0,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                future: getUserInfo(),
              ),
            ]),
          }
        ],
      ),
    );
  }
}

// we will be creating a widget for text field

