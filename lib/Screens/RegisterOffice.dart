// ignore_for_file: prefer_const_constructors

import 'package:digitalvaccinepassport/Screens/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../API/api.dart';
import '../comp/InputField.dart';

class RegisterOfficePage extends StatefulWidget {
  const RegisterOfficePage({Key? key}) : super(key: key);

  @override
  State<RegisterOfficePage> createState() => _RegisterOfficePageState();
}

class _RegisterOfficePageState extends State<RegisterOfficePage> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final usernameController = TextEditingController();
  final doctorOfficeController = TextEditingController();
  final adressController = TextEditingController();

  late SharedPreferences logindata;

  @override
  void initState() {
    super.initState();
  }

  _attemptCreateOffice() async {
    final logindata = await SharedPreferences.getInstance();
    var data = {
      'username': usernameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'adress': adressController.text,
      'officeName': doctorOfficeController.text,
      'isCheckedByAdmin': false
    };
    /*  if (logindata.getBool('email') ?? true) {
      print('login');
    }
 */
    var res = await BECall().createBEApiCall(data, 'login/user');
    var body = json.decode(res.body);
    if (body['_id'].isEmpty) {
      // error --> not a boolean --> if body has a password value then exec. otherwise show error dialog
      showCustomDialog(context);
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create User Failed'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text(
                  'The is allready an User under this EMAIL adress registered'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Try Again'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Create an account, It's free ",
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  )
                ],
              ),
              SingleChildScrollView(
                child: Form(
                  key: formkey,
                  child: Column(
                    children: <Widget>[
                      InputFile(
                          label: "Officename",
                          controller: doctorOfficeController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a officename';
                            }
                            return null;
                          },
                          obscureText: false),
                      InputFile(
                          label: "Address",
                          controller: adressController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a address';
                            }
                            return null;
                          },
                          obscureText: false),
                      InputFile(
                          label: "Username",
                          controller: usernameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a username';
                            }
                            return null;
                          },
                          obscureText: false),
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
                          obscureText: false),
                      InputFile(
                          label: "Password",
                          controller: passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                          obscureText: true),
                      InputFile(
                          label: "Confirm Password ",
                          controller: passwordConfirmController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'PLease enter a Password';
                            }
                            if (value != passwordController.text) {
                              return "Password does not match";
                            }
                            return null;
                          },
                          obscureText: true),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 3, left: 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border(
                      bottom: BorderSide(color: Colors.black),
                      top: BorderSide(color: Colors.black),
                      left: BorderSide(color: Colors.black),
                      right: BorderSide(color: Colors.black),
                    )),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      _attemptCreateOffice();
                    } else {
                      print("UnSuccessfull");
                    }
                  },
                  color: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Already have an account?"),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text(
                      " Login ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
