import 'package:flutter/material.dart';

class buildTextField extends StatelessWidget {
  final String label;
  final String prefix;
  final TextEditingController c;
  final TextInputType inputType;

  buildTextField({this.label, this.prefix, this.c, this.inputType});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: c,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        prefixText: prefix,
      ),
      style: TextStyle(
        fontSize: 18.0,
      ),
      keyboardType: inputType,
    );
  }
}
