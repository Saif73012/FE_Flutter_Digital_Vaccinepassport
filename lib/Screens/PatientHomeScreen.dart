// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables

import 'package:digitalvaccinepassport/Screens/AddVaccinePage.dart';
import 'package:digitalvaccinepassport/Screens/ListAllVaccinePage.dart';
import 'package:digitalvaccinepassport/Screens/qrCode.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';
import '../API/api.dart';
import 'package:intl/intl.dart';
import '../comp/InputField.dart';
import '../comp/VaccineCard.dart';

// ignore: use_key_in_widget_constructors
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
    var formatter = DateFormat('dd-MM-yyyy');
    DateTime dt = DateTime.parse(entry['expireDate']);
    DateTime dts = DateTime.parse(entry['date']);
    entry['date'] = formatter.format(dts);
    entry['expireDate'] = formatter.format(dt);

    var vaccineinfo = entry['vacine_Id'];

    var filteredEntry = List<String>.filled(6, "");

    filteredEntry[0] = vaccineinfo['name'];
    filteredEntry[1] = vaccineinfo['abbrevation'];
    filteredEntry[2] = vaccineinfo['information'];
    filteredEntry[3] = entry['date'];
    filteredEntry[4] = entry['expireDate'];
    filteredEntry[5] = vaccineinfo['url'];

    return filteredEntry;
  }

  Future getUserInfo() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();

    var res;
    List<String> listOfEntries = [];

    if (!isDoctor) {
      res = await BECall().getUserSpecial(id, 'patient', 'filtered', token);

      var tmpentry;

      var patientInfo;

      for (var i = 0; i < res.length; i++) {
        tmpentry = res[i];

        patientInfo = tmpentry['_id'];

        listOfEntries.add(patientInfo);
      }

      logindata.setStringList('entries', listOfEntries);
      final li = logindata.getStringList('entries');
      // ignore: avoid_print
      print(li!.length);

      for (var i = 0; i <= li.length; i++) {
        var entry = await BECall().getUserInfoById(li[i], 'entry', token);
        var result = filterEntry(entry);

        EntrieList.add(result);
      }
    } else {
      res = await BECall().getUserInfoById(id, 'user', token);

      logindata.setString('username', res['username']);
      logindata.setBool('ischecked', res['isCheckedByAdmin']);
      isChecked = logindata.getBool('ischecked');
    }
  }

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

    setState(() {
      vaccineList = logindata.getStringList('entries');
    });
  }

  getToken() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    String? stringValue = logindata.getString('token');
    token = stringValue;
    decodeJwt();
  }

  _sendEmailRequestAccess() async {
    await BECall().sendEmail(
      adress: adressController.text,
      email: emailController.text,
      officeName: doctorOfficeController.text,
      username: usernameController.text,
    );
  }

  _sendEmailRequestVaccine() async {
    await BECall().sendEmail2(
      message: messageController.text,
      email: emailController.text,
      officeName: doctorOfficeController.text,
      username: usernameController.text,
    );
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
                            return VaccineCard(
                              name: EntrieList[index][0],
                              vaccination: EntrieList[index][1],
                              info: EntrieList[index][2],
                              expireDate: EntrieList[index][4],
                              date: EntrieList[index][3],
                              url: EntrieList[index][5],
                            );
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
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel'))
                                    ],
                                  ),
                                );
                              } else {
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
