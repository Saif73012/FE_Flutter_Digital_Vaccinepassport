import 'package:flutter/material.dart';

class InputFile extends StatelessWidget {
  bool obscureText = false;
  dynamic validator;
  final String label;
  dynamic controller;

  InputFile(
      {required this.label,
      required this.controller,
      required this.validator,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          obscureText: obscureText,
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(),
              ),
              border: OutlineInputBorder(borderSide: BorderSide())),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
