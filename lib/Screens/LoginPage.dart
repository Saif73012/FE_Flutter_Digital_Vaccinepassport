// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:digitalvaccinepassport/Screens/PatientHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../API/api.dart';
import 'RegisterPage.dart';

const ip = 'https://das-digitale-impfbuch.herokuapp.com/';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  SharedPreferences? logindata;
  bool? newuser;

  @override
  void initState() {
    super.initState();
    //check_if_already_login();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

/*   void check_if_already_login() async {
    final SharedPreferences logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('email') ?? true);
    print(newuser);
    if (newuser == false) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => PatientHomeScreen()));
    }
  } */

  void _launchUrl(url) async {
    if (!await launchUrl(url!)) {
      throw 'CouldUri.parse( not launch  $url)';
    } else {
      await launchUrl(url);
    }
  }

  _attemptLogin(context) async {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.black26,
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.black, //<-- SEE HERE
          ),
        ),
      ),
    );

    SharedPreferences logindata = await SharedPreferences.getInstance();
    var data = {
      'email': emailController.text,
      'password': passwordController.text,
    };

    var res2 = await BECall().login2(data, 'login');
    /* var body2 = json.decode(res.body); */
    var body2 = res2.toString();
    /*  print('body2: ' + body2);
    print('vor res2 ausgabe');
    print(res2);
    print(res2.runtimeType);
    print(body2.runtimeType);
    print('body2: ' + body2); */
    var res = await BECall().login(data, 'login');
    var body = json.decode(res.body);
    if (body2.contains('success')) {
      print('trueeeeee ');
    }

    if (body['success']) {
      print('login success');
      logindata.setString('token', body['token']);
      //logindata.setBool('login', false);
      logindata.setString('email', emailController.text);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => PatientHomeScreen()));
    } else {
      final snackBar = SnackBar(
          content: Text(
              'login failed. Try Again! If you have no account sign up.  '));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
    }
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
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Login to your account",
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      padding: EdgeInsets.only(top: 3, left: 3),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () {
                          _attemptLogin(context);
                        },
                        color: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Don't have an account?"),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()));
                        },
                        child: Text(
                          " Sign up",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                  Ink(
                    color: Colors.grey[400],
                    child: Column(
                      children: [
                        Icon(Icons.warning, size: 15.0),
                        Text(
                          'for the current release there is no funtionality if you have forgotten your password',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 100),
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/medical-symbol.png"),
                          fit: BoxFit.fitHeight),
                    ),
                  )
                ],
              ),
            ),
            BottomAppBar(
              child: Container(
                decoration: BoxDecoration(color: Colors.grey[300]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.info_outline, size: 10),
                          onPressed: () async {
                            const url =
                                'https://www.flaticon.com/free-icons/medical';
                            _launchUrl(url);
                          },
                        ),
                        Text('Medical icons created by SBTS2018 - Flaticon',
                            style: TextStyle(fontSize: 10)),

                        /* Text(
                            '<a href="https://www.flaticon.com/free-icons/medical" title="medical icons">Medical icons created by SBTS2018 - Flaticon</a>'), */
                      ],
                    ),
                    Center(
                      child: Row(
                        children: [
                          Text(' Copyright', style: TextStyle(fontSize: 10)),
                          Icon(
                            Icons.copyright,
                            size: 10,
                          ),
                          Text(
                            'All Rights Reserved',
                            style: TextStyle(fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
