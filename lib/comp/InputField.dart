// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class InputFile extends StatelessWidget {
  bool obscureText = false;
  dynamic validator;
  final String label;
  dynamic controller;

  // ignore: use_key_in_widget_constructors
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
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          obscureText: obscureText,
          controller: controller,
          validator: validator,
          decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(),
              ),
              border: OutlineInputBorder(borderSide: BorderSide())),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
