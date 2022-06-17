// prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:digitalvaccinepassport/Screens/PatientHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../API/api.dart';
import 'RegisterPage.dart';

const ip = 'https://das-digitale-impfbuch.herokuapp.com/';

// ignore: use_key_in_widget_constructors
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
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
      builder: (context) => const Center(
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

    var res = await BECall().login(data, 'login');
    var body = json.decode(res.body);

    if (body['success']) {
      logindata.setString('token', body['token']);
      logindata.setString('email', emailController.text);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => PatientHomeScreen()));
    } else {
      const snackBar = SnackBar(
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Login to your account",
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      padding: const EdgeInsets.only(top: 3, left: 3),
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
                        child: const Text(
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
                      const Text("Don't have an account?"),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterPage()));
                        },
                        child: const Text(
                          " Sign up",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                  Ink(
                    color: Colors.grey[400],
                    child: Column(
                      children: const [
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
                    padding: const EdgeInsets.only(top: 100),
                    height: 100,
                    decoration: const BoxDecoration(
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
                          icon: const Icon(Icons.info_outline, size: 10),
                          onPressed: () async {
                            const url =
                                'https://www.flaticon.com/free-icons/medical';
                            _launchUrl(url);
                          },
                        ),
                        const Text(
                            'Medical icons created by SBTS2018 - Flaticon',
                            style: TextStyle(fontSize: 10)),
                      ],
                    ),
                    Center(
                      child: Row(
                        children: const [
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
