// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../API/api.dart';
import '../comp/VaccineListCard.dart';

class ListAllVaccinePage extends StatefulWidget {
  ListAllVaccinePage({Key? key}) : super(key: key);

  @override
  State<ListAllVaccinePage> createState() => _ListAllVaccinePageState();
}

class _ListAllVaccinePageState extends State<ListAllVaccinePage> {
  String? token;
  String? id;
  List? vaccineList;
  List AllVaccinesList = [];

  @override
  void initState() {
    super.initState();
    initial();
  }

  filterEntry(entry) {
    /* print('filter'); */
    var formatter = DateFormat('dd-MM-yyyy');
    DateTime dt = DateTime.parse(entry['expireDate']);
    DateTime dts = DateTime.parse(entry['date']);
    entry['date'] = formatter.format(dts);
    entry['expireDate'] = formatter.format(dt);
    /* print('DATE: ');
    print(entry['expireDate']); */
    var vaccineinfo = entry['vacine_Id'];
    /* print(vaccineinfo['name']);
    print(vaccineinfo['abbrevation']);
    print(vaccineinfo['information']); */
    var filteredEntry = List<String>.filled(6, "");
    /* print('before seting up filterd: ');
    print(filteredEntry); */
    filteredEntry[0] = vaccineinfo['name'];
    filteredEntry[1] = vaccineinfo['abbrevation'];
    filteredEntry[2] = vaccineinfo['information'];
    filteredEntry[3] = vaccineinfo['url'];
    filteredEntry[4] = entry['expireDate'];
    filteredEntry[5] = entry['date'];

    /*  print('after seting up filterd: ');
    print(filteredEntry); */
    return filteredEntry;
  }

  Future getList() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    List<String> listOfEntries;
    var res = await BECall().getUserInfoById(id, 'patient', token);
    print('KSI');
    print(res);
    final List<dynamic> metadata = res['entries'];
    listOfEntries = metadata.map((e) => e.toString()).toList();
    logindata.setString('id', res['_id']);
    logindata.setStringList('entries', listOfEntries);
    final li = logindata.getStringList('entries');
    /* print('LIST');
    print(li);
    print(li!.length); */
    for (var i = 0; i <= li!.length; i++) {
      var entry = await BECall().getUserInfoById(li[i], 'entry', token);
      var result = filterEntry(entry);

      AllVaccinesList.add(result);
    }
    /* print('List of all ');
    print(AllVaccinesList); */
  }

  decodeJwt() {
    Map<String, dynamic> payload = Jwt.parseJwt(token!);
    String s = payload.toString();
    var splitted = s.split(",");
    for (var e in splitted) {
      if (e.startsWith("{user: {_id:")) {
        var idarray = e.split(" ");
        id = idarray[2];
      }
    }
  }

  getToken() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = logindata.getString('token');
    token = stringValue;
    decodeJwt();
  }

  initial() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    getToken();
    setState(() {
      vaccineList = logindata.getStringList('entries');
    });
  }

  /* final List AllVaccinesList = [
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
  ]; */

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
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: const CircularProgressIndicator(
                    backgroundColor: Colors.black26,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.black, //<-- SEE HERE
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                    itemCount: AllVaccinesList.length,
                    itemBuilder: (context, index) {
                      return VaccineListCard(
                        name: AllVaccinesList[index][0],
                        vaccination: AllVaccinesList[index][1],
                        info: AllVaccinesList[index][2],
                        expireDate: AllVaccinesList[index][4],
                        date: AllVaccinesList[index][5],
                        url: AllVaccinesList[index][3],
                      );
                    });
              }
            },
            future: getList(),
          ),
        )),
        SizedBox(
          height: 20,
        ),
      ]),
    );
  }
}
